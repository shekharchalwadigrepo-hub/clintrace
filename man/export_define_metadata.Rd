\name{export_define_metadata}
\alias{export_define_metadata}
\title{Export lineage metadata in a Define-XML friendly format}
\usage{
export_define_metadata(trace, target_dataset = NULL)
}
\arguments{
\item{trace}{A clintrace object.}

\item{target_dataset}{Optional filter.}
}
\value{
A data.frame with Origin, Method, and Comment columns suitable for Define-XML.
}
\description{
Produces metadata that can populate Origin / Method / Comment sections
of a Define-XML or ADRG for ADaM variables.
}
\examples{
tr <- new_trace("ABC")
tr <- add_lineage(tr, "ADSL", "AGEGR1", "DM", "AGE", algorithm = "banding")
export_define_metadata(tr)
}
