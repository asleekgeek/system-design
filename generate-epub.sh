#! /usr/bin/env bash

generate_from_stdin() {
  outfile=$1
  echo "Generating..."

  pandoc --metadata-file=epub-metadata.yaml --metadata=lang:'en' --from=markdown -o $1 <&0

  echo "Done! You can find the 'sytem-design-primer.epub' book at ./$outfile"
}

generate_with_solutions () {
  tmpfile=$(mktemp /tmp/sytem-design-primer-epub-generator.XXX)

  cat ./README.md >> $tmpfile

  for dir in ./solutions/system_design/*; do 
    case $dir in *template*) continue;; esac
    case $dir in *__init__.py*) continue;; esac
    : [[ -d "$dir" ]] && ( cd "$dir" && cat ./README.md >> $tmpfile && echo "" >> $tmpfile )
  done

  cat $tmpfile | generate_from_stdin 'sytem-design-primer.epub' 'en'

  rm "$tmpfile"
}

# Check if depencies exist
check_dependencies () {
  for dependency in "${dependencies[@]}"
  do
    if ! [ -x "$(command -v $dependency)" ]; then
      echo "Error: $dependency is not installed." >&2
      exit 1
    fi
  done
}

dependencies=("pandoc")

check_dependencies
generate_with_solutions

