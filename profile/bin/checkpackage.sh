#!/bin/sh

equery -q -C k -o "*"|tr -d " "|tr : "\n"|grep -v ^failed|while read pkg; do emerge -1v =$pkg; done
