test_that("new_trace creates valid object", {
  tr <- new_trace("TEST-001")
  expect_s3_class(tr, "clintrace")
  expect_equal(tr$study_id, "TEST-001")
  expect_equal(nrow(tr$records), 0)
})

test_that("add_lineage and query work", {
  tr <- new_trace("TEST-001")
  tr <- add_lineage(
    tr,
    target_dataset = "ADSL",
    target_variable = "AGEGR1",
    source_dataset = "DM",
    source_variable = "AGE",
    derivation_type = "derived",
    algorithm = "banding"
  )

  expect_equal(nrow(tr$records), 1)

  res <- query_lineage(tr, target_variable = "AGEGR1")
  expect_equal(nrow(res), 1)
  expect_equal(res$source_variable, "AGE")
})

test_that("load_example works", {
  dm <- load_example("dm")
  expect_s3_class(dm, "data.frame")
  expect_true("USUBJID" %in% names(dm))
  expect_true("AGE" %in% names(dm))
  expect_gt(nrow(dm), 0)
})

test_that("suggest_src_vars returns list", {
  tr <- new_trace("TEST-001")
  tr <- add_lineage(tr, "ADSL", "AGEGR1", "DM", "AGE")
  src <- suggest_src_vars(tr, "AGEGR1")
  expect_type(src, "list")
  expect_equal(src$SRCDOM, "DM")
})
