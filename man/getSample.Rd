% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getSample.R
\name{getSample}
\alias{getSample}
\title{Stratified random sampling}
\usage{
getSample(x, strata = 5, layers = names(x), norm = TRUE, n,
  mindist = 0, maxIter = 30, xy = T, filename_cluster = "",
  filename_samples = "", ...)
}
\arguments{
\item{x}{A \code{Raster*} object used to generate random sample}

\item{strata}{Number of strata. Default is 5.}

\item{layers}{Vector indicating the bands of \code{x} used in stratification
(as integer or names). By default, all layers of x are used.}

\item{norm}{Logical. If TRUE (default), \code{x} is normalized before k-means
clustering. This is useful if \code{layers} have different scales.}

\item{n}{Sample size}

\item{mindist}{Minimum distance between samples (in units of \code{x}). Default is 0.}

\item{maxIter}{Numeric. This number is multiplied to the number of samples to select per strata. If the number of iterations to select samples exceeds maxIter x the number of samples to select then the loop will break and a warning message be returned. Default is 30.}

\item{xy}{Logical indicating if X and Y coordinates of samples should be included in the fields of the returned \code{\link[sp]{SpatialPoints}} object.}

\item{filename_cluster}{Character. Output filename of the clustered \code{x} raster including path to directory and eventually extension}

\item{filename_samples}{Character. Output filename of the sample points including path to directory. File will be automatically saved as an ESRI Shapefile and any extension in \code{filename_samples} will be overwritten}

\item{...}{Further arguments passed to \code{\link[RStoolbox]{unsuperClass}}, \code{\link[raster]{writeRaster}} or \code{\link[rgdal]{writeOGR}} to control the kmeans algorithm or writing parameters}
}
\value{
A list with the following objects:
   \describe{
       \item{\code{samples}}{A \code{\link[sp]{SpatialPoints}} object containing sample points}
       \item{\code{cluster}}{The clustered \code{x} raster, output of \code{\link[RStoolbox]{unsuperClass}}}
   }
}
\description{
Performs kmeans clustering to stratify \code{x} and randomly samples within
the strata until \code{n} samples are selected. The number of samples selected
in each strata is proportional to the occurrence of those strata across the
classified raster.
}
\details{
\code{x} is stratified using kmeans clustering from \code{\link[RStoolbox]{unsuperClass}}.
By default, clustering is performed on a random subset of \code{x} (10000 cells) and run
with multiple starting configurations in order to find a convergent solution
from the multiple starts. The parameters controlling the number of random
samples used to perform kmeans clustering and the number of starting
configurations can be provided under the \code{...} argument. More
information on the behavior of the kmeans clustering can be found in
\code{\link[RStoolbox]{unsuperClass}}. The default kmeans clustering method
is Hartigan-Wong algorithm. The algorithm might not converge and output
"Quick Transfer" warning. If this is the case, we suggest decreasing
\code{strata}. Also, if \code{mindist} is too large, it might not be
possible to select enough samples per strata. In that case, the warning
"Exceeded maximum number of runs for strata" is displayed. In that case
you can decrease the number of samples \code{n} or increase \code{maxIter}
to control the number of maximum iterations allowed until the required number of samples are selected.
}
\seealso{
\code{\link[RStoolbox]{unsuperClass}}
}
