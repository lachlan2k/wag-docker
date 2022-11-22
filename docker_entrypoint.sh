#!/bin/sh

if [ ! -f /data/config.json ]; then
	echo "No config file found, generating from example. Ensure /data is mounted for persistence"
	cp /tmp/example_config.json /data/config.json
	sed -i "s|AN EXAMPLE KEY|$(wg genkey)|" /data/config.json
	sed -i "s|\"devices.db\"|\"/data/devices.db\"|" /data/config.json
	echo "Please edit your newly generated config file and start again"
	exit
fi

wag start -config /data/config.json
