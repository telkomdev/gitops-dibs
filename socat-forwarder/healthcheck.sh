#!/bin/sh

if pgrep socat > /dev/null
then
  exit 0
else
  exit 1
fi