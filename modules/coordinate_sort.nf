nextflow.enable.types = true

/**
 * Sort a BAM file by genomic coordinates using samtools sort.
 *
 * @param meta    Map containing sample information (must include 'id')
 * @param bam     Input BAM file to be sorted
 * @return sorted Record of meta and the coordinate-sorted BAM file (bam)
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
