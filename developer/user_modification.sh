#!/bin/sh

# See https://github.com/sclorg/s2i-python-container/issues/98

UID=$(id -u)
GID=$(id -g)
USER_NAME=euler

if [ x"$UID" != x"0" ]; then
    NSS_WRAPPER_PASSWD=/tmp/passwd.nss_wrapper
    NSS_WRAPPER_GROUP=/tmp/group.nss_wrapper

    cat /etc/passwd | sed -e "s/^${USER_NAME}:/ignore:/" > $NSS_WRAPPER_PASSWD
    echo "${USER_NAME}:x:$UID:$GID:${USER_NAME},,,:/home/${USER_NAME}:/bin/bash" >> $NSS_WRAPPER_PASSWD

    if [ x"$GID" != x"0" ]; then
        cat /etc/group | sed -e "s/^${USER_NAME}:/ignore:/" > $NSS_WRAPPER_GROUP
        echo "${USER_NAME}:x:$GID:" >> $NSS_WRAPPER_GROUP
    fi

    export NSS_WRAPPER_PASSWD
    export NSS_WRAPPER_GROUP

    LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libnss_wrapper.so
    export LD_PRELOAD
fi