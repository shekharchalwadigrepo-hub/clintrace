#' Validate a clintrace object
#'
#' Checks for common issues: missing source information, duplicate steps,
#' empty algorithms on derived variables, inconsistent keys, etc.
#'
#' @param trace A clintrace object.
#' @param strict Logical. If TRUE, raises an error when issues are found.
#' @param require_algorithm Logical. Whether empty algorithms on derived/flag
#'   variables should be flagged.
#'
#' @return A list with components \code{valid} (logical), \code{issues} (data.frame),
#'   and \code{n_issues}.
#' @export
validate_trace <- function(trace,
                           strict = FALSE,
                           require_algorithm = TRUE) {
  if (!inherits(trace, "clintrace")) stop("Not a clintrace object")

  recs <- trace$records
  issues <- list()

  if (nrow(recs) == 0) {
    return(list(valid = TRUE, n_issues = 0L, issues = tibble::tibble()))
  }

  # 1. Missing source for non-direct
  bad_src <- recs[
    (is.na(recs$source_dataset) | is.na(recs$source_variable)) &
      recs$derivation_type != "other",
    c("step_id", "target_dataset", "target_variable", "derivation_type")
  ]
  if (nrow(bad_src)) {
    bad_src$issue <- "Missing source_dataset or source_variable"
    issues[[length(issues) + 1]] <- bad_src
  }

  # 2. Empty algorithm on derived/flag/imputed
  if (require_algorithm) {
    empty_alg <- recs[
      recs$derivation_type %in% c("derived", "flag", "imputed") &
        (is.na(recs$algorithm) | nchar(trimws(recs$algorithm)) == 0),
      c("step_id", "target_dataset", "target_variable", "derivation_type")
    ]
    if (nrow(empty_alg)) {
      empty_alg$issue <- "Empty algorithm description for derived variable"
      issues[[length(issues) + 1]] <- empty_alg
    }
  }

  # 3. Duplicate target_variable + target_dataset
  dups <- recs %>%
    dplyr::count(target_dataset, target_variable) %>%
    dplyr::filter(n > 1)
  if (nrow(dups)) {
    dups$issue <- "Duplicate target_variable in same dataset"
    dups$step_id <- NA_integer_
    dups$derivation_type <- NA_character_
    issues[[length(issues) + 1]] <- dups
  }

  # 4. Very short algorithm (likely incomplete)
  short_alg <- recs[
    recs$derivation_type %in% c("derived", "flag") &
      !is.na(recs$algorithm) &
      nchar(trimws(recs$algorithm)) > 0 &
      nchar(trimws(recs$algorithm)) < 8,
    c("step_id", "target_dataset", "target_variable", "derivation_type")
  ]
  if (nrow(short_alg)) {
    short_alg$issue <- "Algorithm description is very short (< 8 characters)"
    issues[[length(issues) + 1]] <- short_alg
  }

  issues_df <- if (length(issues)) {
    dplyr::bind_rows(issues)
  } else {
    tibble::tibble()
  }

  valid <- nrow(issues_df) == 0
  if (strict && !valid) {
    stop("Trace validation failed with ", nrow(issues_df), " issue(s). See $issues.")
  }

  list(
    valid = valid,
    n_issues = nrow(issues_df),
    issues = issues_df
  )
}