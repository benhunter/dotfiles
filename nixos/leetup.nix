{ pkgs }:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "leetup";
  version = "v1.2.5";

  src = pkgs.fetchFromGitHub {
    owner = "benhunter";
    repo = "leetup";
    rev = "";
    sha256 = "";
  };

  cargoSha256 = "";
}
