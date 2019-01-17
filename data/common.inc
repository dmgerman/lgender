#!/bin/bash

Die () {
    echo "$1"
    echo "dying... "
    exit 1
}

Usage () {
    echo "$1"
    Die "$USAGE"
}

Check_File () {
    if [ ! -f $1 ]; then
        Usage "$2"
    fi
}
Check_Not_File () {
    if [ -f $1 ]; then
        Usage "$2"
    fi
}
