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

  basePkg =
    if pkgs.stdenv.isLinux then pkgs.localPkgs.pdf2zh-next-fhs else pkgs.localPkgs.pdf2zh-next;

  mkPdf2zh =
    {
      name,
      withEnv,
    }:
    pkgs.writeShellApplication {
      inherit name;

      text = ''
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

              CMD_ARGS+=(
                "--openaicompatible"
                "--openai-compatible-model" "$MODEL"
                "--openai-compatible-base-url" "$API_BASE"
                "--openai-compatible-api-key" "$API_KEY"
                "--openai-compatible-timeout" "5"
              )
            ''
          else
            ""
        }

        exec ${lib.getExe basePkg} "''${CMD_ARGS[@]}" "$@"
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
    {
      nixdefs.llm.enable = true;

      home.packages = [
        pdf2zhRunner
        pdf2zhUnwrapped
      ];
    }

    (mkIf llm.enable {
      home.sessionVariables = {
        PDF2ZH_MODEL = llm.routing.translation.model;
        PDF2ZH_API_BASE = (queryProvider llm.routing.translation.provider).baseUrl;
      };
    })

    (mkIf pkgs.stdenv.isLinux (mkMerge [
      {
        xdg.desktopEntries.pdf2zh = {
          name = "pdf2zh";
          genericName = "PDF Translator";
          comment = descZh;
          exec = "pdf2zh \"%f\"";
          icon = "translate";
          terminal = false;
          categories = [
            "Office"
            "Utility"
          ];
          mimeType = [ "application/pdf" ];
          actions = {
            webui = {
              name = "打开 WebUI";
              exec = "pdf2zh --gui";
            };
          };
        };
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
              exec = "pdf2zh \"%f\"";
            };
          };
        };
      })
    ]))
  ]);
}
