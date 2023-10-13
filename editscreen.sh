#!/bin/sh
# Using external pipe with st, give a dmenu prompt of recent commands,
# allowing the user to copy the output of one.
# xclip required for this script.
# By Jaywalker and Luke
tmpfile=$(mktemp /tmp/st-cmd-output.XXXXXX)
trap 'rm "$tmpfile"' 0 1 15
gsed -n "w $tmpfile"
gsed -i 's/\x0//g' "$tmpfile"
#ps1="$(grep "\S" "$tmpfile" | tail -n 1 | gsed 's/^\s*//' | cut -d' ' -f1)"
ps1=">>"
chosen="$(grep -F "$ps1" "$tmpfile" | gsed '$ d' | tail -r | dmenu -p "Copy which command's output?" -i -l 10 | gsed 's/[^^]/[&]/g; s/\^/\\^/g')"
eps1="$(echo "$ps1" | gsed 's/[^^]/[&]/g; s/\^/\\^/g')"
gawk "/^$chosen$/{p=1;print;next} p&&/$eps1/{p=0};p" "$tmpfile" | tail -n +2 | xclip -r -selection clipboard

#tmpfile=$(mktemp /tmp/st-edit.XXXXXX)
#trap  'rm "$tmpfile"' 0 1 15
#cat > "$tmpfile"
#st -e "$EDITOR" "$tmpfile"
