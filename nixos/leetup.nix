{ pkgs }:

# https://chatgpt.com/c/6709ec7f-90d4-800a-b17b-cbac36634277

pkgs.rustPlatform.buildRustPackage rec {
  pname = "leetup";
  version = "v1.2.5";

  src = pkgs.fetchFromGitHub {
    owner = "benhunter";
    repo = "leetup";
    rev = "ff67ebf";
    sha256 = "sha256-iivyOATeEKMTVxrmd/qvN6mBxgPDZns3LHXhXYhd2xM=";
  };

  cargoSha256 = "sha256-doQkRqRMM1Nf/h+65rzklkwlrzI8RpYrhAGMX6JM4GU=";
}
