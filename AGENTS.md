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

Input and output tuples should be formatted in doc strings as
```
/** MODULE_NAME
  *
  * One sentence description.
  *
  * Inputs:
  *   - - input_tuple_element_0: description
  *     - input_tuple_element_1: description
  * Outputs:
  *   - - output_tuple_element_0: description
  *     - output_tuple_element_1: description
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
