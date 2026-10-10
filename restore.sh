
dir=$1
malicious_dir=$2

while true; do
 files=("$malicious_dir"/*)
 if [ ! -e "${files[0]}" ]; then
    echo "No malicious files found in $malicious_dir"
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

 
