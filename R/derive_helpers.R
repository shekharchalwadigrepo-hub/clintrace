#' Add multiple lineage records at once
#'
#' @param trace A clintrace object.
#' @param df A data.frame with columns matching \code{add_lineage} arguments
#'   (target_dataset, target_variable, etc.).
#'
#' @return Updated clintrace object.
#' @export
add_lineage_batch <- function(trace, df) {
  if (!inherits(trace, "clintrace")) {
    stop("trace must be a clintrace object")
  }
  required <- c("target_dataset", "target_variable")
  missing <- setdiff(required, names(df))
  if (length(missing)) {
    stop("Missing required columns: ", paste(missing, collapse = ", "))
  }

  for (i in seq_len(nrow(df))) {
    row <- df[i, ]
    trace <- add_lineage(
      trace,
      target_dataset  = row$target_dataset,
      target_variable = row$target_variable,
      source_dataset  = row$source_dataset %||% NA_character_,
      source_variable = row$source_variable %||% NA_character_,
      derivation_type = row$derivation_type %||% "derived",
      algorithm       = row$algorithm %||% "",
      keys            = row$keys %||% NA_character_,
      usubjid         = row$usubjid %||% NA_character_,
      notes           = row$notes %||% ""
    )
  }
  trace
}

#' Derive a variable and automatically record lineage
#'
#' @param data A data.frame.
#' @param trace A clintrace object.
#' @param target_variable Name of the new variable.
#' @param expr Expression that creates the variable (unquoted).
#' @param source_dataset Character.
#' @param source_variable Character.
#' @param derivation_type Character.
#' @param algorithm Character.
#' @param keys Character.
#'
#' @return A list with components \code{data} and \code{trace}.
#' @export
#'
#' @examples
#' tr <- new_trace("ABC")
#' dm <- load_example("dm")
#' res <- derive_with_trace(
#'   dm, tr,
#'   target_variable = "AGEGR1",
#'   expr = ifelse(AGE < 65, "<65", ">=65"),
#'   source_dataset = "DM",
#'   source_variable = "AGE",
#'   algorithm = "binary age group"
#' )
#' res$data
#' query_lineage(res$trace, "AGEGR1")
derive_with_trace <- function(data,
                              trace,
                              target_variable,
                              expr,
                              source_dataset = NA_character_,
                              source_variable = NA_character_,
                              derivation_type = "derived",
                              algorithm = "",
                              keys = "USUBJID") {
  if (!inherits(trace, "clintrace")) stop("trace must be a clintrace object")

  # Evaluate expression in data context
  data[[target_variable]] <- rlang::eval_tidy(rlang::enquo(expr), data = data)

  trace <- add_lineage(
    trace,
    target_dataset  = deparse(substitute(data)),
    target_variable = target_variable,
    source_dataset  = source_dataset,
    source_variable = source_variable,
    derivation_type = derivation_type,
    algorithm       = algorithm,
    keys            = keys
  )

  list(data = data, trace = trace)
}
