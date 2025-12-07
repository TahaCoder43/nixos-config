{ pkgs }:
{
  environment.systemPackages = [
    (pkgs.flameshot.override { enableWlrSupport = true; })
  ];
}
