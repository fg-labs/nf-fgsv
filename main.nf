include {
    validateParameters;
    paramsHelp;
    paramsSummaryLog;
    samplesheetToList;
} from 'plugin/nf-schema'

include { EXAMPLE } from './modules/example.nf'

workflow {
    main:
    // Validate input parameters
    validateParameters()

    // Print summary of supplied parameters
    log.info paramsSummaryLog(workflow)

    channel.fromList(samplesheetToList(params.input, "schemas/input_schema.json"))
        | EXAMPLE

    publish:
    sample_outputs = Channel.topic('sample_outputs')
}

output {
    sample_outputs {
        path {meta, _file -> "${meta.id}/"}
        mode 'link'
    }
}
