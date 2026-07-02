#!/bin/bash

if ! command -v ani2xcursor &> /dev/null; then
    echo "❌ Error: 'ani2xcursor' tidak ditemukan'"
    exit 1
fi

for file in *.zip; do   folder="${file%.zip}";   mkdir -p "$folder";   unzip "$file" -d "$folder"; done

i=1
for d in */; do
  mv "$d" "A$i"
  ((i++))
done

for f in *; do     ani2xcursor "$f" -o out; done

cd out

find . -depth -type d -exec bash -c '
  for dir; do
    base=$(basename "$dir")
    new=$(echo "$base" | tr -d " _-")
    parent=$(dirname "$dir")

    # kalau berubah baru rename
    if [ "$base" != "$new" ]; then
      mv "$dir" "$parent/$new"
    fi
  done
  ' bash {} +
  
for dir in */xcursor; do
    [ -d "$dir" ] || continue
    mv "$dir/cursors" "${dir%xcursor}"/
    mv "$dir/index.theme" "${dir%xcursor}"/
    rmdir "$dir"
done

find . -type f -name "index.theme" -exec sed -i 's/^Comment=.*//' {} +
find . -type f -name "index.theme" -exec sed -i '/^Name=/s/[ _-]//g' {} +
find . -type f -name "index.theme" -exec sed -i 's/^Inherits=.*/Inherits=breeze_cursors,oxygen,adwaita,core/' {} +
for d in */; do   base="${d%/}";    tar -czf "${base}.tar.gz" "$base";   tar -cJf "${base}.tar.xz" "$base";   tar -cjf "${base}.tar.bz2" "$base";  done


