/*
    * EXAMPLE
    *
    * Copy input file to a new file with the suffix '_out.txt'.
    *
    * input:
    *   - - meta: map containing sample information (must include 'id')
    *     - infile: the input file to be processed
    *
    * output:
    *   - - meta: map containing sample information
    *     - txt: output file ('*_out.txt'), also emitted to the 'sample_outputs' topic
    */
process EXAMPLE {
    container "debian:bookworm-slim"
    input:
        tuple val(meta), path(infile)
    
    output:
        tuple val(meta), path("*_out.txt"), emit: txt, topic: 'sample_outputs'

    script:
    def prefix = "${meta.id}"
    """
    echo "processing data for ${meta.id}"
    echo ${infile} > ${prefix}_out.txt
    """
}
