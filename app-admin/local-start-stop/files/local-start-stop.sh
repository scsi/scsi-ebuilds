#!/bin/sh 
for file in /etc/local.d/*.${1} 
do ! test -x "${file}" || "${file}" 
done
