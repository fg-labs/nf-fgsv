/** AGGREGATE_SV_PILEUP
  *
  * Aggregate and merge pileups that are likely to support the same breakpoint using fgsv AggregateSvPileup.
  *
  * Inputs:
  *   - - meta: map containing sample information (must include 'id')
  *     - bam: BAM file
  *     - txt: SvPileup breakpoint output file
  * Outputs:
  *   - - meta: map containing sample information
  *     - txt: aggregated SvPileup output file ('*_svpileup.aggregate.txt')
  */
nextflow.preview.types = true

process AGGREGATE_SV_PILEUP {
    container "community.wave.seqera.io/library/fgsv:0.2.1--c84e2a909a90a8c9"

    input:
    (meta, bam, txt): Tuple<?, Path, Path>

    output:
    txt = tuple(meta, file("*_svpileup.aggregate.txt"))

    topic:
    tuple(meta, file("*_svpileup.aggregate.txt")) >> 'sample_outputs'

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
