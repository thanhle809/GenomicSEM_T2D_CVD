# TO-DO:

* explain the rationale for the choice of certain sumstats


# Introduction
This project applies Structural Equation Modelling method (SEM) on the summary statistics of large GWAS on T2D, CAD, stroke, Glycemic traits - fasting glucose, fasting insulin, Glucose 2hr after challenge, insulin fold change.

# Summary statistics:

| Trait | Build | Population & case/control | Effect | Paper | Link |
|:------|:------|:------|:------|:------|:------|
|Fasting glucose | GRCh37 | EUR | beta | Chen 2021 | |
|Fasting insulin | GRCh37 | EUR | beta | Chen 2021 | |
|HbA1c | GRCh37 | EUR | beta | Chen 2021 | |
|HbA1c | GRCh37 | EUR | beta | Chen 2021 | |
|T2D | GRCh37 | EUR | log[OR] | Manhajan 2022 | https://diagram-consortium.org/downloads.html |
|CAD | GRCh37 | EUR | log[OR] | Aragam 2022| |
|Coronary atherosclerosis | GRCh37 | EUR | log[OR] | Tcheandjieu 2022| |
|Insulin fold change | GRCh37 | EUR | beta | Williamson 2023 | |
|Stroke | GRCh37 | EUR | log[OR] | Mishra | |

# Directory organization:
- data
  - reference
    - eur_w_ld_chr
      - LDscores_concatenated_CHR:BP.txt: the reference LD score files from the 1000 Genomes Project are concatenated, with a new column added CHR:BP
- src


      