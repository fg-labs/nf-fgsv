nextflow.enable.types = true

/** COORDINATE_SORT
  *
  * Sort a BAM file by genomic coordinates using samtools sort.
  *
  * Inputs:
  *   - - meta: map containing sample information (must include 'id')
  *     - bam:  the input BAM file to be sorted
  * Outputs:
  *   - - meta: map containing sample information (passthrough)
  *     - bam:  coordinate-sorted BAM file ('*_sorted.bam')
  */
process COORDINATE_SORT {
    container "quay.io/biocontainers/samtools:1.21--h50ea8bc_0"

    input:
    record(meta: Map, bam: Path)

    output:
    sorted = record(meta: meta, bam: file("*_sorted.bam"))

    topic:
    record(meta: meta, path: file("*_sorted.bam")) >> 'sample_outputs'

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
