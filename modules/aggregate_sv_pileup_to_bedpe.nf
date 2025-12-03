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
process AGGREGATE_SV_PILEUP_TO_BEDPE {
    container "community.wave.seqera.io/library/fgsv:0.2.1--c84e2a909a90a8c9"

    input:
        tuple val(meta), path(txt)

    output:
        tuple val(meta), path("*_svpileup.aggregate.bedpe"), emit: bedpe, topic: 'sample_outputs'

    script:
    def prefix = "${meta.id}"
    """
    fgsv \\
        AggregateSvPileupToBedPE \\
        --input ${txt} \\
        --output ${prefix}_svpileup.aggregate.bedpe
    """
}
