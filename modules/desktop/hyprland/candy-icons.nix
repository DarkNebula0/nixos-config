{ stdenv }:


stdenv.mkDerivation {
  name = "candy-icons";
  version = "1.0.0";
  src = pkgs.fetchurl {
    url = "https://github.com/EliverLara/candy-icons/archive/master.zip";
    sha256 = "ee627aa567e112fc5495757143eb89d310ce1885ebe13d83c2508d6be7393f4f";
  };

  installPhase = ''
    mkdir -p /usr/share/icons
    cp -r candy-icons-master/* /usr/share/icons
  '';
}