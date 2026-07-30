#!/usr/bin/env nextflow
nextflow.enable.types = true

include {
    validateParameters;
    paramsHelp;
    paramsSummaryLog;
    samplesheetToList;
} from 'plugin/nf-schema'

include { AGGREGATE_SV_PILEUP } from './modules/aggregate_sv_pileup.nf'
include { AGGREGATE_SV_PILEUP_TO_BEDPE } from './modules/aggregate_sv_pileup_to_bedpe.nf'
include { COORDINATE_SORT } from './modules/coordinate_sort.nf'
include { SV_PILEUP } from './modules/sv_pileup.nf'

params {
    // Path to tab-separated file containing information about the samples in the experiment.
    input: String
    // `--help` takes either a boolean flag or a parameter name to describe.
    help: Object = false
    helpFull: Boolean = false
    showHidden: Boolean = false
}

/**
 * Detect structural-variant breakpoints from aligned reads using fgsv.
 *
 * The `--input` sample sheet provides one `sample` identifier and `bam` path per
 * row (see the `--input` parameter for the full column specification). Every
 * per-sample output — the sorted BAM, SvPileup BAM and text, aggregated
 * breakpoints, and BEDPE — is published via the `sample_outputs` topic into a
 * directory named after the sample's `meta.id`. For each sample the workflow runs:
 *
 * 1. `COORDINATE_SORT` — coordinate-sort the input BAM with samtools.
 * 2. `SV_PILEUP` — gather read-level evidence for structural variants (fgsv SvPileup).
 * 3. `AGGREGATE_SV_PILEUP` — merge pileups that likely support the same breakpoint.
 * 4. `AGGREGATE_SV_PILEUP_TO_BEDPE` — convert the aggregated breakpoints to BEDPE.
 */
workflow {
    main:
    if( params.help || params.helpFull ) {
        help_options = [
            showHidden: params.showHidden as Boolean,
            fullHelp: params.helpFull as Boolean,
        ]
        log.info paramsHelp(
            help_options,
            (params.help instanceof String && params.help != 'true') ? params.help : '',
        )
        exit 0
    }

    validateParameters()
    log.info paramsSummaryLog(workflow)

    ch_samples = channel
        .fromList(samplesheetToList(params.input, "schemas/input_schema.json"))
        .map { meta, bam -> record(meta: meta, bam: bam) }

    COORDINATE_SORT(ch_samples)
    SV_PILEUP(COORDINATE_SORT.out)
    AGGREGATE_SV_PILEUP(SV_PILEUP.out)
    AGGREGATE_SV_PILEUP_TO_BEDPE(AGGREGATE_SV_PILEUP.out)

    publish:
    sample_outputs = channel.topic('sample_outputs')
}

output {
    sample_outputs {
        path { s -> "${s.meta.id}/" }
        mode 'link'
    }
}
