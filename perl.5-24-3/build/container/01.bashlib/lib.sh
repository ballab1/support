#!/bin/bash
#############################################################################
#
#   lib.sh
#
#############################################################################
function lib.build_container()
{
    local -r name=${1:?'Input parameter "name" must be defined'}
    local -r timezone=${2:?'Input parameter "timezone" must be defined'}
    
    term.header "$name"
    lib.run_scripts '02.packages' 'Install OS Support'
    package.installTimezone "$timezone"
    download.get_packages '03.downloads'
    lib.run_scripts '04.applications' 'Install applications'
    lib.run_scripts '05.customizations' 'Add configuration and customizations'
    lib.run_scripts '06.permissions' 'Make sure that ownership & permissions are correct'
    lib.run_scripts '07.cleanup' 'Clean up'
}

#############################################################################
function lib.createUserAndGroup()
{
    local -r user=${1:?'Input parameter "name" must be defined'}
    local -r uid=${2:?'Input parameter "uid" must be defined'}
    local -r group=${3:?'Input parameter "group" must be defined'}
    local -r gid=${4:?'Input parameter "gid" must be defined'}
    local -r homedir=${5:?'Input parameter "homedir" must be defined'}
    local -r shell=${6:?'Input parameter "shell" must be defined'}

    
    local wanted=$( printf '%s:%s' $group $gid )
    local nameMatch=$( getent group "${group}" | awk -F ':' '{ printf "%s:%s",$1,$3 }' )
    local idMatch=$( getent group "${gid}" | awk -F ':' '{ printf "%s:%s",$1,$3 }' )
    $LOG "INFO: group/gid (${wanted}):  is currently (${nameMatch})/(${idMatch})${LF}" 'info'

    if [[ $wanted != $nameMatch  ||  $wanted != $idMatch ]]; then
        printf "${LF}create group:  %s${LF}" $group
        [[ "$nameMatch"  &&  $wanted != $nameMatch ]] && groupdel "$( getent group ${group} | awk -F ':' '{ print $1 }' )"
        [[ "$idMatch"    &&  $wanted != $idMatch ]]   && groupdel "$( getent group ${gid} | awk -F ':' '{ print $1 }' )"
        /usr/sbin/groupadd --gid "${gid}" "${group}"
    fi

    
    wanted=$( printf '%s:%s' $user $uid )
    nameMatch=$( getent passwd "${user}" | awk -F ':' '{ printf "%s:%s",$1,$3 }' )
    idMatch=$( getent passwd "${uid}" | awk -F ':' '{ printf "%s:%s",$1,$3 }' )
    $LOG "INFO: user/uid (${wanted}):  is currently (${nameMatch})/(${idMatch})${LF}" 'info'
    
    if [[ $wanted != $nameMatch  ||  $wanted != $idMatch ]]; then
        printf "create user: %s${LF}" $user
        [[ "$nameMatch"  &&  $wanted != $nameMatch ]] && userdel "$( getent passwd ${user} | awk -F ':' '{ print $1 }' )"
        [[ "$idMatch"    &&  $wanted != $idMatch ]]   && userdel "$( getent passwd ${uid} | awk -F ':' '{ print $1 }' )"

        /usr/sbin/useradd --home-dir "$homedir" --uid "${uid}" --gid "${gid}" --no-create-home --shell "${shell}" "${user}"
    fi
} 

#############################################################################
function lib.get_base()
{
    printf "%s" "$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"   
}

#############################################################################
function lib.run_scripts()
{
    local -r dir=${1:?'Input parameter "dir" must be defined'}
    local -r notice=${2:-' '}
    local -r tools="$( lib.get_base )"

    IFS=$'\r\n'
    local files="$(ls -1 "${tools}/${dir}"/* 2>/dev/null | sort)"
    if [ "$files" ]; then
        [ "$notice" != ' ' ] && $LOG "${notice}${LF}" 'task'
        for file in ${files} ; do
            chmod 755 "$file"
            $LOG "..executing ${file}${LF}" 'info'
            eval "$file" || lib.log "..*** issue while executing $( basename "$file" ) ***${LF}" 'warn'
        done
    fi
}
