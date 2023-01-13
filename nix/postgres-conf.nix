{
  dataDir ? "./tmp"
, name
, dbName
, writeText
, writeShellScriptBin
, runCommand
, postgresql
}:
let
  postgresqlconf = writeText "postgresql.conf" ''
    unix_socket_directories = '/tmp'
    log_statement = 'all'
  '';
  serviceName = "postgresql-${name}";
  workDir = "${dataDir}/${serviceName}";
  setup = writeShellScriptBin "setup" ''
    ${postgresql}/bin/initdb -D ${workDir} --auth=trust --no-locale --encoding=UTF8
    mkdir -p "${workDir}/sockets"
    cp -f ${postgresqlconf} ${workDir}/postgresql.conf
  '';
  init = writeShellScriptBin "init" ''
    ${postgresql}/bin/createuser -s postgres -h "/tmp"
    ${postgresql}/bin/createdb -h localhost coins
    ${postgresql}/bin/createdb -h localhost coins-test
  '';
  start = writeShellScriptBin "start" ''
    ${postgresql}/bin/postgres -D ${workDir} > ${workDir}/postgres.log 2>&1 &
    while ! ${postgresql}/bin/pg_isready -h 127.0.0.1; do sleep 1; done;
  '';
  stop = writeShellScriptBin "stop" ''
    timeout 5 ${postgresql}/bin/pg_ctl -D ${workDir} stop
    rm -rf ${workDir}
  '';
  up = writeShellScriptBin "up" ''
    ${setup}/bin/setup
    ${start}/bin/start
    ${init}/bin/init
  '';
  down = writeShellScriptBin "down" ''
    ${stop}/bin/stop
  '';
  cli = writeShellScriptBin "psql" ''
    ${postgresql}/bin/psql -h localhost -U postgres "$@"
  '';
in {
  inherit up down cli;
}
