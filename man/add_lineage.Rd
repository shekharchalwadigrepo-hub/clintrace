\name{add_lineage}
\alias{add_lineage}
\title{Add a lineage record}
\usage{
add_lineage(
  trace,
  target_dataset,
  target_variable,
  source_dataset = NA_character_,
  source_variable = NA_character_,
  derivation_type = "derived",
  algorithm = "",
  keys = NA_character_,
  usubjid = NA_character_,
  notes = ""
)
}
\arguments{
\item{trace}{A clintrace object.}

\item{target_dataset}{Character. Target dataset name (e.g. "ADSL").}

\item{target_variable}{Character. Target variable name.}

\item{source_dataset}{Character. Source dataset name (e.g. "DM").}

\item{source_variable}{Character. Source variable name.}

\item{derivation_type}{Character. One of "direct", "derived", "imputed", "flag", "other".}

\item{algorithm}{Character. Human-readable description of the derivation.}

\item{keys}{Optional character. Key variables used for joining.}

\item{usubjid}{Optional character. Specific subject if record-level.}

\item{notes}{Optional character. Additional notes.}
}
\value{
Updated clintrace object.
}
\description{
Add a single lineage / traceability record to a clintrace object.
}
\examples{
tr <- new_trace("ABC-123")
tr <- add_lineage(
  tr,
  target_dataset = "ADSL",
  target_variable = "AGEGR1",
  source_dataset = "DM",
  source_variable = "AGE",
  derivation_type = "derived",
  algorithm = "Age banding"
)
}
