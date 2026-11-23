#' Null-coalescing operator
#' @noRd
`%||%` <- function(x, y) {
  if (is.null(x) || length(x) == 0 || (is.atomic(x) && all(is.na(x)))) y else x
}
