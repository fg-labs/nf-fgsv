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

workflow {
    main:
    // Validate input parameters
    validateParameters()

    // Print summary of supplied parameters
    log.info paramsSummaryLog(workflow)

    ch_input_bams = channel.fromList(samplesheetToList(params.input, "schemas/input_schema.json"))

    COORDINATE_SORT(ch_input_bams)

    SV_PILEUP(COORDINATE_SORT.out.bam)

    ch_aggregate_input = SV_PILEUP.out.bam
        .join(SV_PILEUP.out.txt)

    AGGREGATE_SV_PILEUP(ch_aggregate_input)

    AGGREGATE_SV_PILEUP_TO_BEDPE(AGGREGATE_SV_PILEUP.out.txt)

    publish:
    sample_outputs = channel.topic('sample_outputs')
}

output {
    sample_outputs {
        path {meta, _file -> "${meta.id}/"}
        mode 'link'
    }
}
