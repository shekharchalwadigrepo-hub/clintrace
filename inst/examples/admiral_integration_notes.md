# admiral Integration Notes

## Pattern

`clintrace` is designed to sit **alongside** admiral rather than replace it.

### Recommended workflow

```r
library(admiral)
library(clintrace)
library(dplyr)

# 1. Start trace
tr <- new_trace(study_id = "ABC-123")

# 2. Use admiral as normal, then record lineage
adsl <- dm %>%
  derive_vars_agegr1()   # example admiral-style call

tr <- add_lineage(
  tr,
  target_dataset = "ADSL",
  target_variable = "AGEGR1",
  source_dataset = "DM",
  source_variable = "AGE",
  algorithm = "admiral age grouping",
  keys = "USUBJID"
)

# Or use the general wrapper
res <- wrap_derive(
  data = dm,
  trace = tr,
  fun = function(df) derive_vars_merged(...) ,  # your admiral call
  target_vars = c("VAR1", "VAR2"),
  source_dataset = "VS",
  source_vars = c(VAR1 = "VSSTRESN", VAR2 = "VSSTRESN"),
  algorithm = "Extreme value derivation"
)

# 3. Attach to final dataset
adsl_final <- attach_trace(res$data, res$trace)

# 4. QC
validate_trace(get_trace(adsl_final))
export_define_metadata(get_trace(adsl_final))
```

## Tips

- Record lineage for **key analysis variables** (population flags, baseline flags,
  primary endpoint parameters, grouping variables). You do not need to trace every
  intermediate column.
- Keep algorithm descriptions clear enough for a reviewer or Define-XML Method.
- Store the `clintrace` object (or the attached dataset) in your QC package.
- Use `src_vars_from_trace()` if you want classic `SRCDOM`/`SRCVAR` columns.
