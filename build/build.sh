#!/bin/zsh

BASE_FOLDER="$(dirname "$0")"

create() {
  deno run --allow-net --allow-read --allow-write \
    "$BASE_FOLDER/creator.mjs" "$1" "$2"
}

minify() {
  deno eval 'Deno.writeTextFileSync(Deno.args[1],JSON.stringify(JSON.parse(Deno.readTextFileSync(Deno.args[0]))))' \
    "$1" "$2"
}

# download creator
# don't forget version name in README.md
VPAI_VERSION=0.3.0
curl --request GET -sL \
     --url "https://github.com/anatawa12/VPMPackageAutoInstaller/releases/download/v$VPAI_VERSION/creator.mjs" \
     --output "$BASE_FOLDER/creator.mjs"

for file in *
do
  if [[ ! "$file" =~ \.json$ ]] || [[ "$file" =~ \.min\.json$ ]]; then
    continue 
  fi

  name="${file%.json}"
  minified="$name.min.json"
  unitypackage="$name-installer.unitypackage"

  minify "$file" "$minified"
  create "$minified" "$unitypackage"
done
