#!/bin/sh
STATE_INI=$1
while [ $? -eq 0 ];
do
	EXPIRES_IN=$(python3 /scripts/oauth2.py "${STATE_INI}" auth)
	POSTFIX_RELAY_AUTH_PASSWORD=$(python3 /scripts/oauth2.py "${STATE_INI}" token) /scripts/provision.sh
	/usr/sbin/postfix reload
	sleep ${EXPIRES_IN}
done

echo "Auto refresh stopped"