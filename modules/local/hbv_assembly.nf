
process ARTIC_MINION {
    publishDir path: { "${params.outDir}/assembly" }, mode:'copy', pattern: '*/*'
    tag "assembling $barcordeName"
    errorStrategy 'ignore'

    input:
    path scheme_dir
    val scheme_name_str
    val scheme_version_str
    val normalise_int
    val medaka_model_str
    each path(rawReadsFastq)
     
    output:
    path "${barcordeName}_output/*"     , emit: fasta

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
            --output ${barcordeName}_output \\
	    $barcordeName
    """
}
