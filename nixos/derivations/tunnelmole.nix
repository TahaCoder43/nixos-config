{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.stdenv.mkDerivation {
  pname = "tunnelmole";
  version = "2.4.0"; # Match current release version

  src = pkgs.fetchurl {
    url = "https://tunnelmole.com/downloads/tmole-linux.gz";
    hash = "sha256-2NKm8l7O6At4XVbjJtj/s6QZ+gzc2v9qZ8h59JWV+D0=";
  };

  dontBuild = true;
  dontUnpack = true;
  dontPatchElf = true;
  installPhase = ''
    mkdir -p $out/bin
    gunzip -dc $src > $out/bin/tmole
    ln -sf $out/bin/tmole $out/bin/tunnelmole
    chmod u+x $out/bin/tmole $out/bin/tunnelmole
  '';

  # nativeBuildInputs = [ pkgs.autoPatchelfHook ];
  # buildInputs = [
  #   pkgs.libgcc
  #   pkgs.stdenv.cc.cc.lib
  # ];

}
