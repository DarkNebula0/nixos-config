{ stdenv, pkgs }:


stdenv.mkDerivation {
  name = "candy-icons";
  version = "1.0.0";
  src = pkgs.fetchzip {
    url = "https://github.com/EliverLara/candy-icons/archive/master.zip";
    sha256 = "QNQbYxqJWMbm4sP+0RRSEq5tGWmkRh0c039amukGKFE=";
  };

  installPhase = ''
    mkdir -p /usr/share/icons
    cp -r candy-icons-master/* /usr/share/icons
  '';
}