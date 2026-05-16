final: prev: {
  sarasa-term-sc-nerd = prev.nur.repos.definfo.sarasa-term-sc-nerd.overrideAttrs rec {
    version = "2.3.1";
    src = final.fetchurl {
      url = "https://github.com/laishulu/Sarasa-Term-SC-Nerd/releases/download/v${version}/SarasaTermSCNerd.ttc.7z";
      hash = "sha256-uigBn39Lfvqzn1Tmy8mPDRAs/WQj7EnfI0K0xYK18wA=";
    };
  };
}
