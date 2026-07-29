{ secrets, ... }: {
  imports = [ ./llm.nix ];
  nixdefs.endpoints = import "${secrets}/plain/endpoints.nix";
}
