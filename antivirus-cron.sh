#!/bin/bash

base="/home/enjy/Downloads/9510-lab2"
dir="$base/testdir"
malicious_dir="$base/quarantine"

extensions="exe bat vbs ps1 scr"
keywords="virus|malware|trojan|worm|spyware|adware|ransomware"

mkdir -p "$dir" "$malicious_dir"
scan(){
    for f in "$dir"/*; do
         [ -f "$f" ] || continue
           name=$(basename "$f")
           bad=0
           ext="${name##*.}"
           if [ "$ext" != "$name" ]; then
            for e in $extensions; do
               [ "$ext" == "$e" ] && bad=1 && bad=1
            done
           fi
           if [ $bad -eq 0 ] && grep -qiaE "$keywords" "$f"; then
            bad=1
           fi
           if [ $bad -eq 1 ]; then
           echo "$name is malicious and it is DELETED"
           cp "$f" "$malicious_dir/$name"
              rm "$f"
           fi
    done
}

if [ ! -f "$base/directory-info.last" ]; then
   scan
   ls -l "$dir" > "$base/directory-info.last"
   exit 0
fi

ls -l "$dir" > "$base/directory-info.new"
if ! cmp -s "$base/directory-info.last" "$base/directory-info.new"; then
   scan
   cp "$base/directory-info.new" "$base/directory-info.last"
fi
