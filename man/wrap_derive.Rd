\name{wrap_derive}
\alias{wrap_derive}
\title{Wrap an existing derivation function and automatically record lineage}
\usage{
wrap_derive(
  data,
  trace,
  fun,
  target_vars,
  source_dataset = NA_character_,
  source_vars = NULL,
  derivation_type = "derived",
  algorithm = "",
  target_dataset = "ADSL",
  keys = "USUBJID"
)
}
\arguments{
\item{data}{A data.frame.}

\item{trace}{A clintrace object.}

\item{fun}{A function that takes a data.frame and returns a data.frame with new variables.}

\item{target_vars}{Character vector of variables that fun creates.}

\item{source_dataset}{Character. Source dataset name.}

\item{source_vars}{Named character vector mapping target_var to source_var.}

\item{derivation_type}{Character or named vector.}

\item{algorithm}{Character or named vector of algorithm descriptions.}

\item{target_dataset}{Character. Target dataset name.}

\item{keys}{Character.}
}
\value{
A list with components \code{data} and \code{trace}.
}
\description{
Apply any derivation function and automatically record lineage for the
variables it creates. Useful for wrapping admiral or custom functions.
}
\examples{
dm <- load_example("dm")
tr <- new_trace("ABC")
agegr_fun <- function(df) {
  df$AGEGR1 <- ifelse(df$AGE < 65, "<65", ">=65")
  df
}
res <- wrap_derive(dm, tr, agegr_fun, "AGEGR1",
                   source_dataset = "DM",
                   source_vars = c(AGEGR1 = "AGE"),
                   algorithm = "Binary age group")
query_lineage(res$trace)
}
