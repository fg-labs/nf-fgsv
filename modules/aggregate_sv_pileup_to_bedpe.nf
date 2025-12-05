/** AGGREGATE_SV_PILEUP_TO_BEDPE
  *
  * Convert aggregated SvPileup output to BEDPE format using fgsv AggregateSvPileupToBedPE.
  *
  * Inputs:
  *   - - meta: map containing sample information (must include 'id')
  *     - txt: aggregated SvPileup output file
  * Outputs:
  *   - - meta: map containing sample information
  *     - bedpe: BEDPE format output file ('*_svpileup.aggregate.bedpe')
  */
nextflow.preview.types = true

process AGGREGATE_SV_PILEUP_TO_BEDPE {
    container "community.wave.seqera.io/library/fgsv:0.2.1--c84e2a909a90a8c9"

    input:
    (meta, txt): Tuple<?, Path>

    output:
    bedpe = tuple(meta, file("*_svpileup.aggregate.bedpe"))

    topic:
    tuple(meta, file("*_svpileup.aggregate.bedpe")) >> 'sample_outputs'

    script:
    def prefix = "${meta.id}"
    """
    fgsv \\
        AggregateSvPileupToBedPE \\
        --input ${txt} \\
        --output ${prefix}_svpileup.aggregate.bedpe
    """
}
