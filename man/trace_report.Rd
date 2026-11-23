\name{trace_report}
\alias{trace_report}
\title{Generate a polished HTML lineage report}
\usage{
trace_report(
  trace,
  file = NULL,
  title = "Clinical Data Lineage Report",
  study_info = list()
)
}
\arguments{
\item{trace}{A clintrace object.}

\item{file}{Character. Output HTML file path. If NULL, returns HTML as character.}

\item{title}{Character. Report title.}

\item{study_info}{Optional list with extra study metadata to display.}
}
\value{
Path to the HTML file (invisibly) or HTML string.
}
\description{
Generate a polished HTML report of lineage records, including summary cards
and validation status. Requires the knitr and htmltools packages.
}
\examples{
tr <- new_trace("ABC-123")
tr <- add_lineage(tr, "ADSL", "AGEGR1", "DM", "AGE", algorithm = "banding")
# html <- trace_report(tr)
# trace_report(tr, file = tempfile(fileext = ".html"))
}
