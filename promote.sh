#!/bin/bash

declare TAG='v3.9.10'

function promote() {
    local -r branch="$(git rev-parse --abbrev-ref HEAD)"
    git log -n 1 --graph --abbrev-commit --decorate --first-parent --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' .
    if [ "$branch" != 'main' ]; then
        git push --force origin HEAD:main
        git checkout main
        git reset --hard "$branch"
        git checkout "$branch"
    fi
    git tag "$TAG" --force
    git push --tags --force
}
#----------------------------------------------------------------------------


while read f;do
    docker tag "$f:dev" "$f:$TAG"
    docker push "$f:$TAG"
    docker rmi "$f:main"
    docker rmi "$f:$TAG"
done < <(docker images | grep dev | awk '{print $1}')

while read m; do
    echo
    echo "$m"
    pushd "$m" &>/dev/null
    promote
    popd &>/dev/null
done < <(git submodule status --recursive | awk '{print $2}') 
promote

# docker inspect  s2.ubuntu.home:5000/alpine/base_container:main|jq '.[].Config.Labels|with_entries(.key |= "p0." + .)'
