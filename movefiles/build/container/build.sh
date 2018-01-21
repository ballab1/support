#!/bin/bash

#set -o xtrace
set -o errexit
set -o nounset 
#set -o verbose


# load our libraries
declare -r TOOLS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"  
for src in "${TOOLS}/01.bashlib"/*.sh ; do
    source "$src"
done


# build our container
lib.build_container 'MOVEFILES' \
                    'America/New_York'

