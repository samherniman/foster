#'Match the resolution of two Raster objects
#'
#'Successively projects and resamples a Raster coordinate system and spatial
#'resolution to the reference
#'
#'\code{x} and \code{ref} must have defined CRS (can be assigned using
#'\code{\link[raster]{projection}}). If the CRS don't match, \code{x} is
#'projected to \code{ref} CRS prior to resampling. \code{x} doesn't inherit
#'the extent of \code{ref}.
#'
#'@param x \code{Raster*} object to resample
#'@param ref Reference \code{Raster*} object with parameters that \code{x}
#' should be resampled to.
#'@param method Character. Method used to compute values for the resampled
#'raster. Can be \code{'bilinear'} for bilinear
#'interpolation or \code{'ngb'} for nearest neighbor interpolation.
#'@param filename Character (optional). Output filename including path to directory and
#'eventually extension
#'@param ... Other arguments passed to \code{\link[raster]{writeRaster}}
#'@return A \code{Raster*} object
#'@seealso \code{\link[raster]{resample}}, \code{\link[raster]{projectRaster}}, \code{\link[raster]{projection}}
#'@export

matchResolution <- function(x,
                            ref,
                            method="bilinear",
                            filename="",
                            ...){


  if (!class(x)[1] %in% c("RasterLayer", "RasterBrick", "RasterStack")) {
    stop("x must be a Raster object")
  }

  if (!class(ref)[1] %in% c("RasterLayer", "RasterBrick", "RasterStack")) {
    stop("ref must be a Raster object")
  }

  #Check CRS
  if (is.na(raster::crs(x)) | is.na(raster::crs(ref))) {
    stop("CRS of x or ref is not defined")
  } else if (!raster::compareCRS(crs(x), crs(ref))) {
    warning("x and ref don't have the same CRS. x is projected to ref CRS before
            resampling")
    x <- raster::projectRaster(x, crs = raster::crs(ref))
  }

  if (raster::extent(ref) > raster::extent(x)) {
    #We crop ref to x extent. It avoids creating a large resampled x if ref
    #extent is much larger than x
    ref_crop <- raster::crop(ref, x, filename = "")
  } else {
    ref_crop <- ref
  }
  #Resampling
  out <- raster::resample(x = x, y = ref_crop, method = method, filename =
                            filename, ...)

  return(out)
}
