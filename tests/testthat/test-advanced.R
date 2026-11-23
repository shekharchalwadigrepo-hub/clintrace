test_that("wrap_derive records lineage correctly", {
  dm <- load_example("dm")
  tr <- new_trace("TEST")

  fun <- function(df) {
    df$AGEGR1 <- ifelse(df$AGE < 65, "<65", ">=65")
    df
  }

  res <- wrap_derive(
    data = dm,
    trace = tr,
    fun = fun,
    target_vars = "AGEGR1",
    source_dataset = "DM",
    source_vars = c(AGEGR1 = "AGE"),
    algorithm = "binary age"
  )

  expect_true("AGEGR1" %in% names(res$data))
  q <- query_lineage(res$trace, target_variable = "AGEGR1")
  expect_equal(nrow(q), 1)
  expect_equal(q$source_variable, "AGE")
  expect_equal(q$algorithm, "binary age")
})

test_that("export_define_metadata produces expected columns", {
  tr <- new_trace("TEST")
  tr <- add_lineage(
    tr, "ADSL", "AGEGR1", "DM", "AGE",
    derivation_type = "derived",
    algorithm = "Age banding"
  )

  meta <- export_define_metadata(tr)
  expect_true(all(c("Dataset", "Variable", "Origin", "Method", "Comment") %in% names(meta)))
  expect_equal(nrow(meta), 1)
  expect_match(meta$Origin, "DM.AGE")
  expect_equal(meta$Method, "Age banding")
})

test_that("attach_trace and get_trace round-trip", {
  tr <- new_trace("TEST")
  tr <- add_lineage(tr, "ADSL", "AGE", "DM", "AGE", derivation_type = "direct")
  df <- data.frame(USUBJID = "001", AGE = 50)

  df2 <- attach_trace(df, tr)
  retrieved <- get_trace(df2)

  expect_s3_class(retrieved, "clintrace")
  expect_equal(nrow(retrieved$records), 1)
})

test_that("validate_trace detects missing algorithm", {
  tr <- new_trace("TEST")
  tr <- add_lineage(
    tr, "ADSL", "AGEGR1", "DM", "AGE",
    derivation_type = "derived",
    algorithm = ""
  )

  val <- validate_trace(tr)
  expect_false(val$valid)
  expect_gt(val$n_issues, 0)
})

test_that("add_lineage_batch works", {
  df <- data.frame(
    target_dataset = c("ADSL", "ADSL"),
    target_variable = c("A", "B"),
    source_dataset = c("DM", "DM"),
    source_variable = c("X", "Y"),
    algorithm = c("alg1", "alg2"),
    stringsAsFactors = FALSE
  )
  tr <- add_lineage_batch(new_trace("T"), df)
  expect_equal(nrow(tr$records), 2)
})
