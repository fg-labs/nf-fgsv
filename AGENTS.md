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
  * Ouptputs:
  *   - output1: description
  */
```

Nextflow files can be lint with `pixi run nextflow lint /path/to/file`
