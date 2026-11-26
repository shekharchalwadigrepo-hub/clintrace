# clintrace

Industry-oriented traceability and lineage tracking for clinical trial data
(SDTM → ADaM → TLF).

`clintrace` helps clinical programmers record, validate, query, and report
data lineage so that every analysis value can be traced back to its source.
It is designed to work alongside pharmaverse packages such as `admiral`.

## Installation

```r
# From CRAN (once accepted)
# install.packages("clintrace")

# Development version from GitHub
# remotes::install_github("shekharchalwadigrepo-hub/clintrace")
```

## Key features

- Record variable-level and record-level lineage
- One-step derivation + lineage capture (`derive_with_trace`)
- Wrap existing functions and capture lineage automatically (`wrap_derive`)
- Validation of trace completeness (`validate_trace`)
- Classic ADaM SRC* variable generation (`src_vars_from_trace`)
- Define-XML friendly metadata export (`export_define_metadata`)
- HTML reports suitable for QC or ADRG appendices (`trace_report`)
- Attach lineage metadata directly to datasets

## Quick example

```r
library(clintrace)

tr <- new_trace("ABC-123")
dm <- load_example("dm")

# Derive and record in one step
res <- derive_with_trace(
  data = dm,
  trace = tr,
  target_variable = "AGEGR1",
  expr = ifelse(AGE < 65, "<65", ">=65"),
  source_dataset = "DM",
  source_variable = "AGE",
  algorithm = "Binary age grouping"
)

adsl <- attach_trace(res$data, res$trace)

# Later retrieve and inspect
get_trace(adsl)
validate_trace(res$trace)
src_vars_from_trace(res$trace)
```

## Wrapping existing functions

```r
agegr_fun <- function(df) {
  df$AGEGR1 <- ifelse(df$AGE < 65, "<65", ">=65")
  df
}

res <- wrap_derive(
  data = dm,
  trace = new_trace("ABC-123"),
  fun = agegr_fun,
  target_vars = "AGEGR1",
  source_dataset = "DM",
  source_vars = c(AGEGR1 = "AGE"),
  algorithm = "Binary age grouping per SAP"
)

# Export metadata for Define-XML / ADRG
export_define_metadata(res$trace)
```

## HTML report

```r
trace_report(
  res$trace,
  file = "lineage_report.html",
  study_info = list(Protocol = "ABC-123", Phase = "3")
)
```

## More examples

- Getting started vignette: `vignette("getting-started", package = "clintrace")`
- Industry workflow vignette: `vignette("industry-workflow", package = "clintrace")`
- Example scripts: `system.file("examples", package = "clintrace")`

## Author

Shekhar Eranna Chalwadi  
Email: skrchalwadi@gmail.com
