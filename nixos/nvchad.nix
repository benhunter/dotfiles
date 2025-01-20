{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "nvchad-config";

  # Use the fetchFromGitHub function to install NvChad from my GitHub.
  src = pkgs.fetchFromGitHub {
    owner = "benhunter";
    repo = "nvchad-config";
    rev = "nixos"; # branch, commit hash, or tag 

    # sha256 = ""; # Use to get the new hash.
    sha256 = "sha256-9VZMugKg6jPpdliKjSRSFR3XAXsdpchgx4EED/u5BQk=";
  };

  # Specify the installation directory
  installPhase = ''
    mkdir -p $out/nvchad
    cp -r * $out/nvchad
  '';
}
