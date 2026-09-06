{ pkgs, ... }:
## NOTE this tool requires ydotoold as I alredy had it setup I did not add the code to set it up here too
## credit: https://github.com/bobvanderlinden/nixos-config/blob/master/packages/voxd/package.nix, copied a lot of code from him
let
  whisperModel = pkgs.fetchurl {
    url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.en.bin";
    hash = "sha256-oDd5yG3zMjB19eeWyyzlAp8A7Ihp7uP9+4l6/jbG0AI=";
  };
  # qwenModel = pkgs.fetchurl {
  #   url = "https://huggingface.co/Qwen/Qwen2.5-3B-Instruct-GGUF/resolve/main/qwen2.5-3b-instruct-q4_k_m.gguf";
  #   hash = "sha256-YmtKZni4ZEIkDjPfgZ4AEy07p93f4c3E+7GOCpYVxi0=";
  #   curlOpts = "-L";
  # };

  voxd = pkgs.python3Packages.buildPythonApplication rec {
    name = "voxd";
    version = "1.7.0";
    pyproject = true;

    src = pkgs.fetchFromGitHub {
      owner = "jakovius";
      repo = "voxd";
      tag = "v${version}";
      hash = "sha256-A02lNyBO0XkDL7rSG3rgTW/q6R4SqBkyTLr1GZV2NW8=";
    };

    # Patch the invalid version string in pyproject.toml
    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace-fail 'version = "mr.batman"' 'version = "${version}"'
    '';

    # Skip tests as they may require audio devices or models
    doCheck = false;

    build-system = [ pkgs.python3Packages.hatchling ];

    dependencies = with pkgs.python3Packages; [
      numpy
      platformdirs
      psutil
      pyperclip
      pyqt6
      pyqtgraph
      pyyaml
      requests
      sounddevice
      tqdm
    ];

    # Runtime dependencies for clipboard and typing functionality
    makeWrapperArgs = with pkgs; [
      "--set VOXD_MODEL_PATH \"$out/share/voxd/models/ggml-base.en.bin\""
      "--set QT_QPA_PLATFORM minimal"
      "--prefix PATH : ${
        lib.makeBinPath [
          ydotool
          xclip
          wl-clipboard
          pulseaudio
        ]
      }"
    ];

    # Downloading models
    postInstall = ''
      mkdir -p $out/share/voxd/models
      ln -sf ${whisperModel} $out/share/voxd/models/ggml-base.en.bin
    '';
    # mkdir -p $out/share/voxd/llamacpp_models
    # mv ${qwenModel} $out/share/voxd/llamacpp_models/qwen2.5-3b-instruct-q4_k_m.gguf
  };
in
{
  environment.systemPackages = [ voxd ];
}
