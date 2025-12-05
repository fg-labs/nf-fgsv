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
nextflow.preview.types = true

process SV_PILEUP {
    container "community.wave.seqera.io/library/fgsv:0.2.1--c84e2a909a90a8c9"

    input:
    (meta, bam): Tuple<?, Path>

    output:
    txt = tuple(meta, file("*_svpileup.txt"))
    bam = tuple(meta, file("*_svpileup.bam"))

    topic:
    tuple(meta, file("*_svpileup.txt")) >> 'sample_outputs'
    tuple(meta, file("*_svpileup.bam")) >> 'sample_outputs'

    script:
    def prefix = "${meta.id}"
    """
    fgsv \\
        SvPileup \\
        --input ${bam} \\
        --output ${prefix}_svpileup
    """
}
