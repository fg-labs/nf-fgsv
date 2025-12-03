/** SV_PILEUP
  *
  * Detect structural variant evidence from a BAM file using fgsv SvPileup.
  *
  * Inputs:
  *   - - meta: map containing sample information (must include 'id')
  *     - bam: BAM file
  * Outputs:
  *   - - meta: map containing sample information
  *     - txt: SvPileup breakpoint output file ('*_svpileup.txt')
  */
process SV_PILEUP {
    container "community.wave.seqera.io/library/fgsv:0.2.1--c84e2a909a90a8c9"

    input:
        tuple val(meta), path(bam)

    output:
        tuple val(meta), path("*_svpileup.txt"), emit: txt, topic: 'sample_outputs'
        tuple val(meta), path("*_svpileup.bam"), emit: bam, topic: 'sample_outputs'

    script:
    def prefix = "${meta.id}"
    """
    fgsv \\
        SvPileup \\
        --input ${bam} \\
        --output ${prefix}_svpileup
    """
}
