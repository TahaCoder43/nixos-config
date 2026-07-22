{ pkgs, ... }:
{
  security.sudo.extraRules = [
    {
      users = [
        "taham"
      ];
      groups = [
        "uinput"
        "users"
      ];
      commands = [
        {
          command = "/run/current-system/sw/bin/ydotool";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/ydotoold";
        }
        {
          command = "/run/current-system/sw/bin/nethogs";
        }
        {
          command = "/run/current-system/sw/bin/systemctl start waydroid-container";
        }
        {
          command = "/run/current-system/sw/bin/mount";
        }
        {
          command = "/run/current-system/sw/bin/umount";
        }
      ];
    }
  ];
}
