# Edit this configuration file to define what should be installed on your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  unstable =
    import
      (fetchTarball {
        name = "nixos-unstable";
        url = "https://github.com/NixOS/nixpkgs/archive/0aa475546ed21629c4f5bbf90e38c846a99ec9e9.tar.gz";
        sha256 = "0vqzingl03yz185112lw0hf8idggkwxc6bjswgvyhjc6yx0pvhnz";
      })
      {
        config.allowUnfree = true;
        system = "x86_64-linux";
      };
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    (import ./modules/keyboard-and-fonts.nix { inherit pkgs unstable; })
    ./modules/hyprland.nix
    ./modules/waydroid.nix
    ./modules/networking.nix
    ./modules/obsidian.nix
    ./modules/swhkd.nix
    ./modules/tmux.nix
    ./modules/rofi.nix
    ./modules/android-build-tools.nix
    # ./modules/keyd.nix
  ];

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader = {
    # efi = {
    #   canTouchEfiVariables = true;
    # };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev"; # did not set it to /dev/sda because I could use this configuration on /dev/sdb (maybe it works like this)
      efiInstallAsRemovable = true; # So grub can remove /boot/EFI/BOOT/BOOTX64.EFI, reference: https://discourse.nixos.org/t/change-bootloader-to-grub/49947/2
    };
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Set your time zone.
  time.timeZone = "Asia/Karachi";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ur_PK";
    LC_IDENTIFICATION = "ur_PK";
    LC_MEASUREMENT = "ur_PK";
    LC_MONETARY = "ur_PK";
    LC_NAME = "ur_PK";
    LC_NUMERIC = "ur_PK";
    LC_PAPER = "ur_PK";
    LC_TELEPHONE = "ur_PK";
    LC_TIME = "ur_PK";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.taham = {
    isNormalUser = true;
    description = "Taha ibn Munawar";
    extraGroups = [
      "wheel"
      "ydotool"
      "uinput"
      "input"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      go-2fa
    ];
  };

  users.groups = {
    ydotool.members = [ "taham" ];
    uinput.members = [ "taham" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.sessionVariables = {
    YDOTOOL_SOCKET = "/home/taham/.ydotool_socket";
    LD_LIBRARY_PATH = "${pkgs.zlib}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.libGL}/lib:${pkgs.glib.out}/lib:/run/opengl-driver/lib";
    GDK_BACKEND = "wayland,x11,*";
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    ZDOTDIR = "/home/taham/.config/zsh";
  };

  environment.systemPackages = with pkgs; [
    # install activity watch, keyviz, and flameshot now

    # compilors, interpreters, linters, lsps, formatters
    python312
    pyright # python lsp
    ruff # python linter
    nodejs_23
    gcc
    gnumake
    rustc
    cargo
    rustfmt
    rust-analyzer
    lldb
    sqlite
    nil
    nixfmt-rfc-style
    temurin-bin

    # TUIs
    vim
    neovim
    bvi
    btop
    gitui
    oh-my-posh

    # Terminals, shells, multiplexers
    zsh
    antigen
    kitty
    foot

    # Dev tools
    git
    wget
    ripgrep # grep alternative
    fzf
    jq
    p7zip
    unrar
    tree
    appimage-run
    apktool
    android-studio-tools
    ffmpeg_6-full
    # sdkmanager
    # apksigner
    # androidenv.androidPkgs.tools
    # remember to add zoxide

    # Utility tools
    dig
    nethogs
    iotop
    libinput # to debug input events
    pciutils # provides lspci command to show usb device information
    lshw
    exiftool
    file
    ntfs3g # Required to be able to work with ntfs file system
    smartmontools # hard disk smart test runner
    steam-run
    inputs.nix-autobahn.packages."${pkgs.system}".nix-autobahn
    ydotool
    wl-clipboard

    # GUIs, icon packs, layouts
    slurp
    (flameshot.override { enableWlrSupport = true; })

    wf-recorder
    microsoft-edge
    unstable.inkscape
    gimp
    filelight
    vlc
    kdePackages.kamera
    kdePackages.dolphin
    kdePackages.qtsvg
    sqlitebrowser
    unstable.activitywatch # for some reason stable version failed to build, meanwhile unstable succeded ????
    awatcher
    unstable.python312Packages.notebook
    unstable.mcpelauncher-ui-qt
    swaynotificationcenter

    # Libraries, dependencies, drivers
    libsForQt5.qt5.qtwayland
    kdePackages.qt6ct
    mesa
    # (unstable.libsForQt5.qtstyleplugin-kvantum.override { qtbase = kdePackages.qtbase; })
    # intel-ocl # Opencl runtime for intel

  ];

  # programs.sway = {
  #   enable = true;
  #   #wrappersFeatures.gtk = true; if gtk fails turn this on
  #   # figure out whether to use this or .zprofile
  #   extraSessionCommands = ''
  #     export SDL_VIDEODRIVER=wayland
  #     export _JAVA_AWT_WM_NONREPARENTING=1
  #     export QT_QPA_PLATFORM=wayland
  #   '';
  # };

  programs.git.config = {
    enable = true;
    init.defaultBranch = "main";
    user = {
      email = "taha-ibn-munawar@proton.me";
      name = "Taha ibn Munawar";
    };
  };
  programs.zsh = {
    enable = true;
    shellInit = ''
      source ${pkgs.antigen}/share/antigen/antigen.zsh
    '';
  };
  programs.firefox.enable = true;
  programs.ssh.startAgent = true;
  # programs.ydotool.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  programs.nix-ld.enable = true;

  # in your home.nix
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "joypixels"
    ];
  nixpkgs.config.joypixels.acceptLicense = true;

  # Configure keymap in X11
  # Not working :'(
  # services.displayManager.enable = true;

  # Sound
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
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true; # if not already enabled
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
