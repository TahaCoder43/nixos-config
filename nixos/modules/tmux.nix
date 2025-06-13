{ pkgs, ... }:
let
  tmux-plugin-manager = pkgs.tmuxPlugins.mkTmuxPlugin rec {
    pluginName = "tpm";
    version = "3.1.0";
    src = pkgs.fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tpm";
      tag = "v${version}";
      hash = "sha256-CeI9Wq6tHqV68woE11lIY4cLoNY8XWyXyMHTDmFKJKI=";
    };
  };
in
{
  environment.systemPackages = [
    tmux-plugin-manager
    pkgs.tmux
  ];

  programs.tmux = {
    enable = true;
    extraConfig = ''
      run ${tmux-plugin-manager}/share/tmux-plugins/tpm/tpm
    '';
  };
}
