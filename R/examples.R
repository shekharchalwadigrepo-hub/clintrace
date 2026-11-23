#' Load example clinical datasets
#'
#' @param name Character. One of "dm", "ex".
#'
#' @return A data.frame.
#' @export
#'
#' @examples
#' dm <- load_example("dm")
#' head(dm)
load_example <- function(name = c("dm", "ex")) {
  name <- match.arg(name)
  path <- system.file("extdata", paste0(name, ".csv"), package = "clintrace")
  if (!nzchar(path) || !file.exists(path)) {
    stop("Example data not found: ", name)
  }
  utils::read.csv(path, stringsAsFactors = FALSE)
}
