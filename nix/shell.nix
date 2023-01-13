{ }:
with (import ./project.nix);
let
  repoDir = builtins.toString ./..;
  deps = import ./test-deps.nix {inherit repoDir;};
in
  (project {}).shellFor {
  withHoogle = true;
  buildInputs = [
#    nixPkgsLegacy.cabal-install
    pkgs.haskell-language-server
    nixPkgs.haskellPackages.hpack
    nixPkgs.haskellPackages.fswatcher
    nixPkgs.haskellPackages.cabal-plan
    nixPkgs.haskellPackages.hp2pretty
    nixPkgs.haskellPackages.hspec-discover
    nixPkgs.haskellPackages.implicit-hie
    nixPkgs.haskellPackages.hie-bios
#    nixPkgs.zlib
#    nixPkgs.protobuf
#    nixPkgs.netcat-gnu
#    nixPkgs.socat
    nixPkgs.ormolu
#    proto.protoc-haskell-bin
#    deps.startAll
#    deps.stopAll
#    deps.cliAlias
#    deps.ghcidCoinsMain
#    deps.ghcidCoinsTest
#    deps.ormoluFormat
#    deps.ormoluTest
#    deps.hlintTest
#    deps.styleTest
#    deps.mine
#    nixBitcoin.lndinit
  ];
  tools = {
    hlint = "latest";
    ghcid = "latest";
  };
}

