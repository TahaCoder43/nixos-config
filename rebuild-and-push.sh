#!/usr/bin/env sh

commit_message=${1:-'Updating configuration.nix (likely)'}

git add .

if git status -s | grep -E "\.nix$"; then # also acounts for hardwaree-configuration.nix remember
    sudo nixos-rebuild switch --option access-tokens "github.com=$(cat .github_access)"
fi

if [[ $? -gt 0 ]]; then
    exit 1
fi

git commit -m "$commit_message"
git push --set-upstream origin main

if [[ $? -gt 0 ]]; then
    if ! git remote show | grep origin > /dev/null; then
        source .env 2> /dev/null
        if [[ $? -gt 0 ]]; then
            echo Failed as there is no .env file, create and .env file with variable origin for git remote to use
        fi
        if ً! set | grep "^origin="; then
            echo There is no variable origin in .env file. create and .env file with variable origin for git remote to use
        fi

        git remote add origin $origin
    fi

    if ! ssh-add -l | grep "taha-ibn-munawar@proton.me"; then
        eval $(ssh-agent -s)
        ssh-add ~/.ssh/github
    fi

    git push --set-upstream origin main
fi
