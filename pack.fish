#! /usr/bin/env fish

function trim
    set temp (string replace -r '.nvim$' '' $argv)
    set temp (string replace -r '\-nvim$' '' $temp)
    set temp (string replace -r '^nvim-' '' $temp)
    set temp (string replace -r '\.' '\-' $temp)
    echo $temp
end

function setup
    rm -rf pack .gitmodules
    touch .gitmodules
    git add .gitmodules
    mkdir -p pack/data/opt/
    for pkg in (cat ./package.list)
        string match -rq '^(?<username>[^/]+)/(?<repo>[^/]+)$' -- $pkg
        if test $status -eq 0
            # determine default branch
            set url $github/$username/$repo
            set branch master
            if test (git ls-remote --heads $url main | wc -l) -gt 0
                set branch main
            end

            git submodule add -b $branch --force \
                $url \
                pack/data/opt/(trim $repo)
        else
            echo Cannot parse package $pkg
        end
    end
end

function update
    git submodule sync
    git submodule update --recursive --remote
    git add -A
end

# set github "https://github.com"
set github "https://ghfast.top/https://github.com"

if test (count $argv) -eq 0
    setup
    return
end

if test $argv[1] = update
    update
    return
end

if test $argv[1] = sync
    rm -rf pack/ .gitmodules
    setup
    update
    return
end
