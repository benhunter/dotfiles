{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "nvchad-config";

  # Use the fetchFromGitHub function if the repository is on GitHub
  src = pkgs.fetchFromGitHub {
    owner = "benhunter";
    repo = "nvchad-config";
    rev = "9b9a2bd";
    sha256 = "sha256-2DOBPHhN5VSQm4E63PsxMbt1XFc+zhWDrggEwUiuIj4=";
  };

  # Specify the installation directory
  installPhase = ''
    mkdir -p $out/nvchad
    cp -r * $out/nvchad
  '';
}
