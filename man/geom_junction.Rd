% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/geom_junction.R
\name{geom_junction}
\alias{geom_junction}
\title{Plot junction curves}
\usage{
geom_junction(
  mapping = NULL,
  data = NULL,
  stat = "identity",
  position = "identity",
  junction.orientation = "alternating",
  junction.y.max = 1,
  angle = 90,
  ncp = 15,
  na.rm = FALSE,
  orientation = NA,
  show.legend = NA,
  inherit.aes = TRUE,
  ...
)
}
\arguments{
\item{mapping}{Set of aesthetic mappings created by \code{\link[ggplot2:aes]{aes()}} or
\code{\link[ggplot2:aes_]{aes_()}}. If specified and \code{inherit.aes = TRUE} (the
default), it is combined with the default mapping at the top level of the
plot. You must supply \code{mapping} if there is no plot mapping.}

\item{data}{The data to be displayed in this layer. There are three
options:

If \code{NULL}, the default, the data is inherited from the plot
data as specified in the call to \code{\link[ggplot2:ggplot]{ggplot()}}.

A \code{data.frame}, or other object, will override the plot
data. All objects will be fortified to produce a data frame. See
\code{\link[ggplot2:fortify]{fortify()}} for which variables will be created.

A \code{function} will be called with a single argument,
the plot data. The return value must be a \code{data.frame}, and
will be used as the layer data. A \code{function} can be created
from a \code{formula} (e.g. \code{~ head(.x, 10)}).}

\item{stat}{The statistical transformation to use on the data for this
layer, as a string.}

\item{position}{Position adjustment, either as a string, or the result of
a call to a position adjustment function.}

\item{junction.orientation}{\code{character()} one of "alternating", "top" or
"bottom", specifying where the junctions will be plotted with respect to
each transcript (\code{y}).}

\item{junction.y.max}{\code{double()} the max y-value of each junction curve. It
can be useful to adjust this parameter when junction curves overlap with
one another/other transcripts or extend beyond the plot margins.}

\item{angle}{A numeric value between 0 and 180,
    giving an amount to skew the control
    points of the curve.  Values less than 90 skew the curve towards
    the start point and values greater than 90 skew the curve
    towards the end point.}

\item{ncp}{The number of control points used to draw the curve.
    More control points creates a smoother curve.}

\item{na.rm}{If \code{FALSE}, the default, missing values are removed with
a warning. If \code{TRUE}, missing values are silently removed.}

\item{orientation}{The orientation of the layer. The default (\code{NA})
automatically determines the orientation from the aesthetic mapping. In the
rare event that this fails it can be given explicitly by setting \code{orientation}
to either \code{"x"} or \code{"y"}. See the \emph{Orientation} section for more detail.}

\item{show.legend}{logical. Should this layer be included in the legends?
\code{NA}, the default, includes if any aesthetics are mapped.
\code{FALSE} never includes, and \code{TRUE} always includes.
It can also be a named logical vector to finely select the aesthetics to
display.}

\item{inherit.aes}{If \code{FALSE}, overrides the default aesthetics,
rather than combining with them. This is most useful for helper functions
that define both data and aesthetics and shouldn't inherit behaviour from
the default plot specification, e.g. \code{\link[ggplot2:borders]{borders()}}.}

\item{...}{Other arguments passed on to \code{\link[ggplot2:layer]{layer()}}. These are
often aesthetics, used to set an aesthetic to a fixed value, like
\code{colour = "red"} or \code{size = 3}. They may also be parameters
to the paired geom/stat.}
}
\value{
the return value of a \verb{geom_*} function is not intended to be
directly handled by users. Therefore, \verb{geom_*} functions should never be
executed in isolation, rather used in combination with a
\code{ggplot2::ggplot()} call.
}
\description{
\code{geom_junction()} draws curves that are designed to represent junction reads
from RNA-sequencing data. It can be useful to overlay junction data on
transcript annotation (plotted using \code{geom_range()}/\code{geom_half_range()} and
\code{geom_intron()}) to understand which splicing events or transcripts have
support from RNA-sequencing data.
}
\details{
\code{geom_junction()} requires the following \code{aes()}; \code{xstart}, \code{xend} and \code{y}
(e.g. transcript name). \code{geom_junction()} curves can be modified using
\code{junction.y.max}, which can be useful when junctions overlap one
another/other transcripts or extend beyond the plot margins. By default,
junction curves will alternate between being plotted on the top and bottom of
each transcript (\code{y}), however this can be modified via
\code{junction.orientation}.
}
\examples{

library(magrittr)
library(ggplot2)

# to illustrate the package's functionality
# ggtranscript includes example transcript annotation
sod1_annotation \%>\% head()

# as well as a set of example (unannotated) junctions
# originating from GTEx and downloaded via the Bioconductor package snapcount
sod1_junctions

# extract exons
sod1_exons <- sod1_annotation \%>\% dplyr::filter(
    type == "exon",
    transcript_name == "SOD1-201"
)
sod1_exons \%>\% head()

# add transcript_name to junctions for plotting
sod1_junctions <- sod1_junctions \%>\%
    dplyr::mutate(transcript_name = "SOD1-201")

# junctions can be plotted as curves using geom_junction()
base <- sod1_junctions \%>\%
    ggplot2::ggplot(ggplot2::aes(
        xstart = start,
        xend = end,
        y = transcript_name
    ))

# sometimes, depending on the number and widths of transcripts and junctions
# junctions will go overlap one another or extend beyond the plot margin
base + geom_junction()

# in such cases, junction.y.max can be adjusted to modify the max y of curves
base + geom_junction(junction.y.max = 0.5)

# ncp can be used improve the smoothness of curves
base + geom_junction(junction.y.max = 0.5, ncp = 30)

# junction.orientation controls where the junction are plotted
# with respect to each transcript
# either alternating (default), or on the top or bottom
base + geom_junction(junction.orientation = "top", junction.y.max = 0.5)
base + geom_junction(junction.orientation = "bottom", junction.y.max = 0.5)

# it can be useful useful to overlay junction curves onto existing annotation
# plotted using geom_range() and geom_intron()
base <- sod1_exons \%>\%
    ggplot(aes(
        xstart = start,
        xend = end,
        y = transcript_name
    )) +
    geom_range() +
    geom_intron(
        data = to_intron(sod1_exons, "transcript_name")
    )

base + geom_junction(
    data = sod1_junctions,
    junction.y.max = 0.5
)

# as a ggplot2 extension, ggtranscript geoms inherit the
# the functionality from the parameters and aesthetics in ggplot2
# this can be useful when mapping junction thickness to their counts
base + geom_junction(
    data = sod1_junctions,
    aes(size = mean_count),
    junction.y.max = 0.5,
    colour = "purple"
) +
    scale_size(range = c(0.1, 1))

# it can be useful to combine geom_junction() with geom_half_range()
sod1_exons \%>\%
    ggplot(aes(
        xstart = start,
        xend = end,
        y = transcript_name
    )) +
    geom_half_range() +
    geom_intron(
        data = to_intron(sod1_exons, "transcript_name")
    ) +
    geom_junction(
        data = sod1_junctions,
        aes(size = mean_count),
        junction.y.max = 0.5,
        junction.orientation = "top",
        colour = "purple"
    ) +
    scale_size(range = c(0.1, 1))
}
