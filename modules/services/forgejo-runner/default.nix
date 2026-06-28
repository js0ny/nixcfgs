{
  flake.nixosModules.forgejo-runner =
    {
      config,
      lib,
      secrets,
      ...
    }:
    let
      ep = config.nixdefs.endpoints;
    in
    { }
  # lib.mkIf (ep.forgejo.publicUrl != null) {
  #   sops.secrets.forgejo_runner_token = {
  #     sopsFile = secrets + /forgejo.yaml;
  #   };
  #
  #   sops.templates."forgejo-runner.env".content = /* bash */ ''
  #     TOKEN="${config.sops.placeholder.forgejo_runner_token}"
  #   '';
  #
  #   services.gitea-actions-runner.instances.main = {
  #     enable = true;
  #     name = "${config.networking.hostName}-main";
  #     url = ep.forgejo.publicUrl;
  #     tokenFile = config.sops.templates."forgejo-runner.env".path;
  #     labels = [
  #       "debian-latest:docker://node:22-bookworm"
  #       "ubuntu-latest:docker://node:22-bookworm"
  #     ];
  #     settings = {
  #       runner = {
  #         capacity = 1;
  #       };
  #     };
  #   };
  #
  #   nixdots.persist.system.directories = [ "/var/lib/gitea-runner" ];
  # }
  ;
}
