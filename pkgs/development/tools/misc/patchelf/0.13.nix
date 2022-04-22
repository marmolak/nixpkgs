{ stdenv, fetchurl, patchelf }:

stdenv.mkDerivation rec {
  pname = "patchelf";
  version = "0.13.1";

  src = fetchurl {
    url = "https://github.com/NixOS/${pname}/releases/download/${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-OeiuzNdJXVTfCU0rSnwIAQ/3d3A2+q8k8o4Hd30VmOI=";
  };

  setupHook = [ ./setup-hook.sh ];

  # fails 8 out of 24 tests, problems when loading libc.so.6
  doCheck = stdenv.name == "stdenv-linux";

  inherit (patchelf) meta;
}
