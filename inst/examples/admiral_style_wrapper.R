# Example: admiral-style wrapper with clintrace
# This shows how you can wrap common admiral-style derivations
# while automatically capturing lineage.
#
# Note: This example does not require admiral to be installed.
# It demonstrates the pattern you would use with real admiral calls.

library(clintrace)
library(dplyr)

# Simulated "admiral-like" derivation function
derive_vars_agegr <- function(dataset, age_var = "AGE") {
  dataset %>%
    mutate(
      AGEGR1 = case_when(
        .data[[age_var]] < 65 ~ "<65",
        .data[[age_var]] < 75 ~ "65-74",
        TRUE                  ~ ">=75"
      ),
      AGEGR1N = case_when(
        .data[[age_var]] < 65 ~ 1L,
        .data[[age_var]] < 75 ~ 2L,
        TRUE                  ~ 3L
      )
    )
}

# Wrapper that records lineage
derive_vars_agegr_traced <- function(dataset, trace, age_var = "AGE",
                                     source_dataset = "DM") {
  dataset <- derive_vars_agegr(dataset, age_var)

  trace <- add_lineage(
    trace,
    target_dataset  = "ADSL",
    target_variable = "AGEGR1",
    source_dataset  = source_dataset,
    source_variable = age_var,
    derivation_type = "derived",
    algorithm       = "Age grouped into <65 / 65-74 / >=75",
    keys            = "USUBJID"
  )

  trace <- add_lineage(
    trace,
    target_dataset  = "ADSL",
    target_variable = "AGEGR1N",
    source_dataset  = source_dataset,
    source_variable = age_var,
    derivation_type = "derived",
    algorithm       = "Numeric age group (1=<65, 2=65-74, 3=>=75)",
    keys            = "USUBJID"
  )

  list(data = dataset, trace = trace)
}

# --- Run the example ---
dm <- load_example("dm")
tr <- new_trace(study_id = "ABC-123")

result <- derive_vars_agegr_traced(dm, tr)

adsl <- result$data
tr   <- result$trace

cat("=== ADSL with AGEGR1 / AGEGR1N ===\n")
print(adsl[, c("USUBJID", "AGE", "AGEGR1", "AGEGR1N")])

cat("\n=== Lineage ===\n")
print(query_lineage(tr))

cat("\n=== SRC* suggestions ===\n")
print(src_vars_from_trace(tr))

cat("\n=== Validation ===\n")
print(validate_trace(tr))
