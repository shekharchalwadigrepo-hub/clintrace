\name{validate_trace}
\alias{validate_trace}
\title{Validate a clintrace object}
\usage{
validate_trace(trace, strict = FALSE)
}
\arguments{
\item{trace}{A clintrace object.}

\item{strict}{Logical. If TRUE, missing algorithm on derived variables is an error.}
}
\value{
A list with components \code{valid}, \code{issues}, and \code{n_issues}.
}
\description{
Checks for common issues in a lineage object: missing sources, empty algorithms,
duplicate targets, etc.
}
