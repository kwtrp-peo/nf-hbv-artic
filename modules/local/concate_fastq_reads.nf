process CONCAT_FASTQ_READS {
    input:
    path barcode_dir
    
    output:
    tuple val(meta), path("*.fastq.gz"), emit: fastq_gz

    script:
    barcodeName = barcode_dir.simpleName
    """
    zcat ${barcode_dir}/*.fastq.gz > barcodeName.fastq

    pigz -p $task.cpus barcodeName.fastq
    """
}