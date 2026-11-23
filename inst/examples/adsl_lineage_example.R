# Example: Full ADSL lineage workflow with clintrace
# This script demonstrates recording lineage while building a simple ADSL.

library(clintrace)
library(dplyr)

# Load example source data
dm <- read.csv(system.file("extdata", "dm.csv", package = "clintrace"))
ex <- read.csv(system.file("extdata", "ex.csv", package = "clintrace"))

# Start trace
tr <- new_trace(study_id = "ABC-123")

# --- Derive ADSL variables and record lineage ---

# AGEGR1 from DM.AGE
adsl <- dm %>%
  mutate(
    AGEGR1 = case_when(
      AGE < 65 ~ "<65",
      AGE < 75 ~ "65-74",
      TRUE     ~ ">=75"
    )
  )

tr <- add_lineage(
  tr,
  target_dataset = "ADSL",
  target_variable = "AGEGR1",
  source_dataset = "DM",
  source_variable = "AGE",
  derivation_type = "derived",
  algorithm = "case_when: <65, 65-74, >=75",
  keys = "USUBJID"
)

# SAFFL from EX (any exposure)
exposed <- unique(ex$USUBJID)
adsl <- adsl %>%
  mutate(SAFFL = ifelse(USUBJID %in% exposed, "Y", "N"))

tr <- add_lineage(
  tr,
  target_dataset = "ADSL",
  target_variable = "SAFFL",
  source_dataset = "EX",
  source_variable = "EXSTDTC",
  derivation_type = "flag",
  algorithm = "Y if subject has at least one EX record",
  keys = "USUBJID"
)

# SEXN from DM.SEX
adsl <- adsl %>%
  mutate(SEXN = ifelse(SEX == "M", 1L, 2L))

tr <- add_lineage(
  tr,
  target_dataset = "ADSL",
  target_variable = "SEXN",
  source_dataset = "DM",
  source_variable = "SEX",
  derivation_type = "derived",
  algorithm = "1=Male, 2=Female",
  keys = "USUBJID"
)

# Direct copy of AGE
adsl$AGE <- dm$AGE
tr <- add_lineage(
  tr,
  target_dataset = "ADSL",
  target_variable = "AGE",
  source_dataset = "DM",
  source_variable = "AGE",
  derivation_type = "direct",
  algorithm = "Direct copy from DM.AGE",
  keys = "USUBJID"
)

# --- Inspect results ---
cat("\n=== ADSL preview ===\n")
print(adsl)

cat("\n=== Trace summary ===\n")
trace_summary(tr)

cat("\n=== Lineage for AGEGR1 ===\n")
print(query_lineage(tr, target_variable = "AGEGR1"))

cat("\n=== Suggested SRC* variables ===\n")
print(suggest_src_vars(tr, "AGEGR1"))

# Save trace object for later use
# saveRDS(tr, "adsl_trace.rds")
