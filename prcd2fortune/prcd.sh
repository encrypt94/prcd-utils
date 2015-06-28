#!/bin/sh
# 'njoy
tmp="/tmp/prcd/"
wget "http://www.papuasia.org/prcd/" -nd -r -np -A txt -P $tmp

for f in $tmp*
do
    nf=$(echo $f | cut -d '.' -f 1)
    cat $f | tr '\n' '\0' | xargs -0 -L1 -I '$' printf '$\n%%\n' > "$nf"
    strfile $nf
done

rm $tmp*.txt
mv $tmp* /usr/share/fortune/
rm -rf $tmp
