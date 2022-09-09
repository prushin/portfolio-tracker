let
  header = (import ./header.nix);
  pkgs = header.pkgs;
  prjSrc = pkgs.haskell-nix.haskellLib.cleanGit {
    name = "portfolio-tracker";
    src = ../.;
  };
in
{
  pkgs = pkgs;
  nixPkgs = header.nixPkgs;
  nixPkgsLegacy = header.nixPkgsLegacy;
  nixBitcoin = header.nixBitcoin;
  inherit prjSrc;
  project = {}: pkgs.haskell-nix.project {
    projectFileName = "cabal.project";
    src = prjSrc;
    compiler-nix-name = header.compiler-nix-name;
    modules = [{
      packages.coins.components.tests.coins-test.build-tools = [
        pkgs.haskellPackages.hspec-discover
      ];
    }];
  };
}
