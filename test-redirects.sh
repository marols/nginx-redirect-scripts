#!/bin/bash

FILES=sources/*.csv

good=0
bad=0

printf  "\n\n\
==========================================\n\
\e[1mRunning Nginx redirect tests\e[0m\n\
==========================================\n\n"

for file in $FILES
do
    printf "Now processing: \e[35m$file\e[0m\n"

    loopGood=0
    loopBad=0

    while read line; do
        IFS=';' read -ra URLS <<< "$line"

        responseCode=$(curl --write-out "%{http_code}" --silent --output /dev/null ${URLS[0]})
        responseUrl=$(curl -L --write-out "%{url_effective}" --silent --output /dev/null ${URLS[0]})

        formattedUrl=$(python -c "import urllib, sys; print urllib.unquote(sys.argv[1])" ${responseUrl})

        response="$responseCode $formattedUrl"
        #printf "\n\n${URLS[0]}\n${URLS[1]}\n"

        if [ "$response" == "301 ${URLS[1]}" ]; then
            printf "."
            let "good++"
            let "loopGood++"
        else
            printf "F\n"
            printf "Req: ${URLS[0]}\n"
            printf "Act: $response\n"
            printf "Exp: 301 ${URLS[1]}\n"
            let "bad++"
            let "loopBad++"
        fi
    done < $file

    printf "\n\e[32m$loopGood passed\e[0m. \e[31m$loopBad failed.\e[0m \n---\n\n"

done

printf  "\n\n\
==========================================\n\
\e[1mSummary\e[0m\n\
==========================================\n\n\
\e[32m$good URLs redirect properly\e[0m. \e[31m$bad have failed.\e[0m \n\n\
==========================================\n\n"
