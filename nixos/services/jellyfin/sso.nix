{ secrets, config, ... }:
let
  ep = config.nixdefs.endpoints;
in
{

  sops.secrets = {
    jellyfin_oidc_secret = {
      sopsFile = secrets + /jellyfin.yaml;
    };
  };
  # [Human Intervention] cp the rendered file to the same directory.
  sops.templates."jellyfin-SSO-Auth.xml" = {
    content = /* xml */ ''
      <?xml version="1.0" encoding="utf-8"?>
      <PluginConfiguration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <SamlConfigs />
        <OidConfigs>
          <item>
            <key>
              <string>authelia</string>
            </key>
            <value>
              <PluginConfiguration>
                <OidEndpoint>${ep.authelia.publicUrl}</OidEndpoint>
                <OidClientId>jellyfin</OidClientId>
                <OidSecret>${config.sops.placeholder.jellyfin_oidc_secret}</OidSecret>
                <Enabled>true</Enabled>
                <EnableAuthorization>true</EnableAuthorization>
                <EnableAllFolders>true</EnableAllFolders>
                <EnabledFolders />
                <AdminRoles>
                  <string>admin</string>
                </AdminRoles>
                <Roles>
                  <string>user</string>
                  <string>admin</string>
                </Roles>
                <EnableFolderRoles>false</EnableFolderRoles>
                <EnableLiveTvRoles>false</EnableLiveTvRoles>
                <EnableLiveTv>false</EnableLiveTv>
                <EnableLiveTvManagement>false</EnableLiveTvManagement>
                <LiveTvRoles />
                <LiveTvManagementRoles />
                <FolderRoleMappings />
                <RoleClaim>groups</RoleClaim>
                <OidScopes>
                  <string>groups</string>
                </OidScopes>
                <CanonicalLinks></CanonicalLinks>
                <DisableHttps>false</DisableHttps>
                <DoNotValidateEndpoints>false</DoNotValidateEndpoints>
                <DoNotValidateIssuerName>false</DoNotValidateIssuerName>
                <SchemeOverride>https</SchemeOverride>
              </PluginConfiguration>
            </value>
          </item>
        </OidConfigs>
      </PluginConfiguration>
    '';
    path = "/var/lib/jellyfin/plugins/configurations/.nix-managed.SSO-Auth.xml";
    owner = config.services.jellyfin.user;
    group = config.services.jellyfin.group;
  };
}
