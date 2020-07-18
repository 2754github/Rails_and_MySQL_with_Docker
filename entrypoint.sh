#!/bin/bash
set -e

# Railsの既存のserver.pidを削除
rm -f /myapp/tmp/pids/server.pid

# DockerfileのCMDを実行
exec "$@"