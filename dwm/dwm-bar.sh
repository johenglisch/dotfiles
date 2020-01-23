#!/bin/sh


while read -r LINE
do
    xsetroot -name "$LINE"
done
