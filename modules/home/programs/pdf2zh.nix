{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkMerge;
  cfg = config.programs.pdf2zh;

  llm = config.nixdefs.llm;
  queryProvider = provider: llm.providers."${provider}";

  imageTag = "ghcr.io/pdfmathtranslate/pdfmathtranslate-next";
  # version = "2.6.4";
  mkPdf2zh =
    {
      name,
      withEnv,
    }:
    pkgs.writeShellApplication {
      inherit name;

      runtimeInputs = [ pkgs.podman ];

      text = ''
        IMAGE_TAG="${imageTag}"

        if ! podman image exists "$IMAGE_TAG"; then
          echo "[pdf2zh] Pulling image $IMAGE_TAG ..."
          podman pull "$IMAGE_TAG"
        fi

        PODMAN_ENV_ARGS=()
        CMD_ARGS=()

        ${
          if withEnv then
            ''
              API_BASE="''${PDF2ZH_API_BASE:-https://openrouter.ai/api/v1}"
              MODEL="''${PDF2ZH_MODEL:-google/gemini-3-flash-preview}"

              if [[ -n "''${PDF2ZH_API_KEY:-}" ]]; then
                API_KEY="$PDF2ZH_API_KEY"
              elif [[ -n "''${OPENROUTER_API_KEY:-}" ]]; then
                API_KEY="$OPENROUTER_API_KEY"
              else
                echo "Error: Neither OPENROUTER_API_KEY nor PDF2ZH_API_KEY is set." >&2
                echo "Please export one of them explicitly." >&2
                exit 1
              fi

              echo "[pdf2zh] Using Model: $MODEL"

              PODMAN_ENV_ARGS+=("-e" "OPENROUTER_API_KEY=$API_KEY")

              CMD_ARGS+=(
                "--openaicompatible"
                "--openai-compatible-model" "$MODEL"
                "--openai-compatible-base-url" "$API_BASE"
                "--openai-compatible-api-key" "$API_KEY"
              )
            ''
          else
            ""
        }

        exec podman run \
          --rm \
          -it \
          -p 7860:7860 \
          -v "$(pwd):/data" \
          -w /data \
          "''${PODMAN_ENV_ARGS[@]}" \
          "$IMAGE_TAG" \
          pdf2zh \
          "''${CMD_ARGS[@]}" \
          "$@"
      '';
    };

  pdf2zhRunner = mkPdf2zh {
    name = "pdf2zh";
    withEnv = true;
  };
  pdf2zhUnwrapped = mkPdf2zh {
    name = "pdf2zh-unwrapped";
    withEnv = false;
  };

  descEn = "PDF scientific paper translation with preserved formats";
  descZh = "基于 AI 完整保留排版的 PDF 文档全文双语翻译";
in
{
  options.programs.pdf2zh = {
    enable = mkEnableOption "pdf2zh translation tool";
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf llm.enable {
      home.sessionVariables = {
        PDF2ZH_MODEL = llm.routing.translation.model;
        PDF2ZH_API_BASE = (queryProvider llm.routing.translation.provider).baseUrl;
      };
    })

    (mkIf pkgs.stdenv.isLinux (mkMerge [
      {
        services.podman.enable = true;

        services.podman.images.pdf2zh = {
          image = imageTag;
          description = " ${descEn} - ${descZh}，支持 Google/DeepL/Ollama/OpenAI 等服务，提供 CLI/GUI/Docker";
        };

        home.packages = [
          pdf2zhRunner
          pdf2zhUnwrapped
        ];

        nixdefs.llm.enable = true;
      }
      (mkIf config.programs.dolphin.enable {
        programs.dolphin.services.pdf2zh = {
          mimeType = "application/pdf;";
          icon = "translate";
          desktopEntryExtra = {
            "X-KDE-Priority" = "TopLevel";
            "X-KDE-StartupNotify" = false;
          };
          actions = {
            translateToZh = {
              name = "翻译为中文";
              exec = "pdf2zh --openaicompatible \"%f\"";
            };
          };
        };
      })
    ]))

    (mkIf pkgs.stdenv.isDarwin {
      home.packages = [ pkgs.uv ];
      home.activation.uvInstallPdf2Zh = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p "$HOME/.local/bin"
        if [ ! -f $HOME/.local/bin/pdf2zh ]; then
          uv tool install pdf2zh-next
        fi
      '';
    })
  ]);
}
