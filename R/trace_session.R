#' Create a new trace object
#'
#' @param study_id Character. Study identifier.
#' @param metadata Optional list of additional metadata.
#'
#' @return An object of class "clintrace".
#' @export
#'
#' @examples
#' tr <- new_trace(study_id = "ABC-123")
#' print(tr)
new_trace <- function(study_id = NA_character_, metadata = list()) {
  structure(
    list(
      study_id = study_id,
      created = Sys.time(),
      metadata = metadata,
      records = tibble::tibble(
        step_id = integer(),
        target_dataset = character(),
        target_variable = character(),
        source_dataset = character(),
        source_variable = character(),
        derivation_type = character(),
        algorithm = character(),
        keys = character(),
        usubjid = character(),
        notes = character(),
        timestamp = as.POSIXct(character())
      )
    ),
    class = "clintrace"
  )
}

#' Print method for clintrace objects
#'
#' @param x A clintrace object.
#' @param ... Ignored.
#' @export
print.clintrace <- function(x, ...) {
  n <- nrow(x$records)
  cat("<clintrace>\n")
  cat(" Study ID: ", x$study_id %||% "<not set>", "\n", sep = "")
  cat(" Records : ", n, "\n", sep = "")
  if (n > 0) {
    cat(" Targets : ", paste(unique(x$records$target_variable), collapse = ", "), "\n", sep = "")
  }
  invisible(x)
}

#' Convert clintrace to data.frame
#'
#' @param x A clintrace object.
#' @param ... Ignored.
#' @export
as.data.frame.clintrace <- function(x, ...) {
  as.data.frame(x$records)
}
