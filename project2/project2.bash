#/bin/bash

$HEADER_FILE="./header.txt"
$OUTPUT_FILE="./project2.txt"

rm $OUTPUT_FILE
cat $HEADER_FILE > $OUTPUT_FILE

psql -w -f setup.sql

for i in {2..9}; do
    if [[ -r part$1.sql ]]; then
        echo "\n$1.\n\nSource:\n" > $OUTPUT_FILE
        cat part$1.sql
        echo "\nOutput:\n"
        psql -w -f part$1.sql > $OUTPUT_FILE
    fi
done