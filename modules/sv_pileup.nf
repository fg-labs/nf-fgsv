nextflow.enable.types = true

/**
 * Detect structural variant evidence from a BAM file using fgsv SvPileup.
 *
 * @param meta    Map containing sample information (must include 'id')
 * @param bam     Input BAM file
 * @return result Record of meta, the SvPileup BAM file (bam), and the breakpoint output file (txt)
 */
process SV_PILEUP {
    container "community.wave.seqera.io/library/fgsv:0.2.1--c84e2a909a90a8c9"

    input:
    record(meta: Map, bam: Path)

    output:
    result = record(
        meta: meta,
        bam:  file("*_svpileup.bam"),
        txt:  file("*_svpileup.txt"),
    )

    topic:
    record(meta: meta, path: file("*_svpileup.txt")) >> 'sample_outputs'
    record(meta: meta, path: file("*_svpileup.bam")) >> 'sample_outputs'

    script:
    def prefix = "${meta.id}"
    """
    fgsv \\
        SvPileup \\
        --input ${bam} \\
        --output ${prefix}_svpileup
    """
}
