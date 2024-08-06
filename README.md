# TO-DO:

* explain the rationale for the choice of certain sumstats


# Introduction
This project applies Structural Equation Modelling method (SEM) on the summary statistics of large GWAS on T2D, CAD, stroke, Glycemic traits - fasting glucose, fasting insulin, Glucose 2hr after challenge, insulin fold change.

The datasets used in the analyses:

|Study|Build|Strand|Neff|Traits|Analysis Method|Notes|
|:---|:---|:---|:----|:---|:---|:-----|
|[Chen 2021](https://magicinvestigators.org/downloads/Trans_readme.pdf)|37|+|num of individuals passing QC test for that variant|FI,FG,HBA1C,GLU2H|FEIVW (METAL)|people without diabetes|
|[Williamson 2023](https://magicinvestigators.org/downloads/MAGIC_postchallengeIR_README_text_updated30823.pdf)|37|+|num of individuals passing QC test for that variant|IFC|FEIVW (METAL)|people without diabetes, use adjBMI data|
|[Mishra 2022](https://www.ebi.ac.uk/gwas/studies/GCST90104539)|37|n/a|n/a|stroke|FEIVW (METAL)|take `beta` column for Beta, i.e. effect size or log(OR)|
|[Aragam 2022](https://t2d.hugeamp.org/dinspector.html?dataset=Aragam2022_CAD_EU&phenotype=CAD)|37|n/a|n/a|coronary artery disease|FEIVW (METAL) on log(OR)|take the `Effective_Cases` column for Neff: Sum of the effective number of cases (calculated within each study as the variant-specific INFO score multiplied by the number of cases, with INFO score=1 for genotyped variants) across studies => **sum of effective sample size**|
|[Mahajan 2022](https://www.diagram-consortium.org/downloads.html)|37|n/a|n/a|T2D|FEIVW (METAL) on log(OR)|n/a|

8 columns are chosen in this order from the initial summary datasets: A1, A2, Beta, StdErr, P-value, Neff (or effect allele frequency if applicable), CHR:BP, and MAF. For the datasets with only CHR:BP as identity for a variant, rsIDs are inferred by mapping CHR:BP to that in the LD reference file. If A1 and A2 in summary statistics data are the same as A2 and A1 in reference SNP set, then the reversal of beta direction is executed through the `maptoLDhm3.sh` script. Ultimately, about 1 million SNPs are retained for each summary statistics dataset.


# Results

## Population prevalence's trivial influence on estimated genetic correlation of binary traits - T2D, stroke, CAD

The population prevalence is used in converting the observe-scaled heritability to liability-scaled heritability which is used for LD score regression analysis, according to equation [4, Grotzinger et. al, 2023](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10066905/). Varying population prevalence will change the converted liability-scaled heritability, which is the y-axis of the LDSR regression plot. This will change the genetic covariance and correlation, or the empirical covariance matrix. Hence, a SNP identified as significant for a genetic factor in a model, may not reach significance for the same factor in the same model but estimated for a different empirical covariance matrix due to different population prevalence.

Prevalence is calculated in Europe:

* CAD: [Globally, it was estimated that in 2020, 244.1 million people were living with ischemic heart disease (IHD), and it was more prevalent in males than in females (141.0 and 103.1 million people, respectively). ](https://www.heart.org/-/media/PHD-Files-2/Science-News/2/2022-Heart-and-Stroke-Stat-Update/2022-Stat-Update-factsheet-GIobal-Burden-of-Disease.pdf) => 0.031131
* Stroke: 
  + Estimate 1: [Truelsen et. al 2006, Stroke incidence and prevalence in Europe: a review of available data](https://onlinelibrary.wiley.com/doi/10.1111/j.1468-1331.2006.01138.x#b28). With WHO estimates of Europeans' stroke incidence in 2000, projections are made of stroke incidence rate per year up until 2025, with stable rate, or increased or decreased 2% every 5 years. If the stroke rate is unchanged from 2000, it's estimated that 1.5 million Europeans suffered from stroke in 2025. The countries included in this analyses are current EU member countries, with the addition of UK, Iceland, Norway, and Switzerland. The total population of these countries in 2025 is estimated to be 501,044,143 people. This translates to a rate of 0.00299.
  + Estimate 2: [Wafa et. al 2020, Burden of Stroke in Europe: Thirty-Year Projections of Incidence, Prevalence, Deaths, and Disability-Adjusted Life Years](https://www.ahajournals.org/doi/10.1161/STROKEAHA.120.029606). Table: Changes in Population Count and Stroke Incidence, Prevalence, Deaths, and DALYs in the EU Between 2017 and 2047 => take the estimates of 2027: 0.0202935.
* T2D: 
  + The paper on T2D by Manhajan et. al 2022 mentioned that approximately 392 million individuals suffer from T2D in 2015, when world population is at 7,426,597,536 people. => 0.052783
  + Based on the factsheet by AHA above, the rate translates to 0.06024 in 2020.
  
Hence, I tried 4 combinations of different population prevalences for CAD, stroke and T2D:

  * run 1: 0.052783 T2D and 0.00299 stroke
  * run 2: 0.052783 T2D and 0.0202935 stroke
  * run 3: 0.06024 T2D and 0.0202935 stroke
  * run 4: 0.06024 T2D and 0.00299 stroke
  
![](data/run1/ldsc_gencorre.png)
![](data/run2/ldsc_gencorre.png)
![](data/run3/ldsc_gencorre.png)
![](data/run4/ldsc_gencorre.png)

As the genetic correlations are minutely different in 4 runs, I decided on using population prevalence statistics of 0.031131 CAD, 0.06024 T2D and 0.0202935 stroke.

## 4 factor model's excellent fit to 10 glycemic and 2 cardiovascular traits

The 4 factor model is specified as below:

```
F1 =~ NA*GLU2H + IFC + FG
            F2 =~ NA*FG + GLU2H + HBA1C + T2D +IFC
            F3 =~ NA*CAD + STROKE + T2D + FG
            F4 =~ NA*FG + FI+ HBA1C
IFC~~a*IFC
a>0.001
F1~~F2
F1~~F3
F2~~F3
F1~~F4
F2~~F4
F3~~F4
```

The model has very good fit to the genetic covariance matrix p-value Chi square (df = 7) of 0.2801629, CFI of 0.9987332, SRMR of 0.01689321.

## Multivariate GWAS of 4-factor model

