\name{get_trace}
\alias{get_trace}
\title{Retrieve a clintrace object attached to a data.frame}
\usage{
get_trace(data)
}
\arguments{
\item{data}{A data.frame that may have a clintrace attribute.}
}
\value{
The clintrace object or NULL.
}
\description{
Retrieve lineage metadata previously attached with \code{attach_trace()}.
}
