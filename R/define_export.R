#' Export lineage metadata in a Define-XML friendly format
#'
#' Produces a data.frame that can be used to populate Origin / Method /
#' Comment sections of a Define-XML (or ADRG) for ADaM variables.
#'
#' @param trace A clintrace object.
#' @param target_dataset Optional filter.
#'
#' @return A data.frame with columns suitable for Define-XML method/origin text.
#' @export
#'
#' @examples
#' tr <- new_trace("ABC")
#' tr <- add_lineage(tr, "ADSL", "AGEGR1", "DM", "AGE",
#'                   algorithm = "Age banding <65 / >=65")
#' export_define_metadata(tr)
export_define_metadata <- function(trace, target_dataset = NULL) {
  if (!inherits(trace, "clintrace")) stop("Not a clintrace object")

  recs <- query_lineage(trace, target_dataset = target_dataset)
  if (nrow(recs) == 0) {
    return(tibble::tibble(
      Dataset = character(),
      Variable = character(),
      Origin = character(),
      Method = character(),
      Comment = character(),
      DerivationType = character()
    ))
  }

  recs %>%
    dplyr::group_by(target_dataset, target_variable) %>%
    dplyr::slice(1) %>%
    dplyr::ungroup() %>%
    dplyr::transmute(
      Dataset = target_dataset,
      Variable = target_variable,
      Origin = dplyr::case_when(
        derivation_type == "direct" ~ paste0("Predecessor: ", source_dataset, ".", source_variable),
        TRUE ~ paste0("Derived from ", source_dataset, ".", source_variable)
      ),
      Method = dplyr::if_else(
        derivation_type == "direct",
        "Copied from source",
        algorithm
      ),
      Comment = paste0(
        "Traceability: ", source_dataset, ".", source_variable,
        " (", derivation_type, ")"
      ),
      DerivationType = derivation_type,
      SourceDataset = source_dataset,
      SourceVariable = source_variable
    )
}

#' Write Define-XML friendly metadata to CSV
#'
#' @param trace A clintrace object.
#' @param file Output CSV path.
#' @param ... Passed to \code{export_define_metadata}.
#'
#' @return The file path (invisibly).
#' @export
write_define_metadata <- function(trace, file, ...) {
  df <- export_define_metadata(trace, ...)
  utils::write.csv(df, file, row.names = FALSE)
  message("Define-XML metadata written to: ", file)
  invisible(file)
}
