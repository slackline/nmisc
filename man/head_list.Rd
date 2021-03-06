% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/head_list.R
\name{head_list}
\alias{head_list}
\title{A custom head() function}
\usage{
head_list(obj, n = 6L, ...)
}
\arguments{
\item{obj}{a list object}

\item{n}{a single integer. If positive, prints the first n items for the
list and all entries in the list. If negative, prints all but the last
n items in the list.}
}
\value{
a list of length n, with items in the list of length n
}
\description{
Sane head_list() from https://gist.github.com/pimentel/256fc8c9b5191da63819
}
\details{
Return the first or last part of a list

Returns the first or last part of a list. Instead of returning the first
n entries as the standard head() does, it attempts to call head()
recursively on the entries in the list. If it fails, it will return the
particular entry (standard behavior).
}

