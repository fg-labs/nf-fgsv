# nf-fgsv

[![Workflow CI](https://github.com/fg-labs/nf-fgsv/actions/workflows/nextflow_checks.yml/badge.svg?branch=main)](https://github.com/fg-labs/nf-fgsv/actions/workflows/nextflow_checks.yml?query=branch%3Amain)  [![Nextflow Version](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A526.04.0-23aa62.svg)](https://www.nextflow.io/)  [![Pixi](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/prefix-dev/pixi/main/assets/badge/v0.json&style=flat-square)](https://pixi.sh/)

> [!NOTE]  
> This repository is primarily for testing the latest Nextflow features and the workflow is relatively simple.

This is a Nextflow workflow for running [fgsv](https://github.com/fulcrumgenomics/fgsv) on a BAM file to gather evidence for structural variation via breakpoint detection.

<p>
<a href="https://fulcrumgenomics.com">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset=".github/logos/fulcrumgenomics-dark.svg">
  <source media="(prefers-color-scheme: light)" srcset=".github/logos/fulcrumgenomics-light.svg">
  <img alt="Fulcrum Genomics" src=".github/logos/fulcrumgenomics-light.svg" height="100">
</picture>
</a>
</p>

[Visit us at Fulcrum Genomics](https://www.fulcrumgenomics.com) to learn more about how we can power your Bioinformatics with nf-fgsv and beyond.

<a href="mailto:contact@fulcrumgenomics.com?subject=[GitHub inquiry]"><img src="https://img.shields.io/badge/Email_us-%2338b44a.svg?&style=for-the-badge&logo=gmail&logoColor=white"/></a>
<a href="https://www.fulcrumgenomics.com"><img src="https://img.shields.io/badge/Visit_Us-%2326a8e0.svg?&style=for-the-badge&logo=wordpress&logoColor=white"/></a>

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

The required columns in the `--input` samplesheet are:

| Field | Type | Description |
|-------|------|-------------|
| `sample` | String, no whitespace | Sample identifier |
| `bam` | Absolute path | Path to the BAM file for this sample (may be an AWS S3 path) |

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

<details>
<summary>Click to toggle output directory structure</summary>


```console
results
└── {sample_name}
    ├── {sample_name}_sorted.bam                # Coordinate-sorted BAM file
    ├── {sample_name}_svpileup.txt              # SvPileup breakpoint candidates
    ├── {sample_name}_svpileup.bam              # BAM with SV tags from SvPileup
    ├── {sample_name}_svpileup.aggregate.txt    # Aggregated/merged breakpoint pileups
    └── {sample_name}_svpileup.aggregate.bedpe  # Aggregated pileups in BEDPE format
```

</details>

### Output File Descriptions

| File | Description |
|------|-------------|
| `*_sorted.bam` | Input BAM sorted by genomic coordinates using samtools sort |
| `*_svpileup.txt` | Candidate structural variant breakpoints identified by [fgsv SvPileup](https://github.com/fulcrumgenomics/fgsv) |
| `*_svpileup.bam` | BAM file with SV-related tags added by SvPileup |
| `*_svpileup.aggregate.txt` | Merged breakpoint pileups from [fgsv AggregateSvPileup](https://github.com/fulcrumgenomics/fgsv) |
| `*_svpileup.aggregate.bedpe` | Aggregated pileups converted to [BEDPE format](https://bedtools.readthedocs.io/en/latest/content/general-usage.html#bedpe-format) |

## Contributing

See our [Contributing Guide](docs/CONTRIBUTING.md) for development and testing guidelines.


