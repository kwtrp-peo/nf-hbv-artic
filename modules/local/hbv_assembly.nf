
process ARTIC_MINOIN {
    publishDir "${params.outDir}", pattern: '*.consensus.fasta', mode:'copy'
    tag "assembling $barcordeName"

    input:
    path scheme_dir
    val scheme_name_str
    val scheme_version_str
    val normalise_int
    val medaka_model_str
    each path(rawReadsFastq)
     
    output:
    path "${sample_name}.consensus.fasta"     , emit: fasta

    script:
    barcordeName = rawReadsFastq.simpleName

    """
    artic minion \\
	    --circular \\
	    --medaka \\
	    --normalise $normalise_int \\
	    --threads $task.cpus \\
	    --scheme-directory $scheme_dir \\
	    --read-file $rawReadsFastq  \\
	    --medaka-model $medaka_model_str \\
	    --scheme-name $scheme_name_str \\
        --scheme-version $scheme_version_str \\
        $barcordeName
    """
}
