{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "nvchad-config";

  # Use the fetchFromGitHub function to install NvChad from my GitHub.
  src = pkgs.fetchFromGitHub {
    owner = "benhunter";
    repo = "nvchad-config";
    rev = "nixos"; # branch, commit hash, or tag 

    # sha256 = "";
    sha256 = "sha256-I9eyuFMMlHJoXazjNLEF1sdtIIi+msmtefOC5SuZkAw=";
  };

  # Specify the installation directory
  installPhase = ''
    mkdir -p $out/nvchad
    cp -r * $out/nvchad
  '';
}
