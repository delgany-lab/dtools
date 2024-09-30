#!/usr/bin/env bash
set -e

. $HOME/.bashrc
. $IDF_PATH/export.sh

exec "$@"
