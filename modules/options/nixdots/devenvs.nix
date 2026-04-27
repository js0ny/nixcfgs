{ lib, config, ... }:
{
  options.nixdots.devenvs = {
    global = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Default option to install devenv packages to PATH";
    };
    c = {
      enable = lib.mkEnableOption "Whether to enable C devenv";
      global = lib.mkOption {
        type = lib.types.bool;
        default = config.nixdots.devenvs.global;
        description = "Whether to install C devenv packages with PATH";
      };
    };
    go = {
      enable = lib.mkEnableOption "Whether to enable Go devenv";
      global = lib.mkOption {
        type = lib.types.bool;
        default = config.nixdots.devenvs.global;
        description = "Whether to install Go devenv packages with PATH";
      };
    };
    java = {
      enable = lib.mkEnableOption "Whether to enable Java devenv";
      global = lib.mkOption {
        type = lib.types.bool;
        default = config.nixdots.devenvs.global;
        description = "Whether to install Java devenv packages with PATH";
      };
    };
    latex = {
      enable = lib.mkEnableOption "Whether to enable LaTeX devenv";
      global = lib.mkOption {
        type = lib.types.bool;
        default = config.nixdots.devenvs.global;
        description = "Whether to install LaTeX devenv packages with PATH";
      };
    };
    lua = {
      enable = lib.mkEnableOption "Whether to enable Lua devenv";
      global = lib.mkOption {
        type = lib.types.bool;
        default = config.nixdots.devenvs.global;
        description = "Whether to install Lua devenv packages with PATH";
      };
    };
    nix = {
      enable = lib.mkEnableOption "Whether to enable Nix devenv";
      global = lib.mkOption {
        type = lib.types.bool;
        default = config.nixdots.devenvs.global;
        description = "Whether to install Nix devenv packages with PATH";
      };
    };
    python = {
      enable = lib.mkEnableOption "Whether to enable Python devenv";
      global = lib.mkOption {
        type = lib.types.bool;
        default = config.nixdots.devenvs.global;
        description = "Whether to install Python devenv packages with PATH";
      };
    };
    rust = {
      enable = lib.mkEnableOption "Whether to enable Rust devenv";
      global = lib.mkOption {
        type = lib.types.bool;
        default = config.nixdots.devenvs.global;
        description = "Whether to install Rust devenv packages with PATH";
      };
    };
    typst = {
      enable = lib.mkEnableOption "Whether to enable Typst devenv";
      global = lib.mkOption {
        type = lib.types.bool;
        default = config.nixdots.devenvs.global;
        description = "Whether to install Typst devenv packages with PATH";
      };
    };
    verilog = {
      enable = lib.mkEnableOption "Whether to enable Verilog devenv";
      global = lib.mkOption {
        type = lib.types.bool;
        default = config.nixdots.devenvs.global;
        description = "Whether to install Verilog devenv packages with PATH";
      };
    };
    markdown = {
      enable = lib.mkEnableOption "Whether to enable markdown devenv";
      global = lib.mkOption {
        type = lib.types.bool;
        default = config.nixdots.devenvs.global;
        description = "Whether to install Markdown devenv packages with PATH";
      };
    };
  };
}
