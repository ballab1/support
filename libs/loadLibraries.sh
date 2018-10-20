#!/bin/bash

# Use the Unofficial Bash Strict Mode
set -o errexit
set -o nounset
set -o pipefail
IFS=$'\n\t'


function die() {
    echo "$1"
    exit 1
}

function myExitHandler() {
    rmTmpDir() {
        local -i status=$?
        [ ! -d "$CBF_DIR" ] || rm -rf "$CBF_DIR"
        exit $status
    }
    trap -p EXIT | awk '{print $3}' | tr -d "'"
    trap rmTmpDir EXIT
}

declare cbf_dir="${CONTAINER_DIR:-}"
: ${__cbfVersion:=master}
[ -z "${CBF_VERSION:-}" ] || __cbfVersion=$CBF_VERSION

# check if we need to download CBF
if [ "${cbf_dir:-}" ] && [ -d "$cbf_dir" ]; then
    echo "Using local build version of CBF"

elif [ "${TOP:-}" ] && [ -d "${TOP}/container_build_framework" ] ; then
    echo "Using CBF submodule"
    cbf_dir="${TOP}/container_build_framework"

elif [ "${__cbfVersion:-}" ]; then
    trap myExitHandler EXIT
    declare CBF_DIR=$(mktemp -d)
    cbf_dir="${CBF_DIR}/container_build_framework"

    # since no CBF directory located, attempt to download CBF based on specified verion
    declare CBF_TGZ="${CBF_DIR}/cbf.tar.gz"
    declare CBF_URL="https://github.com/ballab1/container_build_framework/archive/${__cbfVersion}.tar.gz"
    echo "Downloading CBF:$__cbfVersion from $CBF_URL"

    wget --no-check-certificate --quiet --output-document="$CBF_TGZ" "$CBF_URL" || die "Failed to download $CBF_URL"
    if type -f wget &> /dev/null ; then
        wget --no-check-certificate --quiet --output-document="$CBF_TGZ" "$CBF_URL" || die "Failed to download $CBF_URL"
    elif type -f curl &> /dev/null ; then
        curl --insecure --silent --output "$CBF_TGZ" "$CBF_URL" || die "Failed to download $CBF_URL"
    else
        die "Neither wget or curl is installed to download cbf from $CBF_URL"
    fi

    echo 'Unpacking downloaded copy of CBF'
    tar -xzf "$CBF_TGZ" -C "$CBF_DIR" || die "Failed to unpack $CBF_TGZ"
    cbf_dir="$( ls -d "${CBF_DIR}/container_build_framework"* 2>/dev/null )"
fi


# verify CBF directory exists
[ "$cbf_dir" ] && [ -d "$cbf_dir" ] ||  die 'No framework directory located'


echo "loading framework from ${cbf_dir}"

# load our CBF libraries
[ ! -e "${cbf_dir}/bashlibs.loaded" ] || rm "${cbf_dir}/bashlibs.loaded" ||  die "Failed to remove ${CBF_TGZ}/bashlibs.loaded"

export CBF_LOCATION="$cbf_dir"                   # set CBF_LOCATION
export CRF_LOCATION="$CBF_LOCATION/cbf"          # set CRF_LOCATION
export CONTAINER_NAME=xxx
# shellcheck source=../container_build_framework/cbf/bin/init.libraries
source "$( cd "${cbf_dir}/cbf/bin" && pwd )/init.libraries"

# only load libraries from bashlib (not below). Sort to be deterministic
declare __libdir="$(readlink -f "$(dirname ${BASH_SOURCE[0]})")"
declare -a __libs
mapfile -t __libs < <(find "$__libdir" -maxdepth 1 -mindepth 1 -name '*.bashlib' | sort)
if [ ${#__libs[*]} -gt 0 ]; then
    echo "INFO: libraries loaded from $__libdir"
    printf '     \e[35m'
    for __lib in "${__libs[@]}"; do
        echo -n " $(basename "$__lib")"
        source "$__lib"
    done
    echo -e '\e[0m'
    unset __lib
fi
[ -e "${__libdir}/init.cache" ] && source "${__libdir}/init.cache"
unset __libs
unset __libdir
unset __cbfVersion
