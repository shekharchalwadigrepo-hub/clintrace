#' Query lineage records
#'
#' @param trace A clintrace object.
#' @param target_variable Character. Filter by target variable (optional).
#' @param target_dataset Character. Filter by target dataset (optional).
#' @param usubjid Character. Filter by subject (optional).
#' @param source_variable Character. Filter by source variable (optional).
#'
#' @return A tibble of matching lineage records.
#' @export
#'
#' @examples
#' tr <- new_trace("ABC-123")
#' tr <- add_lineage(tr, "ADSL", "AGEGR1", "DM", "AGE", algorithm = "banding")
#' query_lineage(tr, target_variable = "AGEGR1")
query_lineage <- function(trace,
                          target_variable = NULL,
                          target_dataset = NULL,
                          usubjid = NULL,
                          source_variable = NULL) {
  if (!inherits(trace, "clintrace")) {
    stop("trace must be a clintrace object")
  }

  df <- trace$records

  if (!is.null(target_variable)) {
    df <- dplyr::filter(df, target_variable == !!target_variable)
  }
  if (!is.null(target_dataset)) {
    df <- dplyr::filter(df, target_dataset == !!target_dataset)
  }
  if (!is.null(usubjid)) {
    df <- dplyr::filter(df, usubjid == !!usubjid | is.na(usubjid))
  }
  if (!is.null(source_variable)) {
    df <- dplyr::filter(df, source_variable == !!source_variable)
  }

  df
}

#' Summary of the trace object
#'
#' @param trace A clintrace object.
#' @param ... Ignored.
#'
#' @return A summary list (invisibly) and printed overview.
#' @export
trace_summary <- function(trace, ...) {
  if (!inherits(trace, "clintrace")) stop("Not a clintrace object")

  recs <- trace$records
  cat("clintrace summary\n")
  cat("=================\n")
  cat("Study ID     : ", trace$study_id %||% "<none>", "\n", sep = "")
  cat("Created      : ", format(trace$created), "\n", sep = "")
  cat("Total records: ", nrow(recs), "\n\n", sep = "")

  if (nrow(recs) > 0) {
    cat("By target dataset:\n")
    print(table(recs$target_dataset))
    cat("\nBy derivation type:\n")
    print(table(recs$derivation_type))
    cat("\nVariables traced:\n")
    print(unique(recs[, c("target_dataset", "target_variable")]))
  }

  invisible(list(
    n_records = nrow(recs),
    datasets = unique(recs$target_dataset),
    variables = unique(recs$target_variable)
  ))
}

#' Suggest classic ADaM SRC* variables from lineage
#'
#' @param trace A clintrace object.
#' @param target_variable Character. The ADaM variable to generate SRC vars for.
#'
#' @return A named list with suggested SRCDOM, SRCVAR, SRCSEQ (or NULL).
#' @export
suggest_src_vars <- function(trace, target_variable) {
  matches <- query_lineage(trace, target_variable = target_variable)
  if (nrow(matches) == 0) {
    return(list(SRCDOM = NA, SRCVAR = NA, SRCSEQ = NA))
  }

  # Take the most recent / primary source
  m <- matches[1, ]
  list(
    SRCDOM = m$source_dataset,
    SRCVAR = m$source_variable,
    SRCSEQ = "use --SEQ from source if available"
  )
}
