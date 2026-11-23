\name{query_lineage}
\alias{query_lineage}
\title{Query lineage records}
\usage{
query_lineage(
  trace,
  target_variable = NULL,
  target_dataset = NULL,
  usubjid = NULL,
  source_variable = NULL
)
}
\arguments{
\item{trace}{A clintrace object.}

\item{target_variable}{Character. Filter by target variable (optional).}

\item{target_dataset}{Character. Filter by target dataset (optional).}

\item{usubjid}{Character. Filter by subject (optional).}

\item{source_variable}{Character. Filter by source variable (optional).}
}
\value{
A tibble of matching lineage records.
}
\description{
Query stored lineage records by variable, dataset, or subject.
}
\examples{
tr <- new_trace("ABC-123")
tr <- add_lineage(tr, "ADSL", "AGEGR1", "DM", "AGE", algorithm = "banding")
query_lineage(tr, target_variable = "AGEGR1")
}
