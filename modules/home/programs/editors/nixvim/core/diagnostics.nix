{ ... }:
{
  programs.nixvim = {
    diagnostic.settings = {
      virtual_text = true;
      virtual_lines = false;
      severity_sort = true;
      update_in_insert = true;
      float = true;
      signs = {
        text = {
          HINT = "";
          WARN = "";
          ERROR = "";
        };
      };
    };
  };
}
