#! /usr/bin/env fish

function trim
    set temp (string replace -r '.nvim$' '' $argv)
    set temp (string replace -r '\-nvim$' '' $temp)
    set temp (string replace -r '^nvim-' '' $temp)
    set temp (string replace -r '\.' '\-' $temp)
    echo $temp
end

set github "https://github.com"
# set github "https://ghp.ci/https://github.com"

if test (count $argv) -eq 0
    rm -rf pack .gitmodules
    touch .gitmodules
    git add .gitmodules
    mkdir -p pack/data/opt/
    for pkg in (cat ./package.list)
        string match -rq '^(?<username>[^/]+)/(?<repo>[^/]+)$' -- $pkg
        if test $status -eq 0
            git submodule add --force \
                $github/$username/$repo \
                pack/data/opt/(trim $repo)
        else
            echo Cannot parse package $pkg
        end
    end
    return
end

if test $argv[1] = update
    git submodule sync
    git submodule update --recursive --remote
    git add -A
    return
end

if test $argv[1] = nuke
    rm -rf pack/ .gitmodules
    return
end
