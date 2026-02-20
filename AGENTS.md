Key tools:
- Nextflow: https://www.nextflow.io/docs/latest/index.html
- fgsv: https://github.com/fulcrumgenomics/fgsv
- pixi: https://pixi.sh/latest/

Read @docs/CONTRIBUTING.md

Run workflow tests from the project root directory with `pixi run wf-test` (defined in pixi.toml).

Nextflow processes should have doc strings like:

```
/**
 * Align reads to a reference genome using BWA MEM.
 *
 * Handles both single-end and paired-end reads automatically.
 *
 * @param reads  Tuple of sample ID and FASTQ files
 * @param index  BWA index files
 * @return       Tuple of sample ID and aligned BAM file
 */
```

Nextflow files can be lint with `pixi run nextflow lint /path/to/file`

Bash code in script blocks should be formatted to have one parameter/flag per line. As in:

```
"""
samtools \\
    sort \\
    -@ ${task.cpus} \\
    -o ${prefix}_sorted.bam \\
    ${bam}
"""
```
