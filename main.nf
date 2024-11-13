#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include{ ARTIC_MINION } from "./modules/local/hbv_assembly"
include{ CONCAT_FASTQ_READS } from "./modules/local/concate_fastq_reads"

// Get the parent directory housing the barcodes containing reads
channel
        .fromPath("${params.fastqDir}/barcode*", type: 'dir', checkIfExists: true)
        .set { rawFastqReads_ch }

channel
        .fromPath("${params.scheme_directory}", type: 'dir', checkIfExists: true)
        .set { scheme_directory_ch }
        
workflow {
    // Run ARTIC_GUPPYPLEX
    CONCAT_FASTQ_READS(rawFastqReads_ch)

    // Run ARTIC_MINION
    ARTIC_MINION (
        scheme_directory_ch,
        params.scheme_name,
        params.scheme_version,
        params.normalize,
        params.medaka_model,
        CONCAT_FASTQ_READS.out.fastq_gz
        )
}
