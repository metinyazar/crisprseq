# nf-core/crisprseq: Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v2.4.0dev]

### Added

- Add an acknowlodgement to Hitselection method ([#222]https://github.com/nf-core/crisprseq/pull/222)

### Fixed

- Improve the method of Hitselection module to run the pipeline faster ([#222]https://github.com/nf-core/crisprseq/pull/222)
- Fix a bug in the DrugZ module for the removed genes parameter ([#222]https://github.com/nf-core/crisprseq/pull/222)

### General

## [v2.3.0 - Lime Nightingale](https://github.com/nf-core/crisprseq/releases/tag/2.3.0) - [08.11.2024]

### Added

- Add module to classify samples by clonality ([#178](https://github.com/nf-core/crisprseq/pull/178))
- Add DrugZ, a module for chemogenetic interaction ([#168](https://github.com/nf-core/crisprseq/pull/168))
- Add Hitselection, a module for subsetting more likely true positives for KO screen based on the protein protein interaction ([#191](https://github.com/nf-core/crisprseq/pull/191))
- Make the use of gene essentiality module more user friendly and readable in the code ([#194](https://github.com/nf-core/crisprseq/pull/194))

### Fixed

- Fix cutadapt 3' and 5' no such variable found bug ([#187](https://github.com/nf-core/crisprseq/pull/187))
- Fix design matrix bug that introduced dots instead of a hyphen ([#190](https://github.com/nf-core/crisprseq/pull/190))
- Make output of FluteMLE optional as when some pathways produce bugs some channels are then empty ([#190](https://github.com/nf-core/crisprseq/pull/190))
- Fix a typo in crisprcleanr/normalize, when a user inputs a file ([#192](https://github.com/nf-core/crisprseq/pull/192))
- Add Singularity and Docker tests in the CI, also fix any issues users had when running MAGeCKFlute with Docker or Singularity. ([#214](https://github.com/nf-core/crisprseq/pull/214))

### General

- Run pipeline tests with docker, singularity and conda on CI ([#185](https://github.com/nf-core/crisprseq/pull/185))

## [v2.2.1 Romarin Curie - patch](https://github.com/nf-core/crisprseq/releases/tag/2.2.1) - [23.07.2024]

### Fixed

- Fix singularity image pull tag for MAGeCKFlute ([#160](https://github.com/nf-core/crisprseq/pull/160))
- Escape dollar signs in `containerOptions` ([#163](https://github.com/nf-core/crisprseq/pull/163))
- Fix error in R script when adding patterns ([#170](https://github.com/nf-core/crisprseq/pull/170))
- Skip MAGeCKFlute when the function produces an error within the R package ([#171](https://github.com/nf-core/crisprseq/pull/170))

## [v2.2.0 - Romarin Curie](https://github.com/nf-core/crisprseq/releases/tag/2.2.0) - [20.06.2024]

### Added

- Template update to 2.11.1 ([#105](https://github.com/nf-core/crisprseq/pull/105))
- Added a csv input option for crisprcleanr ([#105](https://github.com/nf-core/crisprseq/pull/105))
- Added a contrasts parameter so the pipeline automatically creates design matrices and MAGeCK MLE ([#109](https://github.com/nf-core/crisprseq/pull/109))
- Added bowtie2 and three prime and five prime adapter trimming ([#103](https://github.com/nf-core/crisprseq/pull/103) and [#123](https://github.com/nf-core/crisprseq/pull/123))
- Added `--day0_label` and `FluteMLE` for MLE data [#126](https://github.com/nf-core/crisprseq/pull/126)
- Template update to 2.13.1 ([#124](https://github.com/nf-core/crisprseq/pull/124))
- Metromap added in the docs ([#128](https://github.com/nf-core/crisprseq/pull/128))
- Added MAGeCK count table in the multiqc ([#131](https://github.com/nf-core/crisprseq/pull/131))
- Added additional plots to Tower output ([#130](https://github.com/nf-core/crisprseq/pull/130))

### Fixed

- Adapt cutadapt module to work with single-end and paired-end reads again ([#121](https://github.com/nf-core/crisprseq/pull/121))
- Fix premature completion of the pipeline when paired-end reads were merged ([#145](https://github.com/nf-core/crisprseq/pull/145))
- Create empty \*-QC-indels.csv file if alignments not found. ([#138](https://github.com/nf-core/crisprseq/pull/138))
- Fix `--reference_fasta` and `--protospacer` parameters ([#144](https://github.com/nf-core/crisprseq/pull/144))

## [v2.1.1 - Jamon Salas - patch](https://github.com/nf-core/crisprseq/releases/tag/2.1.1) - [14.12.2023]

### Added

- Update all modules to the last version in nf-core/modules ([#92](https://github.com/nf-core/crisprseq/pull/92))
- More documentation for screening analysis. ([#99](https://github.com/nf-core/crisprseq/pull/99))
- Contrasts are now given under a different flag and MAGeCK MLE and BAGEL2 are automatically run instead of MAGeCK RRA. ([#99](https://github.com/nf-core/crisprseq/pull/99))
- Added cutadapt for screening analysis ([#95](https://github.com/nf-core/crisprseq/pull/95))

### Fixed

- Fixed paired-end for screening analysis ([#94](https://github.com/nf-core/crisprseq/pull/94))

## [v2.1.0 - Jamon Salas](https://github.com/nf-core/crisprseq/releases/tag/2.1.0) - [14.11.2023]

### Added

- Template update v2.9 ([#52](https://github.com/nf-core/crisprseq/pull/52))
- Use `Channel.fromSamplesheet()` from `nf-validation` to validate input sample sheets and create an input channel ([#58](https://github.com/nf-core/crisprseq/pull/58))
- BAGEL2 as a module which detects gene essentiality ([#60](https://github.com/nf-core/crisprseq/pull/60))
- Add custom plots to MultiQC report (cutadapt module, read processing, edition, edition QC) ([#64](https://github.com/nf-core/crisprseq/pull/64))
- Template update v2.10 ([#79](https://github.com/nf-core/crisprseq/pull/79))

### Fixed

- Change to `process_high` for the mageck mle module ([#60](https://github.com/nf-core/crisprseq/pull/60))
- Fix paired-end samplesheet file for screening ([#60](https://github.com/nf-core/crisprseq/pull/60))
- Summary processes don't modify the input file anymore, allowing resuming these processes ([#66](https://github.com/nf-core/crisprseq/pull/66))
- Do not stash unexistent files, use empty lists instead. Fixes AWS tests ([#67](https://github.com/nf-core/crisprseq/pull/67))
- Rename process `merging_summary` to `preprocessing_summary` to improve clarity ([#69](https://github.com/nf-core/crisprseq/pull/69))
- Fix modules `BWA_INDEX` and `BOWTIE2_BUILD` after module update, new versions accept a meta map ([#76](https://github.com/nf-core/crisprseq/pull/76))
- Update targeted metromap ([#78](https://github.com/nf-core/crisprseq/pull/78))

### Deprecated

## [v2.0.0 - Paprika Lovelace](https://github.com/nf-core/crisprseq/releases/tag/2.0.0) - [05.07.2023]

### Added

- Crisprseq screening analysis : mageck mle, mageck rra, mageck count and crisprcleanr-normalize ([#22](https://github.com/nf-core/crisprseq/pull/22))
- Add new parameter `--analysis` to select analysis type (screening/targeted) ([#27](https://github.com/nf-core/crisprseq/pull/27))
- Tests to run screening analysis ([#926]https://github.com/nf-core/test-datasets/pull/926)
- Metro map for targeted analysis ([#35](https://github.com/nf-core/crisprseq/pull/35))
- Add new parameters `--reference` and `--protospacer` ([#45](https://github.com/nf-core/crisprseq/pull/45))
- Add UMI clustering to crisprseq-targeted ([#24](https://github.com/nf-core/crisprseq/pull/24))
- Template update v2.8 ([#21](https://github.com/nf-core/crisprseq/pull/21))

### Fixed

- Fix warning "module used more than once" ([#25](https://github.com/nf-core/crisprseq/pull/25))
- Remove profile `aws_tower`, update from nf-core/tools v2.9 to make full tests pass ([#50](https://github.com/nf-core/crisprseq/pull/50))
- Remove `quay.io` from all containers ([#50](https://github.com/nf-core/crisprseq/pull/50))
- Fix resources on test screening full ([#50](https://github.com/nf-core/crisprseq/pull/56))
- Fix id in crisprcleanr-normalize ([#50](https://github.com/nf-core/crisprseq/pull/56))

## [v1.0 - Salted Hypatia](https://github.com/nf-core/crisprseq/releases/tag/1.0) - [02.02.2023]

Initial release of nf-core/crisprseq, created with the [nf-core](https://nf-co.re/) template.
