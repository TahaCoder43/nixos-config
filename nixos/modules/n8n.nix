{ pkgs, pkgs-unstable, ... }:
let
  n8n-node-convert-image = pkgs.stdenv.mkDerivation (finalAttrs: {
    pname = "n8n-node-convert-image";
    version = "0.0.2";

    src = pkgs.fetchFromGitHub {
      owner = "mason276752";
      repo = "n8n-nodes-convert-image";
      rev = "e2691c54ce4d97cd3f0471cf65e510588da4d9ae";
      hash = "sha256-ELhK9YPEQn0Fu9+mOj/YhaiIK654qc637M+tjjxQJ6E=";
    };

    nativeBuildInputs = with pkgs; [
      nodejs
      pnpm_10.configHook
      pnpm_10
    ];

    pnpmDeps = pkgs.pnpm.fetchDeps {
      inherit (finalAttrs) pname version src;
      pnpm = pkgs.pnpm_10;
      fetcherVersion = 3;
      hash = "sha256-7UY6k2g9Q2NW95Z6ztHJCxy5l9RUVpzXEshIqiyBFDg=";
    };

    buildPhase = ''
      runHook preBuild
      pnpm build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib/node_modules/n8n-nodes-convert-image
      cp -r . $out/lib/node_modules/n8n-nodes-convert-image
      runHook postInstall
    '';
  });
in
{
  environment.systemPackages = [
    (pkgs-unstable.n8n.overrideAttrs (oldAttrs: {
      preBuild = (oldAttrs.preBuild or "") + ''
        export NODE_OPTIONS="--max-old-space-size=8192"
      '';
    }))
    n8n-node-convert-image
  ];
}
