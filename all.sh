#!/bin/bash

# cd to script dir
PROJECT_NAME='serp'

echo
echo '-- infrastructure'
./infrastructure.sh -p infra $@

sleep 3s

echo
echo '-- core'
./core.sh -p core $@