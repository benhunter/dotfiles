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

  # Additional build inputs to provide OpenSSL and pkg-config
  nativeBuildInputs = [
    pkgs.openssl
    pkgs.pkg-config
    pkgs.perl
  ];

  # Environment variables to help pkg-config locate OpenSSL
  buildInputs = [ pkgs.openssl ];

  # Environment variables to help the build process find OpenSSL
  # PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  # OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
  # OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
  # DEP_OPENSSL_INCLUDE = "${pkgs.openssl.dev}/include";
  # OPENSSL_STATIC = 1;

  # Set the `RUSTFLAGS` environment variable to point to the correct OpenSSL paths
  RUSTFLAGS = "--cfg openssl_vendored";
}
