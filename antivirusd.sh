#!/bin/bash

if [ $# -ne 3 ]; then 
    echo "Usage: $0 dir malicious_dir interval-secs"
    exit 1
fi              

dir=$1
malicious_dir=$2
interval=$3

 extensions="exe bat vbs scr ps1"
 keywords="virus|trojan|malware|worm|ransomware"

 mkdir -p "$malicious_dir"

 scan(){
   for f in "$dir"/*; do
        [ -f "$f" ] || continue #will skip if not a file 
        name=$(basename "$f")
    if [ -f whitelist.txt ] && grep -qxF "$name" whitelist.txt; then
       continue
    fi
        bad=0

        ext="${name##*.}"
        if [ "$ext" != "$name" ]; then
            for e in $extensions; do
                 [ "$ext" == "$e" ] && bad=1
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
 if [ ! -f directory-info.last ]; then
  scan
  ls -l "$dir" > directory-info.last

 fi

  while true; do
    sleep "$interval"
    ls -l "$dir" > directory-info.new
    if ! cmp -s directory-info.last directory-info.new; then
       scan
       cp directory-info.new directory-info.last
    fi
  done
  