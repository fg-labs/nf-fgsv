nextflow.enable.types = true

/** AGGREGATE_SV_PILEUP_TO_BEDPE
  *
  * Convert aggregated SvPileup output to BEDPE format using
  * fgsv AggregateSvPileupToBedPE.
  *
  * Inputs:
  *   - - meta: map containing sample information (must include 'id')
  *     - txt:  aggregated SvPileup TXT
  * Outputs:
  *   - - meta:  map containing sample information (passthrough)
  *     - bedpe: aggregated BEDPE ('*_svpileup.aggregate.bedpe')
  */
process AGGREGATE_SV_PILEUP_TO_BEDPE {
    container "community.wave.seqera.io/library/fgsv:0.2.1--c84e2a909a90a8c9"

    input:
    record(meta: Map, txt: Path)

    output:
    bedpe = record(
        meta:  meta,
        bedpe: file("*_svpileup.aggregate.bedpe"),
    )

    topic:
    record(meta: meta, path: file("*_svpileup.aggregate.bedpe")) >> 'sample_outputs'

    script:
    def prefix = "${meta.id}"
    """
    fgsv \\
        AggregateSvPileupToBedPE \\
        --input ${txt} \\
        --output ${prefix}_svpileup.aggregate.bedpe
    """
}
