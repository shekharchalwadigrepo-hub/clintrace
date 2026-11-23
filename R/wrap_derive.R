#' Wrap an existing derivation function and automatically record lineage
#'
#' @param data A data.frame.
#' @param trace A clintrace object.
#' @param fun A function that takes a data.frame and returns a data.frame
#'   with new/derived variables.
#' @param target_vars Character vector of variables that \code{fun} creates or modifies.
#' @param source_dataset Character. Source dataset name.
#' @param source_vars Named character vector or list mapping target_var -> source_var.
#'   If unnamed, the same source variable is assumed for all targets.
#' @param derivation_type Character or named vector.
#' @param algorithm Character or named vector of algorithm descriptions.
#' @param target_dataset Character. Target dataset name (default "ADSL").
#' @param keys Character.
#'
#' @return A list with components \code{data} and \code{trace}.
#' @export
#'
#' @examples
#' dm <- load_example("dm")
#' tr <- new_trace("ABC")
#'
#' agegr_fun <- function(df) {
#'   df$AGEGR1 <- ifelse(df$AGE < 65, "<65", ">=65")
#'   df
#' }
#'
#' res <- wrap_derive(
#'   data = dm,
#'   trace = tr,
#'   fun = agegr_fun,
#'   target_vars = "AGEGR1",
#'   source_dataset = "DM",
#'   source_vars = c(AGEGR1 = "AGE"),
#'   algorithm = "Binary age group"
#' )
#' query_lineage(res$trace)
wrap_derive <- function(data,
                        trace,
                        fun,
                        target_vars,
                        source_dataset = NA_character_,
                        source_vars = NULL,
                        derivation_type = "derived",
                        algorithm = "",
                        target_dataset = "ADSL",
                        keys = "USUBJID") {
  if (!inherits(trace, "clintrace")) stop("trace must be a clintrace object")
  if (!is.function(fun)) stop("fun must be a function")

  # Apply the derivation
  data <- fun(data)

  # Normalize source_vars
  if (is.null(source_vars)) {
    source_vars <- setNames(rep(NA_character_, length(target_vars)), target_vars)
  } else if (is.null(names(source_vars))) {
    source_vars <- setNames(rep(source_vars[1], length(target_vars)), target_vars)
  }

  # Normalize other args
  if (length(derivation_type) == 1) {
    derivation_type <- setNames(rep(derivation_type, length(target_vars)), target_vars)
  }
  if (length(algorithm) == 1) {
    algorithm <- setNames(rep(algorithm, length(target_vars)), target_vars)
  }

  for (v in target_vars) {
    trace <- add_lineage(
      trace,
      target_dataset  = target_dataset,
      target_variable = v,
      source_dataset  = source_dataset,
      source_variable = source_vars[[v]] %||% NA_character_,
      derivation_type = derivation_type[[v]] %||% "derived",
      algorithm       = algorithm[[v]] %||% "",
      keys            = keys
    )
  }

  list(data = data, trace = trace)
}
