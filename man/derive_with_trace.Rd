\name{derive_with_trace}
\alias{derive_with_trace}
\title{Derive a variable and automatically record lineage}
\usage{
derive_with_trace(
  data,
  trace,
  target_variable,
  expr,
  source_dataset = NA_character_,
  source_variable = NA_character_,
  derivation_type = "derived",
  algorithm = "",
  keys = "USUBJID"
)
}
\arguments{
\item{data}{A data.frame.}

\item{trace}{A clintrace object.}

\item{target_variable}{Name of the new variable.}

\item{expr}{Expression that creates the variable (unquoted).}

\item{source_dataset}{Character.}

\item{source_variable}{Character.}

\item{derivation_type}{Character.}

\item{algorithm}{Character.}

\item{keys}{Character.}
}
\value{
A list with components \code{data} and \code{trace}.
}
\description{
Derive a new variable and automatically record its lineage in one step.
}
\examples{
tr <- new_trace("ABC")
dm <- load_example("dm")
res <- derive_with_trace(
  dm, tr,
  target_variable = "AGEGR1",
  expr = ifelse(AGE < 65, "<65", ">=65"),
  source_dataset = "DM",
  source_variable = "AGE",
  algorithm = "binary age group"
)
res$data
query_lineage(res$trace, "AGEGR1")
}
