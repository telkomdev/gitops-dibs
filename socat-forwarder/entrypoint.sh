#!/bin/sh
set -e

echo "Starting socat forwarder"

if [ -n "$SOCAT_FORWARD_IP" ]; then
  echo "Mode: single forward"
  echo "Listen : $SOCAT_LISTEN_PORT"
  echo "Forward: $SOCAT_FORWARD_IP:$SOCAT_FORWARD_PORT"

  exec socat TCP-LISTEN:${SOCAT_LISTEN_PORT},fork,reuseaddr TCP:${SOCAT_FORWARD_IP}:${SOCAT_FORWARD_PORT}
fi

#(multi forward)
if [ -n "$SOCAT_CONFIG" ]; then
  echo "Mode: multi forward"

  echo "$SOCAT_CONFIG" | while IFS=',' read LISTEN_IP LISTEN_PORT FORWARD_IP FORWARD_PORT
  do
    echo "Forward $LISTEN_PORT -> $FORWARD_IP:$FORWARD_PORT"
    socat TCP-LISTEN:${LISTEN_PORT},fork,reuseaddr TCP:${FORWARD_IP}:${FORWARD_PORT} &
  done

  wait
fi

echo "No configuration found"
exit 1