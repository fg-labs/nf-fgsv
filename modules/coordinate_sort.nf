/** COORDINATE_SORT
  *
  * Sort a BAM file by genomic coordinates using samtools sort.
  *
  * Inputs:
  *   - - meta: map containing sample information (must include 'id')
  *     - bam: the input BAM file to be sorted
  * Outputs:
  *   - - meta: map containing sample information
  *     - bam: coordinate-sorted BAM file ('*_sorted.bam')
  */
nextflow.preview.types = true

process COORDINATE_SORT {
    container "quay.io/biocontainers/samtools:1.21--h50ea8bc_0"

    input:
    (meta, bam): Tuple<?, Path>

    output:
    bam = tuple(meta, file("*_sorted.bam"))

    topic:
    tuple(meta, file("*_sorted.bam")) >> 'sample_outputs'

    script:
    def prefix = "${meta.id}"
    """
    samtools \\
        sort \\
        -@ ${task.cpus} \\
        -o ${prefix}_sorted.bam \\
        ${bam}
    """
}
