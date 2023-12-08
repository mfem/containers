#!/bin/sh

. /opt/user_modification.sh

/usr/bin/supervisord &

exec /bin/bash "$@"
