---
order: 2
---

# nf-core/crisprseq: Usage

## :warning: Please read this documentation on the nf-core website: [https://nf-co.re/crisprseq/usage](https://nf-co.re/crisprseq/usage)

> _Documentation of pipeline parameters is generated automatically from the pipeline schema and can no longer be found in markdown files._

## Introduction

The **nf-core/crisprseq** pipeline allows the analysis of CRISPR edited CRISPR pooled DNA. It can evaluate important genes from knock-out or activation CRISPR-Cas9 screens.

## Running the pipeline

The typical command for running the pipeline is as follows:

```bash
nextflow run nf-core/crisprseq --analysis screening --input samplesheet.csv --library library.tsv --outdir <OUTDIR> -profile docker
```

The following required parameters are here described.
If you wish to input a raw count or normalized table, you can skip the samplesheet parameter as well as the library one and directly input your table using count_table `--count_table your_count_table`. Your count table should contain the following columns : sgRNA and gene. You can find an example [here](https://github.com/nf-core/test-datasets/blob/crisprseq/testdata/count_table.tsv) If your count table is normalized, be sure to set the normalization method to none in MAGeCK MLE or MAGeCK RRA using a config file.

### Full samplesheet

The samplesheet can have as many columns as you desire, however, there is a strict requirement for the first 4 columns to match those defined in the table below.

```csv title="samplesheet.csv"
sample,fastq_1,fastq_2,condition
SRR8983579,SRR8983579.small.fastq.gz,,control
SRR8983580,SRR8983580.small.fastq.gz,,treatment
```

| Column      | Description                                                                                                                           |
| ----------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| `sample`    | Custom sample name. Spaces in sample names are automatically converted to underscores (`_`).                                          |
| `fastq_1`   | Full path to FastQ file for Illumina short reads 1. File has to be gzipped and have the extension ".fastq.gz" or ".fq.gz".            |
| `fastq_2`   | Full path to FastQ file for Illumina short reads 2. File has to be gzipped and have the extension ".fastq.gz" or ".fq.gz". (Optional) |
| `condition` | Condition of the sample, for instance "treatment" or "control".                                                                       |

An [example samplesheet](https://github.com/nf-core/test-datasets/blob/crisprseq/testdata/samplesheet_test.csv) has been provided with the pipeline.

### cutadapt

MAGeCK count which is the main alignment software used is normally able to automatically determine the trimming length and sgRNA length, in most cases. Therefore, you don't need to go to this step unless MAGeCK fails to do so by itself. If the nucleotide length in front of sgRNA varies between different reads, you can use cutadapt to remove the adaptor sequences by using the flag `--five_prime_adapter` or `--three_prime_adapter` .

### bowtie2

The MAGeCK count module supports bam files, which allows you to align with bowtie2 first. If you wish to do so (for instance to allow mapping reads to the library with mismatches or to set the aligner with specific flags) you can provide a fasta file with `--fasta` encoding the library. Currently, you also still need to provide the tab-separated library file with `--library`.

### library

If you are running the pipeline with fastq files and wish to obtain a count table, the library parameter is needed. The library table has three mandatory columns : id, target transcript (or gRNA sequence) and gene symbol.
An [example](https://github.com/nf-core/test-datasets/blob/crisprseq/testdata/brunello_target_sequence.txt) has been provided with the pipeline. Many libraries can be found on [addgene](https://www.addgene.org/).

After the alignment step, if you are performing KO (Knock-Out) screens, you can choose to correct gene-independent cell responses to CRISPR-Cas9 targeting using CRISPRcleanR. If you are performing a CRISPR interference or activation screen, this step is not needed.

The pipeline currently supports 3 algorithms to detect gene essentiality, MAGeCK RRA, MAGeCK MLE and BAGEL2. MAGeCK MLE (Maximum Likelihood Estimation) and MAGeCK RRA (Robust Ranking Aggregation) are two different methods provided by the MAGeCK software package to analyze CRISPR-Cas9 screens. BAGEL2 identifies gene essentiality through Bayesian Analysis.
We recommend to run MAGeCK MLE and BAGEL2 as these are the most used and most recent algorithms to determine gene essentiality.

### Running CRISPRcleanR

[CRISPRcleanR](https://github.com/francescojm/CRISPRcleanR) is used for gene count normalization and the removal of biases for genomic segments for which copy numbers are amplified. Currently, the pipeline supports annotation libraries already present in the R package or user-provided annotation files.
Most used library already have an annotation dataset which you can find [here](https://github.com/francescojm/CRISPRcleanR/blob/master/Reference_Manual.pdf). To use CRISPRcleanR normalization, use `--crisprcleanr library`, `library` being the exact name as the library in the CRISPRcleanR documentation (e.g: "AVANA_Library").
Otherwise, if you wish to provide your own file, please provide it in CSV format, and make sure it follows the following format (with the comma in front of "CODE" included):

| ,CODE                | GENES       | EXONE         | CHRM | STRAND | STARTpos | ENDpos   |
| -------------------- | ----------- | ------------- | ---- | ------ | -------- | -------- |
| ATGGTGTCCATTATAGCCAT | NM_021446.2 | 0610007P14Rik | ex2  | 12     | +        | 85822165 |
| CTCTACGAGAAGCTCTACAC | NM_021446.2 | 0610007P14Rik | ex2  | 12     | +        | 85822108 |
| GACTCTATCACATCACACTG | NM_021446.2 | 0610007P14Rik | ex4  | 12     | +        | 85816419 |

### Running gene essentiality scoring

nf-core/crisprseq supports 4 gene essentiality analysis modules: MAGeCK RRA, MAGeCK MLE,
BAGEL2 and DrugZ. You can run any of these modules by providing a contrast file using `--contrasts` and the flag of the tool you wish to use:

- `--rra` for MAGeCK RRA
- `--mle` for MAGeCK MLE
- `--drugz` for DrugZ
- `--bagel2` for BAGEL2

The contrast file must contain the headers "reference" and "treatment". These two columns should be separated with a semicolon (;) and contain the `csv` extension. You can also integrate several samples/conditions by comma-separating them in each column. Please find an example below:

| reference         | treatment             |
| ----------------- | --------------------- |
| control1          | treatment1            |
| control1,control2 | treatment1,treatment2 |

A full example can be found [here](https://raw.githubusercontent.com/nf-core/test-datasets/crisprseq/testdata/full_test/samplesheet_full.csv).

#### Venn diagram

Running MAGeCK MLE and BAGEL2 with a contrast file will also output a Venn diagram showing common genes having an FDR < 0.1.

### MAGeCK RRA

MAGeCK RRA performs robust ranking aggregation to identify genes that are consistently ranked highly across multiple replicate screens. To run MAGeCK RRA, you can define the contrasts as previously stated in the last section with `--contrasts` <<your_file.txt>> (with a `.txt` extension) and also specify `--rra`.

### Running MAGeCK MLE only

#### With your own design matrices

If you wish to run MAGeCK MLE only, you can specify several design matrices (where you state which comparisons you wish to run) with the flag `--mle_design_matrix`.
MAGeCK MLE uses a maximum likelihood estimation approach to estimate the effects of gene knockout on cell fitness. It models the read count data of guide RNAs targeting each gene and estimates the dropout probability for each gene.
MAGeCK MLE requires one or several design matrices. The design matrix is a `txt` file indicating the effects of different conditions on different samples.
An [example design matrix](https://github.com/nf-core/test-datasets/blob/crisprseq/testdata/design_matrix.txt) has been provided with the pipeline. The row names need to match the condition stated in the sample sheet.
If there are several designs to be run, you can input a folder containing all the design matrices. The output results will automatically take the name of the design matrix, so make sure you give a meaningful name to the file, for instance "Drug_vs_control.txt".

#### With the day0 label

This label is not mandatory as in case you are running time series. If you wish to run MAGeCK MLE with the day0 label you can do so by specifying `--day0_label` and the sample names that should be used as day0. The contrast will then be automatically adjusted for the other days.

#### With the contrast file

To run MAGeCK MLE, you can define the contrasts as previously stated in the last section with `--contrasts <your_file.txt>` and also specify `--mle`.

### MAGeCKFlute

The downstream analysis involves distinguishing essential, non-essential, and target-associated genes. Additionally, it encompasses conducting biological functional category analysis and pathway enrichment analysis for these genes. Furthermore, it provides visualization of genes within pathways, enhancing user exploration of screening data. MAGECKFlute is run automatically after MAGeCK MLE and for each MLE design matrice. If you have used the `--day0_label`, MAGeCKFlute will be ran on all the other conditions. Please note that the DepMap data is used for these plots.

#### Using negative control sgRNAs for MAGeCK MLE

You can add the parameter `--mle_control_sgrna` followed by your file (one non targeting control sgRNA per line) to integrate the control sgRNA in MAGeCK MLE.

### Running BAGEL2

BAGEL2 (Bayesian Analysis of Gene Essentiality with Location) is a computational tool developed by the Hart Lab at Harvard University. It is designed for analyzing large-scale genetic screens, particularly CRISPR-Cas9 screens, to identify genes that are essential for the survival or growth of cells under different conditions. BAGEL2 integrates information about the location of guide RNAs within a gene and leverages this information to improve the accuracy of gene essentiality predictions.
BAGEL2 uses the same contrasts from `--contrasts` and is run with the extra parameter `--bagel2`.

### Running drugZ

[DrugZ](https://github.com/hart-lab/drugz) detects synergistic and suppressor drug-gene interactions in CRISPR screens. DrugZ is an open-source Python software for the analysis of genome-scale drug modifier screens. The software accurately identifies genetic perturbations that enhance or suppress drug activity. To run drugZ, you can specify `--drugz` with the contrast file `--contrasts <your_file.csv>`. The contrasts file should contain two columns, separated with a semicolon (;), and have the `csv` extension. You can also integrate several samples/conditions by comma-separating them in each column:

| reference         | treatment             |
| ----------------- | --------------------- |
| control1          | treatment1            |
| control1,control2 | treatment1,treatment2 |

The contrast from reference to treatment should be ; separated

#### Removing genes before analysis

If you wish to remove specific genes before the drugZ analysis, you can use the `--drugz_remove_genes` option following a comma separated list of genes.

### Running Hitselection

Hitselection provides the user with a threshold and a set of genes that are likely to be closer to true positives by identifying the most interconnected subnetworks within the ranked gene list. This module is for now only developed for KO screens on Human data mapped to Entrez IDs.

Hitselection is a script for identifying rank thresholds for CRISPR screen results based on using the connectivity of subgraphs of protein-protein interaction (PPI) networks. The script is based on R and is also an implementation of RNAiCut (Kaplow et al., 2009), a method for estimating thresholds in RNAi data. The principle behind Hitselection is that true positive hits are densely connected in the PPI networks. The script runs a simulation based on Poisson distribution of the ranked screen gene list to calculate the -logP value for comparing the interconnectivity of the real subnetwork and the degree match random subnetwork of each gene, one by one. The degree of the nodes is used as the interconnectivity metric.

To run Hitselection, you can specify '--hitselection' and it will automatically run on the gene essentiality algorithms you have chosen. The outputs are a `png` file containing the -logP value vs gene rank plot and a txt file containing all the -logP values, edge and average edge values and ranked gene symbols.

> [!WARNING]
> The hitselection algorithm is for the moment developed only for KO screens and requires the library to map to genes with an Homo Sapiens EntrezID.

> [!WARNING] Please be advised that the Hitselection algorithm is time intensive and will make the pipeline run longer

Note that the pipeline will create the following files in your working directory:

```bash
work                # Directory containing the nextflow working files
<OUTDIR>            # Finished results in specified location (defined with --outdir)
.nextflow_log       # Log file from Nextflow
# Other hidden nextflow files, eg. history of pipeline runs and old logs.
```
