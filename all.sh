#!/bin/bash

# cd to script dir
PROJECT_NAME='serp'

echo
echo '-- infrastructure'
./infrastructure.sh $@

echo
echo '-- core'
./core.sh $@