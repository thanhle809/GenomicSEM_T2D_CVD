
# script to calculate the MAF column in the summary statistics
cd ~/GenomicSEM/data/sumstats_raw/Chen
awk 'BEGIN {FS=OFS="\t"}{if ($6 == "NA") {print $4,$5,$7,$8,$9,$10,$2":"$3,0.000001} else if ($6 > 0.5) {print $4,$5,$7,$8,$9,$10,$2":"$3,1-$6} else {print $4,$5,$7,$8,$9,$10,$2":"$3,$6}}' MAGIC1000G_FI_EUR.tsv > FI_withmaf_sumstats.tsv
awk 'BEGIN {FS=OFS="\t"}{if ($6 == "NA") {print $4,$5,$7,$8,$9,$10,$2":"$3,0.000001} else if ($6 > 0.5) {print $4,$5,$7,$8,$9,$10,$2":"$3,1-$6} else {print $4,$5,$7,$8,$9,$10,$2":"$3,$6}}' MAGIC1000G_HbA1c_EUR.tsv > HBA1C_withmaf_sumstats.tsv
awk 'BEGIN {FS=OFS="\t"}{if ($6 == "NA") {print $4,$5,$7,$8,$9,$10,$2":"$3,0.000001} else if ($6 > 0.5) {print $4,$5,$7,$8,$9,$10,$2":"$3,1-$6} else {print $4,$5,$7,$8,$9,$10,$2":"$3,$6}}' MAGIC1000G_FG_EUR.tsv > FG_withmaf_sumstats.tsv
awk 'BEGIN {FS=OFS="\t"}{if ($6 == "NA") {print $4,$5,$7,$8,$9,$10,$2":"$3,0.000001} else if ($6 > 0.5) {print $4,$5,$7,$8,$9,$10,$2":"$3,1-$6} else {print $4,$5,$7,$8,$9,$10,$2":"$3,$6}}' MAGIC1000G_2hrGLU_EUR.tsv > GLU2H_withmaf_sumstats.tsv
awk 'BEGIN {FS=OFS="\t"} {if ($7 > 0.5) {print $3,$4,$5,$6,$8,$9,$1":"$2,1-$7} else {print $3,$4,$5,$6,$8,$9,$1":"$2,$7}}' MAGIC_postchallengeIR_IFC_adjBMI_EUR.tsv > IFC_withmaf_sumstats.tsv
mv *_withmaf_sumstats.tsv ../../inuse/withmaf

# map CHR:BP to rsID and change directions if needed
../../../src/maptoLDhm3.sh ../../reference/eur_w_ld_chr/LDscore_concat.txt FG_withmaf_sumstats.tsv ../../reference/eur_w_ld_chr/w_hm3.snplist FG_withmaf_mappedldhm3.tsv
../../../src/maptoLDhm3.sh ../../reference/eur_w_ld_chr/LDscore_concat.txt FI_withmaf_sumstats.tsv ../../reference/eur_w_ld_chr/w_hm3.snplist FI_withmaf_mappedldhm3.tsv
../../../src/maptoLDhm3.sh ../../reference/eur_w_ld_chr/LDscore_concat.txt HBA1C_withmaf_sumstats.tsv ../../reference/eur_w_ld_chr/w_hm3.snplist HBA1C_withmaf_mappedldhm3.tsv
../../../src/maptoLDhm3.sh ../../reference/eur_w_ld_chr/LDscore_concat.txt GLU2H_withmaf_sumstats.tsv ../../reference/eur_w_ld_chr/w_hm3.snplist GLU2H_withmaf_mappedldhm3.tsv