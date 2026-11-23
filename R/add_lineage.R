#' Add a lineage record
#'
#' @param trace A clintrace object.
#' @param target_dataset Character. Target dataset name (e.g. "ADSL").
#' @param target_variable Character. Target variable name.
#' @param source_dataset Character. Source dataset name (e.g. "DM").
#' @param source_variable Character. Source variable name.
#' @param derivation_type Character. One of "direct", "derived", "imputed",
#'   "flag", "other".
#' @param algorithm Character. Human-readable description of the derivation.
#' @param keys Optional character. Key variables used for joining (e.g. "USUBJID").
#' @param usubjid Optional character. Specific subject if record-level.
#' @param notes Optional character. Additional notes.
#'
#' @return Updated clintrace object.
#' @export
#'
#' @examples
#' tr <- new_trace("ABC-123")
#' tr <- add_lineage(
#'   tr,
#'   target_dataset = "ADSL",
#'   target_variable = "AGEGR1",
#'   source_dataset = "DM",
#'   source_variable = "AGE",
#'   derivation_type = "derived",
#'   algorithm = "Age banding"
#' )
add_lineage <- function(trace,
                        target_dataset,
                        target_variable,
                        source_dataset = NA_character_,
                        source_variable = NA_character_,
                        derivation_type = "derived",
                        algorithm = "",
                        keys = NA_character_,
                        usubjid = NA_character_,
                        notes = "") {
  if (!inherits(trace, "clintrace")) {
    stop("trace must be a clintrace object created by new_trace()")
  }

  derivation_type <- match.arg(
    derivation_type,
    c("direct", "derived", "imputed", "flag", "other")
  )

  new_rec <- tibble::tibble(
    step_id = if (nrow(trace$records) == 0) 1L else max(trace$records$step_id) + 1L,
    target_dataset = as.character(target_dataset),
    target_variable = as.character(target_variable),
    source_dataset = as.character(source_dataset),
    source_variable = as.character(source_variable),
    derivation_type = derivation_type,
    algorithm = as.character(algorithm),
    keys = as.character(keys),
    usubjid = as.character(usubjid),
    notes = as.character(notes),
    timestamp = Sys.time()
  )

  trace$records <- dplyr::bind_rows(trace$records, new_rec)
  trace
}
