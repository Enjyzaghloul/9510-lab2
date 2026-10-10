#!/bin/bash
dir=$1
malicious_dir=$2

while true; do
 files=("$malicious_dir"/*)
 if [ ! -e "${files[0]}" ]; then
    echo "No malicious files to review."
    break 
 fi
 i=1
 for f in "${files[@]}"; do
    echo "$i. $(basename "$f")"
    i=$((i + 1))
 done

 read -p "pick a number (0 to exit): " n
 [ "$n" -eq 0 ] && break
 if ! [[ "$n" =~ ^[0-9]+$ ]] || [ "$n" -lt 1 ] || [ "$n" -gt "${#files[@]}" ]; then
    echo "Invalid selection. Please try again."
    continue
 fi

 file="${files[$((n - 1))]}"
 name=$(basename "$file")

 read -p "1. restore 2.delete 3. leave: " choice
 case "$choice" in
    1) mv "$file" "$dir/$name";
       echo "$name" >> whitelist.txt
       echo "Restored $name to $dir.";;
    2) rm "$file";
       echo "$name permanently deleted.";;
    3);;
    *) echo "Invalid choice. Please try again.";;
    esac
 done
   