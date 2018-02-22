#!/bin/bash

FILES=sources/*.csv

if [ ! -d redirects ]; then
  mkdir -p redirects;
fi

counter=0

printf  "\n\n\
==========================================\n\
\e[1mGenerating Nginx redirects\e[0m\n\
==========================================\n\n\
Now processing:\n"

for file in $FILES
do
    printf "\e[35m$file\e[0m\n"

    filename=$(basename "$file")
    filename="${filename%.*}"

    masklen=$((${#filename} + 9)) 

    awk -v ulim="$masklen" -F ";" '{print "location /" substr($1,ulim), "{ return 301", $2, ";}"}' $file > "redirects/$filename.txt"
    let "counter++"
done

printf  "\n\n\
==========================================\n\
\e[1mSummary\e[0m\n\
==========================================\n\n\
Converted $counter files\n\n\
==========================================\n\n"





