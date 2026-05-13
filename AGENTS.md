Key tools:
- Nextflow: https://www.nextflow.io/docs/latest/index.html
- fgsv: https://github.com/fulcrumgenomics/fgsv
- pixi: https://pixi.sh/latest/

Read @docs/CONTRIBUTING.md

Run workflow tests from the project root directory with `pixi run wf-test` (defined in pixi.toml).

Nextflow processes should have doc strings like:

```
/** MODULE_NAME
  *
  * One sentence description.
  *
  * Inputs:
  *   - input1: description
  * Outputs:
  *   - output1: description
  */
```

When a process input or output is an anonymous record (the preferred form
for I/O carrying both meta and one or more files), list each record field
as a nested bullet so the field structure is visible at a glance:

```
/** MODULE_NAME
  *
  * One sentence description.
  *
  * Inputs:
  *   - - meta: map containing sample information (must include 'id')
  *     - bam:  description of the BAM input
  * Outputs:
  *   - - meta: map containing sample information (passthrough)
  *     - txt:  description of the TXT output
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
