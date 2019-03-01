#/bin/bash

HEADER_FILE="./header.txt"
OUTPUT_FILE="./project2.txt"

if [[ -e $OUTPUT_FILE ]]; then
    rm $OUTPUT_FILE
fi

cat $HEADER_FILE > $OUTPUT_FILE

psql -w -f setup.sql cs421

for i in {2..9}; do
    SOURCE_FILE="part$i.sql" 
    if [[ -f $SOURCE_FILE ]]; then
        echo "\n$1.\n\nSource:\n" > $OUTPUT_FILE
        cat $SOURCE_FILE > $OUTPUT_FILE
        echo "\nOutput:\n" > $OUTPUT_FILE
        psql -w -f $SOURCE_FILE cs421 > $OUTPUT_FILE
    fi
done
