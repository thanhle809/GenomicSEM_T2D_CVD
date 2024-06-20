#!/bin/bash
# This script matches the summary statistics with only CHR:BP marker to reference LD score files to get rsID => map to reference SNP panel
# SNPs not existed in SNp reference panel are added, while if SNPs existed are checked if A1 and A2 are consistent. If not consistent,
# The A1 and A2 of SNP reference panel is taken instead, and change maded to the sumstats file.
# LD score file has 7 columns: CHR,SNP,BP,CM,MAF,l2,CHR:BP
# Sumstats file has 7 columns: A1,A2,Beta,StdErr,P-value,Neff (or FreqA1),CHR:BP
# Reference SNP panel: SNP,A1,A2
# The reference SNP panel must have an empty last line
LDscorefile=$1
sumstats=$2
refsnplist=$3
awk 'BEGIN {FS=OFS=","} NR==FNR {a[$7]=$2; next} {if ($7 in a) {print $0, a[$7];next} else {next}}' $LDscorefile $sumstats > maptold.txt
awk 'BEGIN {FS=OFS=","} NR==FNR {a[$1]; next} {if ($8 in a) {print $0;next} else {next}}' $refsnplist maptold.txt > maptold_hm3.txt
awk 'BEGIN {FS=OFS=","} NR==FNR {a[$1]; next} {if ($8 in a) {next} else {print $0;next}}' $refsnplist maptold.txt > maptold_hm3_na.txt
awk 'BEGIN {FS=OFS=","} {print $8,toupper($1),toupper($2);next}' maptold_hm3_na.txt  > maptold_hm3_na_upper.txt
cat maptold_hm3_na_upper.txt >> $refsnplist
awk 'BEGIN {FS=OFS=","} NR==FNR {ar1[$1]=$2; ar2[$1]=$3; next} {as1[$8]=$1; as2[$8]=$2;if (ar1[$8] == as1[$8] && ar2[$8] == as2[$8]) {print $0} else if (ar1[$8] == as2[$8] && ar2[$8] == as1[$8]) {print ar1[$8],ar2[$8],-$3,$4,$5,$6,$7,$8} else if ((ar1[$8] != as1[$8] && ar2[$8] == as2[$8]) || (ar1[$8] == as1[$8] && ar2[$8] != as2[$8])) {print ar1[$8],ar2[$8],$3,$4,$5,$6,$7,$8} else if ((ar1[$8] == as2[$8] && ar2[$8] != as1[$8]) || (ar1[$8] != as2[$8] && ar2[$8] == as1[$8])) {print ar1[$8],ar2[$8],-$3,$4,$5,$6,$7,$8}}' $refsnplist maptold_hm3.txt >  maptold_hm3_a1a2_fixed.txt
rm maptold_hm3.txt
cat maptold_hm3_na.txt >> maptold_hm3_a1a2_fixed.txt
mv maptold_hm3_a1a2_fixed.txt maptold_hm3.txt
rm maptold_hm3_na.txt
rm maptold.txt
rm maptold_hm3_na_upper.txt