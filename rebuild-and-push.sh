#!/usr/bin/env sh

set -x
commit_message=${1:-'Updating configuration.nix (likely)'}

git add .
# sudo nixos-rebuild switch

if [[ $? -gt 0 ]]; then
    exit 1
fi

git commit -m "$commit_message"
git push --set-upstream origin main

if [[ $? -gt 0 ]]; then
    if ! git remote show | grep origin > /dev/null; then
        git remote add origin git@github.com:TahaCoder43/nixos-config
    fi

    if ! ssh-add -l | grep "taha-ibn-munawar@proton.me"; then
        eval $(ssh-agent -s)
        ssh-add ~/.ssh/github
    fi

    git push --set-upstream origin main
fi
