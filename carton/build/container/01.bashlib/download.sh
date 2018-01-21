#!/bin/bash
#############################################################################
#
#   download.sh
#
#############################################################################
function download.get_file()
{
    local -r name=${1:?'Input parameter "name" must be defined'}
    local -r file="${name}_FILE"
    local -r url="${name}_URL"
    local -r sha="${name}_SHA256"

    $LOG "Downloading  ${!file}${LF}" 'task'
    for i in {0..3}; do
        [ i -eq 3 ] && exit 1
        wget -O "${!file}" --no-check-certificate "${!url}"
        [ $? -ne 0 ] && continue
        local result=$(echo "${!sha}  ${!file}" | sha256sum -cw 2>&1)
        $LOG "${result}${LF}" 'info'
        [ $result != *' WARNING: '* ] && return 0
        $LOG "..failed to successfully download ${!file}. Retrying....${LF}" 'warn'
    done
}


#############################################################################
function download.get_packages()
{
    local -r dir=${1:?'Input parameter "dir" must be defined'}
    local -r tools=$( lib.get_base )
    
    cd "$tools"
    while read pkg; do
        download.get_file "$( basename "$pkg" )"
    done < <(ls -1 "${tools}/${dir}"/* 2>/dev/null | sort)
}
