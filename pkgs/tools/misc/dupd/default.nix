{ lib, stdenv, fetchFromGitHub, perl, which
, openssl, sqlite }:

# Instead of writing directly into $HOME, we change the default db location
# from $HOME/.dupd_sqlite to $HOME/.cache/dupd.sqlite3

stdenv.mkDerivation rec {
  pname = "dupd";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "jvirkki";
    repo  = "dupd";
    rev   = version;
    sha256 = "sha256-Jl95Ke1AntYeTKARQTXm5qMhwISEw4Pvnr6I2WEFlP4=";
  };

  postPatch = ''
    patchShebangs tests

    # tests need HOME to write the database
    export HOME=$TMPDIR

    mkdir -p $HOME/.cache

    for f in man/dupd man/dupd.1 src/main.c tests/test.56 tests/test.57 ; do
      substituteInPlace $f --replace .dupd_sqlite .cache/dupd.sqlite3
    done
  '';

  buildInputs = [ openssl sqlite ];

  nativeBuildInputs = [ perl which ];

  makeFlags = [
    "INSTALL_PREFIX=$(out)"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    description = "CLI utility to find duplicate files";
    homepage = "http://www.virkki.com/dupd";
    license = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
