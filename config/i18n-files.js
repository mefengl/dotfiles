#!/bin/bash

mkdir -p locales

cat << EOF | while read -r line
English (US)	en
Simplified Chinese	zh-cn
Traditional Chinese	zh-tw
French	fr
German	de
Italian	it
Spanish	es
Japanese	ja
Korean	ko
Russian	ru
Portuguese (Brazil)	pt-br
Turkish	tr
Polish	pl
Czech	cs
Hungarian	hu
EOF
do
  language=$(echo $line | awk '{print $NF}')
  touch locales/$language.json
done
