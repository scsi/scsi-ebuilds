#!/bin/bash
[ -n "$1" ] && wget -q -O - "$1"|w3m -dump -T text/html -cols 100
