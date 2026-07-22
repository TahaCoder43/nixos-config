{ pkgs, ... }:

let
  cage-xtmapper = pkgs.stdenv.mkDerivation {
    pname = "cage-xtmapper";
    version = "0.2.0";

    src = pkgs.fetchFromGitHub {
      owner = "Xtr126";
      repo = "cage-xtmapper";
      rev = "v20260208";
      sha256 = "sha256-TUQJYjKsYHld8h7+/uI6iiwGYbs8oEc93ZE8mAczX7A="; # Run 'nix-prefetch-url --unpack <url>' to get this
    };

    # These match the "Arch/Fedora/Ubuntu" dependencies you listed
    nativeBuildInputs = with pkgs; [
      meson
      ninja
      pkg-config
      wayland-scanner
      makeWrapper
      scdoc # for the manual pages mentioned in your list
    ];

    buildInputs = with pkgs; [
      wayland
      wayland-protocols
      wlroots_0_18 # v0.2.0 requires wlroots 0.18
      libxkbcommon
      pixman
      libinput
      libdrm
      mesa
      seatd
      xorg.libxcb
      xorg.xcbutilwm
      xorg.xcbutilrenderutil
      xwayland # Required for the XWayland support mentioned
    ];

    mesonBuildDir = "nix-build";

    # If the repo has a weird structure, we tell Nix to go into the source
    preConfigure = ''
      # Ensure we are in the root where meson.build lives
      # If you cloned the repo, it's usually just the root.
    '';

    # Optional: If the build still fails, it's because Nix's default
    # mesonPhase is trying to be too smart. We can override it:
    configurePhase = ''
      meson setup nix-build --prefix=$out --buildtype=plain
    '';

    buildPhase = ''
      ninja -C nix-build
    '';

    installPhase = ''
      ninja -C nix-build install
      # Also copy the .sh script since ninja might not install it
      cp ../cage_xtmapper.sh $out/bin/
    '';

    postInstall = ''
      wrapProgram $out/bin/cage_xtmapper.sh \
        --prefix PATH : ${
          pkgs.lib.makeBinPath [
            pkgs.waydroid
            pkgs.cage
          ]
        }
    '';

  };
in
{
  environment.systemPackages = [ cage-xtmapper ];
}
