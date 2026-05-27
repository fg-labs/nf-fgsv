nextflow.enable.types = true

/** AGGREGATE_SV_PILEUP
  *
  * Aggregate and merge pileups that are likely to support the same breakpoint
  * using fgsv AggregateSvPileup.
  *
  * Inputs:
  *   - - meta: map containing sample information (must include 'id')
  *     - bam:  SvPileup supporting BAM
  *     - txt:  SvPileup breakpoint TXT
  * Outputs:
  *   - - meta: map containing sample information (passthrough)
  *     - txt:  aggregated SvPileup TXT ('*_svpileup.aggregate.txt')
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
