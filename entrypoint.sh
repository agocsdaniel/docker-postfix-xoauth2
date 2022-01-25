#!/bin/sh
STATE_INI="/scripts/state/state.ini"
WATCHDOG_KEEPALIVE="/scripts/keepalive.sh"
PROVISION="/scripts/provision.sh"
PIDFILE="/var/spool/postfix/pid/master.pid"

case "$1" in
    "")
        "${PROVISION}"
        /usr/sbin/postfix start
        if [ -n "${OAUTH2_TOKEN_AUTO_REFRESH}" ]; then
            "${WATCHDOG_KEEPALIVE}" "${STATE_INI}"
        fi
        ;;
    "auth")
        (
            echo '[oauth2]'
            [ -n "${OAUTH2_AUTH_ENDPOINT}" ] && echo "auth_endpoint = ${OAUTH2_AUTH_ENDPOINT}"
            [ -n "${OAUTH2_TOKEN_ENDPOINT}" ] && echo "token_endpoint = ${OAUTH2_TOKEN_ENDPOINT}"
            [ -n "${OAUTH2_REDIRECT_URI}" ] && echo "redirect_uri = ${OAUTH2_REDIRECT_URI}"
            [ -n "${OAUTH2_SCOPE}" ] && echo "scope = ${OAUTH2_SCOPE}"
            echo "client_id = ${OAUTH2_CLIENT_ID}"
            echo "client_secret = ${OAUTH2_CLIENT_SECRET}"
			echo ''
			echo '[oauth2-state]'
			echo ''
        ) > "${STATE_INI}"
        python3 /scripts/oauth2.py "${STATE_INI}" init
        ;;
    *)
        exec $@
        ;;
esac
