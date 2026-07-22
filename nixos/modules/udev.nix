{ pkgs, ... }:
{
  environment.etc = {
    "udev/rules.d/88-automount-games-drive".text = ''
      ENV{ID_FS_LABEL}=="linux-games", RUN+="sudo mount /dev/sda2 mountpoint"
    '';
  };
}
