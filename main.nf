include {
    validateParameters;
    paramsHelp;
    paramsSummaryLog;
    samplesheetToList;
} from 'plugin/nf-schema'

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

    publish:
    sample_outputs = Channel.topic('sample_outputs')
}

output {
    sample_outputs {
        path {meta, _file -> "${meta.id}/"}
        mode 'link'
    }
}
