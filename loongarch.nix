# { pkgs ? import ../nixpkgs { } }:

# let
#   makeExt4FsPath = ../nixpkgs/nixos/lib/make-ext4-fs.nix;
#   loongarch64Pkgs = pkgs.pkgsCross.loongarch64-linux;
#   rootfsContent = import ./nix-config/minimal.nix { pkgs = loongarch64Pkgs; };
#   storePaths = pkgs.lib.unique
#     (pkgs.lib.concatMap (pkg: [ pkg ] ++ (pkg.runtimeDependencies or [ ]))
#       [ rootfsContent ]);
#   rootfsImage = pkgs.callPackage makeExt4FsPath ({
#     storePaths = storePaths;
#     volumeLabel = "NIXOS_LOONGARCH64";
#   });
# in {
#   rootfs = rootfsContent;
#   image = rootfsImage;
# }

let system = "loongarch64-linux";
in {
  image = (import ../nixpkgs/nixos {
    configuration = { ... }: {
      nixpkgs.crossSystem.system = system;
      imports = [
        ../nixpkgs/nixos/modules/installer/sd-card/sd-image-loongarch64.nix
      ];
      sdImage.compressImage = false;
    };
  }).config.system.build.sdImage;
}

