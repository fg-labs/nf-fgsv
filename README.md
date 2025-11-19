# nf-fgsv

[![Workflow CI](https://github.com/fulcrumgenomics/nf-fgsv/actions/workflows/nextflow_checks.yml/badge.svg?branch=main)](https://github.com/fulcrumgenomics/nf-fgsv/actions/workflows/nextflow_checks.yml?query=branch%3Amain)  [![Nextflow Version](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A525.10.0-23aa62.svg)](https://www.nextflow.io/)  [![Pixi](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/prefix-dev/pixi/main/assets/badge/v0.json&style=flat-square)](https://pixi.sh/)

Nextflow workflow for running fgsv.

## Set up Environment

Make sure [Pixi](https://pixi.sh/latest/#installation) and [Docker](https://docs.docker.com/engine/install/) are installed.

The environment for this analysis is in [pixi.toml](pixi.toml) and is named `nf-fgsv`.

To install:

```console
pixi install
```



## Run the Workflow

To save on typing, a pixi task is available which aliases `nextflow run main.nf`.

```console
pixi run \
    nf-workflow \
        -profile "local,docker" \
        --input tests/data/basic_input.tsv
```

## Available Execution Profiles

Several default profiles are available:

* `local` limits the resources used by the workflow to (hopefully) reasonable levels
* `docker` specifies docker containers should be used for process execution
* `linux` adds `--user root` to docker `runOptions`

## Inputs

A full description of input parameters is available using the workflow `--help` parameter, `pixi run nf-workflow --help`.

> [!WARNING]
> **After creating a new project, describe workflow input file format here. **
>
> Add pipeline parameters to the [nextflow config](nextflow.config) with appropriate defaults if needed, or `null` if the parameter is required, and update the [parameter schema](nextflow_schema.json).
> Expand the [input schema](schemas/input_schema.json) to include additional required (and optional) fields.

The required columns in the `--input` samplesheet are:

| Field | Type | Description |
|-------|------|-------------|
| `sample` | String, no whitespace | Sample identifier |
| `data` | Absolute path | Path to the data file for this sample (may be an AWS S3 path) |

### Parameter files

If using more than a few parameters, consider saving them in a YAML format file (e.g. [tests/integration/params.yml](tests/integration/params.yml)).

```console
pixi run \
    nf-workflow \
        -profile "local,docker" \
        -params-file my_params.yml
```

## Outputs

The output directory can be specified using the `-output-dir` Nextflow parameter.
The default output directory is `results/`.
`-output-dir` cannot be specified in a `params.yml` file, because it is a Nextflow parameter rather than a workflow parameter.
It must be specified on the command line or in a `nextflow.config` file.

```console
pixi run \
    nf-workflow \
        -profile "local,docker" \
        --input tests/data/basic_input.tsv \
        -output-dir results
```

> [!WARNING]
> **After creating a new project, describe workflow outputs here.**
>
> Consider using a `tree` output style format to describe the expected output file structure, URLs to third party file format descriptions, and tables as in [Inputs](#inputs) for custom output file formats.

<details>
<summary>Click to toggle output directory structure</summary>


```console
results
└── {sample_name}
    └── {sample_name}_out.txt    # sample output data
```

</details>

## Contributing

See our [Contributing Guide](docs/CONTRIBUTING.md) for development and testing guidelines.


