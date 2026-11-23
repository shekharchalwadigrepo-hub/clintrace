\name{attach_trace}
\alias{attach_trace}
\title{Attach a clintrace object as an attribute on a data.frame}
\usage{
attach_trace(data, trace)
}
\arguments{
\item{data}{A data.frame.}

\item{trace}{A clintrace object.}
}
\value{
The data.frame with the trace attached as attribute "clintrace".
}
\description{
Attach lineage metadata directly to an analysis dataset so it travels with the data.
}
