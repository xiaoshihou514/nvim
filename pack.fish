#! /usr/bin/env fish

function trim
    set temp (string replace -r '.nvim$' '' $argv)
    set temp (string replace -r '\-nvim$' '' $temp)
    set temp (string replace -r '^nvim-' '' $temp)
    set temp (string replace -r '\.' '\-' $temp)
    echo $temp
end

if test (count $argv) -eq 0
    for pkg in (cat ./package.list)
        string match -rq '^(?<username>.+)/(?<repo>.+)$' -- $pkg
        git submodule add --force \
            https://github.com/$username/$repo \
            pack/data/opt/(trim $repo)
    end
    return
end

if test $argv[1] = init
    mkdir -p "$HOME/.config/nvim/pack/data/opt/"

else if test $argv[1] = add
    set url $argv[2..-1]
    string match -rq '^(?<username>.+)/(?<repo>.+)$' -- $url
    git submodule add --force \
        https://github.com/$username/$repo \
        pack/data/opt/(trim $repo)

else if test $argv[1] = update
    git submodule sync
    git submodule update

else if test $argv[1] = remove
    set url $argv[2..-1]
    string match -rq '^(?<username>.+)/(?<repo>.+)$' -- $url
    git submodule deinit -f pack/data/opt/(trim $repo)

end
