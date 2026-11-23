#' Attach a clintrace object as an attribute on a data.frame
#'
#' @param data A data.frame.
#' @param trace A clintrace object.
#'
#' @return The data.frame with the trace attached as attribute "clintrace".
#' @export
attach_trace <- function(data, trace) {
  if (!inherits(trace, "clintrace")) {
    stop("trace must be a clintrace object created by new_trace()")
  }
  attr(data, "clintrace") <- trace
  data
}

#' Retrieve a clintrace object attached to a data.frame
#'
#' @param data A data.frame that may have a clintrace attribute.
#'
#' @return The clintrace object or NULL.
#' @export
get_trace <- function(data) {
  attr(data, "clintrace")
}

#' Generate suggested SRCDOM / SRCVAR / SRCSEQ columns
#'
#' @param trace A clintrace object.
#' @param target_dataset Optional filter.
#'
#' @return A data.frame with one row per target variable and suggested SRC* columns.
#' @export
src_vars_from_trace <- function(trace, target_dataset = NULL) {
  if (!inherits(trace, "clintrace")) stop("Not a clintrace object")

  recs <- query_lineage(trace, target_dataset = target_dataset)
  if (nrow(recs) == 0) return(tibble::tibble())

  # First record per target
  recs <- recs[!duplicated(recs[, c("target_dataset", "target_variable")]), ]

  tibble::tibble(
    target_dataset = recs$target_dataset,
    target_variable = recs$target_variable,
    SRCDOM = recs$source_dataset,
    SRCVAR = recs$source_variable,
    SRCSEQ = ifelse(!is.na(recs$keys) & recs$keys != "",
                    paste0(recs$keys, "SEQ"),
                    NA_character_),
    derivation_type = recs$derivation_type,
    algorithm = recs$algorithm
  )
}
