{stdenv, fetchurl, cmake, flex, bison, openssl, libpcap, zlib, file, curl
, libmaxminddb, gperftools, python, swig, rocksdb }:
let
  preConfigure = (import ./shell.nix);
in
stdenv.mkDerivation rec {
  pname = "zeek";
  version = "3.0.3";
  
  src = fetchurl {
    url = "https://old.zeek.org/downloads/zeek-${version}.tar.gz";
    sha256 = "0xlw5v83qbgy23wdcddmvan2pid28mw745g4fc1z5r18kp67i8a2";
  };

  nativeBuildInputs = [ cmake flex bison file ];
  buildInputs = [ openssl libpcap zlib curl libmaxminddb gperftools python swig rocksdb];
  # Indicate where to install the python bits, since it can't put them in the "usual"
  # locations as those paths are read-only.

  inherit preConfigure;

  cmakeFlags = [
    "-DPY_MOD_INSTALL_DIR=${placeholder "out"}/${python.sitePackages}"
    "-DENABLE_PERFTOOLS=true"
    "-DINSTALL_AUX_TOOLS=true"
  ];

  enableParallelBuilding = true;


  meta = with stdenv.lib; {
    description = "Powerful network analysis framework much different from a typical IDS";
    homepage = https://www.bro.org/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux;
  };
}
