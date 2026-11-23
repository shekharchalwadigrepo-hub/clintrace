\name{suggest_src_vars}
\alias{suggest_src_vars}
\title{Suggest classic ADaM SRC* variables from lineage}
\usage{
suggest_src_vars(trace, target_variable)
}
\arguments{
\item{trace}{A clintrace object.}

\item{target_variable}{Character. The ADaM variable to generate SRC vars for.}
}
\value{
A named list with suggested SRCDOM, SRCVAR, SRCSEQ.
}
\description{
Generate suggested SRCDOM / SRCVAR / SRCSEQ values based on recorded lineage.
}
