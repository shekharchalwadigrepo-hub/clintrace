\name{new_trace}
\alias{new_trace}
\title{Create a new trace object}
\usage{
new_trace(study_id = NA_character_, metadata = list())
}
\arguments{
\item{study_id}{Character. Study identifier.}

\item{metadata}{Optional list of additional metadata.}
}
\value{
An object of class \code{"clintrace"}.
}
\description{
Create a new empty lineage tracking object.
}
\examples{
tr <- new_trace(study_id = "ABC-123")
print(tr)
}
