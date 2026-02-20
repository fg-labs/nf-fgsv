nextflow.preview.types = true

/**
 * Aggregate and merge pileups that are likely to support the same breakpoint
 * using fgsv AggregateSvPileup.
 *
 * @param meta        Map containing sample information (must include 'id')
 * @param bam         Input BAM file
 * @param txt         SvPileup breakpoint output file
 * @return aggregated Record of meta and the aggregated SvPileup output file (txt)
 */
process AGGREGATE_SV_PILEUP {
    container "community.wave.seqera.io/library/fgsv:0.2.1--c84e2a909a90a8c9"

    input:
    record(meta: Map, bam: Path, txt: Path)

    output:
    aggregated = record(
        meta: meta,
        txt:  file("*_svpileup.aggregate.txt"),
    )

    topic:
    record(meta: meta, path: file("*_svpileup.aggregate.txt")) >> 'sample_outputs'

    script:
    def prefix = "${meta.id}"
    """
    fgsv \\
        AggregateSvPileup \\
        --bam ${bam} \\
        --input ${txt} \\
        --output ${prefix}_svpileup.aggregate.txt
    """
}
