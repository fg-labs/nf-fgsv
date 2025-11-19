

## Running Integration tests

You can run the integration tests using Pixi tasks:

- On macOS:
  ```console
  pixi run wf-test
  ```

## Adding a process to the workflow

### Create a Module

Add your process in [modules/](../modules/), and reference it in the workflow.
Make sure you add a doc string to your process providing a brief overview of the process, inputs, and outputs.

To publish sample-specific output files, emit them to the `sample_outputs` topic channel as a tuple where the first element is a `meta` map containing at least an `id` field and the second element is a file path (or list of file paths).

```nextflow
output:
    tuple val(meta), path("*_out.txt"), emit: txt, topic: 'sample_outputs'
```

### Define a Container

Each process should use the [`container`](https://www.nextflow.io/docs/latest/reference/process.html#container) directive to specify a docker container for execution to support the `docker` profile.
For individual open source tools [quay.io](https://quay.io/search), [BioContainers](https://biocontainers.pro/registry), [Seqera Containers](https://seqera.io/containers/), and [DockerHub](https://hub.docker.com/) all provide open source version controlled docker images.

To create a multi-tool docker image when each tool is available through conda:

1. (Optional, but recommended) test building from an `envirionment.yaml` locally first to make sure the packages and their versions are indeed complementary
1. Go to https://seqera.io/containers/
1. Add all the packages in the search bar (you can copy paste e.g. `conda-forge::<tool>=<version` from your conda env file, to make sure you have exactly the right channels/versions)
1. Make sure container setting is on `Docker`
1. Press 'Get Container'
1. Copy the 'Container image name' and use it with the `container` directive

### Update Workflow Parameters

If your process needs any parameters, define them in [nextflow.config](nextflow.config) and add metadata to [nextflow_schema.json](nextflow_schema.json).
See the [Nextflow Schema documentation](https://github.com/nextflow-io/nf-validation/blob/master/docs/nextflow_schema/nextflow_schema_specification.md) for details.
For inputs that require validation (such as the sample sheet), add a [schema definition](https://github.com/nextflow-io/nf-validation/blob/master/docs/samplesheets/validate_sample_sheet.md) in the [schema](schema/) folder.

### Update Integration Tests

Integration tests are defined in YAML files in the [tests](tests/) folder.
See the [pytest-workflow docs](https://pytest-workflow.readthedocs.io/en/stable/) for details on how to write tests.
