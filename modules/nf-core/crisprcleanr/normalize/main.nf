process CRISPRCLEANR_NORMALIZE {
    tag "$meta.id"
    label 'process_medium'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/r-crisprcleanr:3.0.0--r42hdfd78af_1':
        'biocontainers/r-crisprcleanr:3.0.0--r42hdfd78af_1' }"

    input:
    tuple val(meta), path(count_file) 
    val(library_value) 
    path(library_file)
    val(min_reads)
    val(min_targeted_genes)

    output:
    tuple val(meta), path("*_norm_table.tsv"), emit: norm_count_file
    tuple val(meta), path("*.RData"),          emit: counts_rdata
    path "versions.yml",                       emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"

    """
    #!/usr/bin/env Rscript
    library(CRISPRcleanR)
    library(dplyr)

    print('${library_value}')
    count_file <- read.delim('${count_file}',header=T,sep = "\t")
    count_file <-  count_file[!duplicated(count_file\$sgRNA), ]
    if('${library_file}' == "") {
        data('${library_value}')
        library <- as.data.frame(get('${library_value}'))
        #colnames(library)
        #print(head(count_file))
        #print(head(library))
        count_file_to_normalize <- count_file  %>% dplyr::left_join(library, by=c("sgRNA"="seq"),multiple = "all")
        count_file_to_normalize <- count_file_to_normalize %>% 
            dplyr::select(colnames(count_file),CODE,-sgRNA)

        names(count_file_to_normalize)[names(count_file_to_normalize) == 'Gene'] <- 'gene'
        names(count_file_to_normalize)[names(count_file_to_normalize) == 'CODE'] <- 'sgRNA'
        count_file_to_normalize <- count_file_to_normalize %>% dplyr::select(sgRNA, gene, everything())        
    } else {
        try(library <- read.delim('${library_file}',header=T,sep = ","))
        duplicates <- duplicated(library[, 1])
        unique_rows <- !duplicates
        library <- library[unique_rows, , drop = FALSE]
        rownames(library) = library[,1]
        library = library[order(rownames(library)),]
        library = library[,-1]
        names(count_file)[names(count_file) == 'Gene'] <- 'gene'
        count_file_to_normalize <- count_file %>% dplyr::select(sgRNA, gene, everything())
        }

    normANDfcs <- ccr.NormfoldChanges(Dframe=count_file_to_normalize,saveToFig = FALSE,min_reads=${min_reads},EXPname="${prefix}", libraryAnnotation=library,display=FALSE)
    gwSortedFCs <- ccr.logFCs2chromPos(normANDfcs[["logFCs"]],library)
    correctedFCs <- ccr.GWclean(gwSortedFCs,display=FALSE,label='crisprcleanr')
    correctedCounts <- ccr.correctCounts('crisprcleanr',
                            normANDfcs[["norm_counts"]],
                            correctedFCs,
                            library,
                            minTargetedGenes=${min_targeted_genes},
                            OutDir='./')

    write.table(correctedCounts, file=paste0("crisprcleanr","_norm_table.tsv"),row.names=FALSE,quote=FALSE,sep="\t")
    
    #version
    version_file_path <- "versions.yml"
    version_crisprcleanr <- paste(unlist(packageVersion("CRISPRcleanR")), collapse = ".")
    f <- file(version_file_path, "w")
    writeLines('"${task.process}":', f)
    writeLines("    crisprcleanr: ", f, sep = "")
    writeLines(version_crisprcleanr, f)
    close(f)

    """
}
