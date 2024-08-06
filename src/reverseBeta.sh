#!/bin/bash
refsnplist=$1
maptold_hm3=$2
output=$3
awk 'BEGIN {FS=OFS="\t"} NR==FNR {ar1[$1]=$2; ar2[$1]=$3; next} {as1[$8]=$1; as2[$8]=$2; if (ar1[$8] == as2[$8] && ar2[$8] == as1[$8]) {print ar1[$8],ar2[$8],-$3,$4,$5,$6,$7,$8} else {print $0}}' $refsnplist $maptold_hm3 > maptold_hm3_a1a2_fixed.txt
mv maptold_hm3_a1a2_fixed.txt $output
# else if ((ar1[$8] != as1[$8] && ar2[$8] == as2[$8]) || (ar1[$8] == as1[$8] && ar2[$8] != as2[$8])) {print ar1[$8],ar2[$8],$3,$4,$5,$6,$7,$8} else if ((ar1[$8] == as2[$8] && ar2[$8] != as1[$8]) || (ar1[$8] != as2[$8] && ar2[$8] == as1[$8])) {print ar1[$8],ar2[$8],-$3,$4,$5,$6,$7,$8}