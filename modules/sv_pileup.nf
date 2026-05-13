nextflow.enable.types = true

/** SV_PILEUP
  *
  * Detect structural variant evidence from a BAM file using fgsv SvPileup.
  *
  * Inputs:
  *   - - meta: map containing sample information (must include 'id')
  *     - bam:  coordinate-sorted BAM file
  * Outputs:
  *   - - meta: map containing sample information (passthrough)
  *     - bam:  SvPileup supporting BAM ('*_svpileup.bam')
  *     - txt:  SvPileup breakpoint TXT ('*_svpileup.txt')
  *
  * Combining the BAM and TXT in one record lets AGGREGATE_SV_PILEUP consume a
  * single channel without an explicit .join().
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
