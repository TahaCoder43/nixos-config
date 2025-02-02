{config, pkgs, mypkgs}:
{
  services.xserver = {
    # enable = true;
    # extraConfig = ''
    #   Section "Monitor"
    #     Identifier "VGA-1"
    #     Option "Ignore" "true"
    #   EndSection
    # '';
    # displayManager.lightdm = {
    #   enable = true;
    #   greeter.name = "lightdm-gtk-greeter";
    #   # extraConfig = ''
    #   #   [SEAT:*]
    #   #   greeter-session=lightdm-deepin-greeter
    #   # ''; 
    # };
    # desktopManager.deepin.enable = true;
    xkb = {
      layout = "us,ara-ph";
      # optoins aren't working idk why
      options = "keypad:pointerkeys,lv3:caps_switch,grp:rctrl_toggle";
      extraLayouts.ara-ph = {
         description = "Arabic layout that is phonetically mapped to english";
         languages = [ "ara" ];
         symbolsFile = "${mypkgs.easy-arabic-keyboard-layout}/share/X11/xkb/symbols/ara-ph";
      };
    };
  };
}
