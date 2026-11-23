\name{load_example}
\alias{load_example}
\title{Load example clinical datasets}
\usage{
load_example(name = c("dm", "ex"))
}
\arguments{
\item{name}{Character. One of "dm", "ex".}
}
\value{
A data.frame.
}
\description{
Load built-in example SDTM-like datasets for demonstration.
}
\examples{
dm <- load_example("dm")
head(dm)
}
