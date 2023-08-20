{ config
, pkgs
, ...
}: {
  imports = [ ./home.nix ];

  home.username = "marwe";
  home.homeDirectory = "/home/marwe";

  targets.genericLinux.enable = true;

}
