#!/bin/bash
cd $(dirname "$(readlink -e $0)")

NAME='kernel-builder-base-debian-stretch'
date_yymmdd="$(date '+%Y%m%d')"

docker build -t "$NAME" . -t "$NAME":"$date_yymmdd"

