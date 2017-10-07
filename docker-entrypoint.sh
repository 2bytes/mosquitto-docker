#!/bin/bash
set -euo pipefail

touch /var/lib/mosquitto/pwfile
chown -R mosquitto:mosquitto /var/lib/mosquitto
chown -R mosquitto:mosquitto /mqtt/

exec gosu mosquitto "$@"
