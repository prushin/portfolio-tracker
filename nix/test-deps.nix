{ repoDir }:
let
  dataDir = "${repoDir}/build";
  project = (import ./project.nix);
  p = project.project {};
  nixPkgs = project.nixPkgs;
  nixPkgsLegacy = project.nixPkgsLegacy;
  prjSrc = project.prjSrc;
  pg = import ./postgres-conf.nix;
  postgres = nixPkgs.callPackage pg {
    name = "postgres_data";
    dbName = "coins-test";
    inherit dataDir;
  };

  startAll = nixPkgs.writeShellScriptBin "start-test-deps" ''
    set -euo pipefail
    echo "test-deps ==> spawning postgres..."
    ${postgres.up}/bin/up
    echo "test-deps ==> done"
  '';
in
{
  stopAll = nixPkgs.writeShellScriptBin "stop-test-deps" ''
    ${postgres.down}/bin/down
  '';
  coinsTestConfig = coinsEnv.coinsTestConf;
  inherit startAll;
}

