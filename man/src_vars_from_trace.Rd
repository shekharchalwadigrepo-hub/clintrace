\name{src_vars_from_trace}
\alias{src_vars_from_trace}
\title{Generate suggested SRCDOM / SRCVAR / SRCSEQ columns}
\usage{
src_vars_from_trace(trace, target_dataset = NULL)
}
\arguments{
\item{trace}{A clintrace object.}

\item{target_dataset}{Optional filter.}
}
\value{
A data.frame with suggested SRC* columns for each target variable.
}
\description{
Produce a table of classic ADaM traceability variables (SRCDOM, SRCVAR, SRCSEQ)
from the recorded lineage.
}
