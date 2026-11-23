\name{validate_trace}
\alias{validate_trace}
\title{Validate a clintrace object}
\usage{
validate_trace(trace, strict = FALSE, require_algorithm = TRUE)
}
\arguments{
\item{trace}{A clintrace object.}

\item{strict}{Logical. If TRUE, raises an error when issues are found.}

\item{require_algorithm}{Logical. Whether empty algorithms on derived/flag
variables should be flagged.}
}
\value{
A list with components \code{valid}, \code{issues}, and \code{n_issues}.
}
\description{
Checks for common issues in a lineage object: missing sources, empty algorithms,
duplicate targets, etc.
}
