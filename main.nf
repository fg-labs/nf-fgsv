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
}

workflow {
    main:
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
