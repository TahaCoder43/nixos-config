{ pkgs, ... }:
{
  users.users.taham.extraGroups = [ "docker" ];
  virtualisation.docker.enable = true;

  # Example:
  # dockerTools.pullImage
  # {
  #   imageName = "evoapicloud/evolution-api";
  #   imageDigest = "sha256:e15508de128b9ab232d9cabb2441ca897a4802fba2c8186ed384b4f4508767d9";
  #   finalImageName = "evolution-api";
  #   finalImageTag = "latest";
  #   hash = "";
  # }
  environment.systemPackages = with pkgs; [
  ];
}
