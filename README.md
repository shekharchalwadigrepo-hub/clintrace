# clintrace

Industry-oriented traceability and lineage tracking for clinical trial data
(SDTM → ADaM → TLF).

Designed to sit alongside pharmaverse packages (`admiral`, `sdtm.oak`, `metacore`, etc.)
and help satisfy regulatory expectations for data-point and metadata traceability.

## Installation

```r
# From the source tarball
install.packages("clintrace_0.1.0.tar.gz", repos = NULL, type = "source")

# Or after you push to GitHub
# remotes::install_github("shekharchalwadigrepo-hub/clintrace")
```

## Key features

- Record variable-level and record-level lineage
- One-step derivation + lineage capture (`derive_with_trace`)
- Validation of trace completeness (`validate_trace`)
- Classic ADaM SRC* variable generation (`src_vars_from_trace`)
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

adsl <- res$data
tr   <- res$trace

# Attach lineage to the dataset itself
adsl <- attach_trace(adsl, tr)

# Later retrieve it
get_trace(adsl)

# Validate and report
validate_trace(tr)
src_vars_from_trace(tr)
# trace_report(tr, file = "lineage_report.html")
```

## CRAN readiness

1. Update author/email in `DESCRIPTION`.
2. `R CMD check --as-cran`
3. Submit via https://cran.r-project.org/submit.html

## New in 0.3.0

- `wrap_derive()` — wrap any admiral or custom function and capture lineage automatically
- `export_define_metadata()` / `write_define_metadata()` — Define-XML friendly Origin/Method/Comment export
- Stronger validation rules

```r
# Wrap a custom or admiral-style function
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

# Export metadata for Define-XML
export_define_metadata(res$trace)
# write_define_metadata(res$trace, "define_methods.csv")
```

- **admiral-style wrapper example**: `inst/examples/admiral_style_wrapper.R`
- **Polished HTML report**: `trace_report()` (summary cards + validation status)
- **CI**: GitHub Actions workflow included for `R CMD check` on Linux/Windows/macOS

```r
# Generate a polished report
trace_report(tr, file = "lineage_report.html",
             study_info = list(Protocol = "ABC-123", Phase = "3"))
```
