{ stdenv, fetchurl }: stdenv.mkDerivation {

  name = "Technic Launcher";
  src = {
    url = "https://launcher.technicpack.net/launcher4/900/TechnicLauncher.jar";
    hash = "";
  };
}
