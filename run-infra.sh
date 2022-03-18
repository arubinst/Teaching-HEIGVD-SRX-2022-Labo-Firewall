#!/bin/bash

docker-compose up -d

SCRIPTS=("scripts/openfirewall.sh" "scripts/opendmz.sh" "scripts/openlan.sh")

if command -v gnome-terminal &> /dev/null
then
    CMD="gnome-terminal --tab --"
elif command -v konsole &> /dev/null
then
    CMD="konsole --new-tab -e"
fi


if [[ ! -z $CMD ]]
then
    for i in "${SCRIPTS[@]}"
    do
        eval "${CMD} ./${i}" &
    done
fi

