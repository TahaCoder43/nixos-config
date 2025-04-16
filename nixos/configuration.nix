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
  mypkgs = {
    swhkd = pkgs.rustPlatform.buildRustPackage rec {
      pname = "swhkd";
      version = "1.2.1";
      # nativeBuildInputs =
      # buildInputs = with pkgs; [
      #   cargo
      # ];

      src = pkgs.fetchFromGitHub {
        owner = "waycrate";
        repo = "swhkd";
        tag = version;
        hash = "sha256-VQW01j2RxhLUx59LAopZEdA7TyZBsJrF1Ym3LumvFqA=";
      };

      cargoHash = "sha256-NAVqwYJA0+X0dFC3PBaW+QJxvJtSgl4Y/VNfNO3jnLA=";

    };
    obsidian-appimage =
      let
        #https://github.com/obsidianmd/obsidian-releases/releases/download/v1.8.4/Obsidian-1.8.4.AppImage
        version = "1.8.4";
        pname = "Obsidian";

        src = pkgs.fetchurl {
          url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v${version}/${pname}-${version}.AppImage";
          hash = "sha256-f4waZvA/li0MmXVGj41qJZMZ7N31epa3jtvVoODmnKQ=";
        };

        appimageContents = pkgs.appimageTools.extract {
          inherit pname version src;
        };
      in
      pkgs.appimageTools.wrapType2 {
        inherit pname version src;
        extraInstallCommands = ''
          ls $out/bin
                   ls ${appimageContents}
                   install -m 444 -D ${appimageContents}/obsidian.desktop $out/share/applications/obsidian.desktop
                   install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/obsidian.png \
                     $out/share/icons/hicolor/512x512/apps/obsidian.png
                   echo fails happens at substituting
                   ls $out/share/applications/
                   echo ${pname}
                   substituteInPlace $out/share/applications/obsidian.desktop \
                     --replace-fail 'Exec=AppRun' 'Exec=${pname}'
                   echo fail happens after extraInstallCommands
        '';
      };
    more-rofi-themes = pkgs.stdenvNoCC.mkDerivation {
      pname = "more-rofi-themes";
      version = "1.0";

      src = pkgs.fetchFromGitHub {
        owner = "adi1090x";
        repo = "rofi";
        rev = "2e0efe5054ac7eb502a585dd6b3575a65b80ce72";
        hash = "sha256-TVZ7oTdgZ6d9JaGGa6kVkK7FMjNeuhVTPNj2d7zRWzM=";
      };

      dontBuild = true;

      installPhase = ''
        runHook preInstall
        mkdir -p $out/share/rofi/
        cp -r $src/files $out/share/rofi/themes
        runHook postInstall
      '';
    };
    easy-arabic-keyboard-layout = pkgs.stdenvNoCC.mkDerivation {
      pname = "easy-arabic-keyboard-layout";
      version = "1.0";

      src = pkgs.fetchFromGitHub {
        owner = "TahaCoder43";
        repo = "easy-arabic-keyboard-layout";
        rev = "a96ee639180041750298ff1c13e36c645ef09eea";
        hash = "sha256-qQRH2bKALIHYExfLKLDNO9UEJXoAuDLZG8um50yqmBI=";
      };

      dontBuild = true;

      installPhase = ''
        runHook preInstall
        install -Dm644 $src/* -t $out/share/X11/xkb/symbols/
        runHook postInstall
      '';
    };
    fonts = {
      serenity-os-emoji = pkgs.stdenvNoCC.mkDerivation {
        pname = "serenity-os-emoji";
        version = "1.0";

        src = pkgs.fetchurl {
          url = "https://linusg.github.io/serenityos-emoji-font/SerenityOS-Emoji.ttf";
          hash = "sha256-YvI9EEhEzw29ibcCh1H+bkVJtODHQQe88xsMU90wKVg=";
        };

        dontUnpack = true;

        installPhase = ''
          runHook preInstall
          echo debugging
          install -Dm644 $src -t $out/share/fonts/truetype
          runHook postInstall
        '';
      };
    };
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
  };
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    (import ./modules/hyprland.nix { inherit pkgs mypkgs; })
    (import ./modules/xserver.nix { inherit config pkgs mypkgs; })
    ./modules/networking.nix
    ./modules/waydroid.nix
    ./modules/keyd.nix
  ];

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot.extraModprobeConfig = ''
    options iwlwifi power_save=0
  '';
  boot.kernelParams = [
    "pcie_aspm=off"
    "pcie_port_pm=off"
  ];
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
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      go-2fa
    ];
  };

  users.groups = {
    ydotool.members = [ "taham" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.etc = {
    "rofi/themes".source = "${pkgs.rofi-wayland}/share/rofi/themes";
  };

  environment.systemPackages = with pkgs; [
    # install activity watch, keyviz, and flameshot now
    python312
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

    vim
    neovim
    btop
    gitui
    oh-my-posh
    # mypkgs.gauth

    zsh
    antigen
    kitty
    foot
    tmux
    mypkgs.tmux-plugin-manager

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
    # remember to add zoxide

    # utility tools
    dig
    iftop
    iotop
    libinput # to debug input events
    pciutils # provides lspci command to show usb device information
    lshw
    exiftool
    file
    ntfs3g # Required to be able to work with ntfs file system
    smartmontools # hard disk smart test runner
    mypkgs.swhkd # Hotkey daemon

    microsoft-edge
    unstable.inkscape
    gimp
    filelight
    vlc
    kdePackages.kamera
    sqlitebrowser
    unstable.activitywatch # for some reason stable version failed to build, meanwhile unstable succeded ????
    awatcher
    unstable.python312Packages.notebook
    mypkgs.easy-arabic-keyboard-layout
    mypkgs.obsidian-appimage
    steam-run
  ];

  programs.sway = {
    enable = true;
    #wrappersFeatures.gtk = true; if gtk fails turn this on
    # figure out whether to use this or .zprofile
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export _JAVA_AWT_WM_NONREPARENTING=1
      export QT_QPA_PLATFORM=wayland
    '';
    extraPackages = with pkgs; [
      # might consider deleting these
      dmenu
      sway-contrib.grimshot

      rofi-wayland
      # manually install flameshot to include USE_WAYLAND_GRIM, like here https://github.com/NixOS/nixpkgs/issues/292700#issuecomment-1974953531
      flameshot
      slurp
      wf-recorder
      ydotool
      wl-clipboard
      swaynotificationcenter
    ];
  };

  programs.git.config = {
    enable = true;
    init.defaultBranch = "main";
    user = {
      email = "taha-ibn-munawar@proton.me";
      name = "Taha ibn Munawar";
    };
  };
  programs.tmux = {
    enable = true;
    extraConfig = ''
      run ${mypkgs.tmux-plugin-manager}/share/tmux-plugins/tpm/tpm
    '';
  };
  programs.zsh = {
    enable = true;
    shellInit = ''
      source ${pkgs.antigen}/share/antigen/antigen.zsh
    '';
  };
  programs.firefox.enable = true;
  programs.ssh.startAgent = true;
  programs.ydotool.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  # in your home.nix
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "joypixels"
    ];
  nixpkgs.config.joypixels.acceptLicense = true;

  fonts = {
    packages = with pkgs; [
      poppins
      joypixels
      unstable.nerd-fonts.iosevka
      mypkgs.fonts.serenity-os-emoji
      google-fonts # all google fonts downloaded, good for designing
    ];
    fontconfig.defaultFonts = {
      monospace = [ "Iosevka Nerd Font" ];
      sansSerif = [
        "Noto Sans"
        "Noto Kufi Arabic"
      ];
      serif = [
        "Noto Serif"
        "Noto Kufi Arabic"
      ];
      emoji = [
        "JoyPixels"
        "SerenityOS Emoji"
        "Noto Color Emoji"
        "Noto Emoji"
      ];
    };
  };

  # Configure keymap in X11
  # Not working :'(
  # services.displayManager.enable = true;

  # Sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true; # if not already enabled
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # hardware.pulseaudio.enable = true;
  #hardware.pulseaudio.support32Bit = true;    ## If compatibility with 32-bit applications is desired.

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
