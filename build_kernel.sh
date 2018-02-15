#!/bin/bash
cd $(dirname "$(readlink -e $0)")/kernel-builder

NAME='lopin/kernel-debian-stretch'
date_yymmdd="$(date '+%Y%m%d')"

docker build -t "$NAME" -t "$NAME":"$date_yymmdd" "$@" .

