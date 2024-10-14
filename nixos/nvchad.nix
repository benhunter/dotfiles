{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "nvchad-config";

  # Use the fetchFromGitHub function to install NvChad from my GitHub.
  src = pkgs.fetchFromGitHub {
    owner = "benhunter";
    repo = "nvchad-config";
    rev = "main";
    # rev = "nixos"; # nixos branch

    # sha256 = "";
    sha256 = "sha256-2DOBPHhN5VSQm4E63PsxMbt1XFc+zhWDrggEwUiuIj4=";
    # sha256 = "sha256-Ue4OZM8PBNabNJTG3HC8w0oz4EkNjiufs8jFUxau2nI=";
    # sha256 = "sha256-A66CWMXFV6HEbfxFPHBirjPHxvLZ2eOmlB+B/veRRKA=";
  };

  # Specify the installation directory
  installPhase = ''
    mkdir -p $out/nvchad
    cp -r * $out/nvchad
  '';
}
