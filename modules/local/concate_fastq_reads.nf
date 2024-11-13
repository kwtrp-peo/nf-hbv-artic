process CONCAT_FASTQ_READS {
    tag "concatenate $barcodeName"

    input:
    path barcode_dir
    
    output:
    path "*.fastq.gz"     , emit: fastq_gz

    script:
    barcodeName = barcode_dir.simpleName
    """
    zcat ${barcode_dir}/*.fastq.gz | pigz -p $task.cpus > ${barcodeName}.fastq.gz
    """
}
