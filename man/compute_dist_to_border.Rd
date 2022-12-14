% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/compute_dist_to_border.R
\name{compute_dist_to_border}
\alias{compute_dist_to_border}
\title{Given a boarder between two spot groups, infer for each spot a: (i) the distance the
closest spot (b) in the other class, (ii) the x/y coordinate of the point lying at the crossing
between the border and (a,b) segment, (iii) the distance to the border.}
\usage{
compute_dist_to_border(coord_spot, border_segments, diagnostic_plot = TRUE)
}
\arguments{
\item{coord_spot}{a data.frame with spot coordinates (columns "x" and "y") and a column k (0 or 1) giving the class of the spot.}

\item{border_segments}{a data.frame as produce by compute_visium_ortho_hull.}

\item{diagnostic_plot}{Whether to produce a diagnostic diagram. Highly recommanded to visualy inspect the results.}
}
\value{
a dataframe with the following columns: x (input x coordinate), y (input y coordinate),
tgt_name (the name/index of the closest spot), tgt_x (the x coordinate of the closest spot),
tgt_y (the y coordinate of the closest spot), dist2tgt (the euclidean distance to the closest spot),
x_inter (the x coordinate of the intersection with the border), y_inter (the y coordinate of the
intersection with the border), dist2_inter (the distance to the intersection with the border),
k (input k).
}
\description{
Given a boarder between two spot groups, infer for each spot a: (i) the distance the
closest spot (b) in the other class, (ii) the x/y coordinate of the point lying at the crossing
between the border and (a,b) segment, (iii) the distance to the border.
}
\examples{
#' ## Install and process the brain dataset
library(Seurat)
library(SeuratData)
library(ggplot2)
InstallData("stxBrain")
library(ohmiki)
brain <- LoadData("stxBrain", type = "anterior1")
brain <- SCTransform(brain, assay = "Spatial", verbose = FALSE)
brain <- RunPCA(brain, assay = "SCT", verbose = FALSE)
brain <- FindNeighbors(brain, reduction = "pca", dims = 1:30)
brain <- FindClusters(brain, verbose = FALSE)
brain <- RunUMAP(brain, reduction = "pca", dims = 1:30)
# Select some points (just to give an example)
coord_spot_brain <- getFlippedTissueCoordinates(brain)
coord_spot_brain$k <- 0
coord_spot_brain[SeuratObject::WhichCells(brain, idents=0), ]$k <- 1 # class 0 is the class of interest (labeled 1 against 0 for others)
border_segments <- compute_visium_ortho_hull(coord_spot_brain, size_x=3.6, size_y=3.4, delta=0.5)
dist_to_border <- compute_dist_to_border(coord_spot_brain, border_segments)
brain[["dist2border"]] <- dist_to_border$dist2_inter
SpatialFeaturePlot(brain,
         features = "dist2border") +
         #'   theme_bw() +
         geom_segment(data=border_segments,
               mapping=aes(x=x1,
                           y=y1,
                           xend=x2,
                           yend=y2),
               inherit.aes = F,
               color="white",
               size=0.7)
}
\keyword{border,}
\keyword{hull,}
\keyword{spatial}
\keyword{spot.}
\keyword{transcriptomics,}
\keyword{visium,}
