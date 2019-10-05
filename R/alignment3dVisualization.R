# alignment3dVisualization.R
#
# Purpose: main function of alignment3dVisulization
# Version: 1.0.0
# Date: 2019-09
# Author: Yuexin Yu
#
# Input: pdb file path, strings
# Output: Visualization of how similar two sequences are in 3D
# Dependencies: rgl, bio3d
#
# ===============================================================
#' alignment3dVisualization
#'
#' Visualization of how similar two sequences are in 3D. Note that
#'  the input pdb file must be the pdb after alignment. The blue one
#'  should be the template and the red one should be the target. A recommend
#'  webpage is http://fatcat.burnham.org/fatcat-cgi/cgi/fatcat.pl?-func=pairwise
#'  Download the pdb file after submitting the alignemnt as the input as this function.
#'
#' @param alignedPath The filepath of pdb after alignment.
#' @param targetName A string for the pdb name for the first part of
#' the pdb file after alignment.
#' @param templateName A string for the pdb name for the second part of
#' the pdb file after alignment.
#' @return return nothing but a window for visualization of two proteins in 3D
#' @examples
#' # http://fatcat.burnham.org/fatcat-cgi/cgi/fatcat.pl?-func=pairwise
#' # submit two files to the link and dowload the pdb file, call
#' # it align.pdb
#'
#' alignment3dVisulization("align.pdb", "4GSA", "5TE2")
#'
#' @export
#' @import rgl
#' @import utils
alignment3dVisualization <- function(alignedPath, targetName, templateName){
  # store output data(should be a list or a column) into a text file
  outputTxt <- function(outputData, fileName){
    myOutput <- outputData
    write.table(myOutput,
                      file = fileName,
                      sep = "", quote = FALSE, eol = "\n",
                      col.names = '', row.names = FALSE)
    return(invisible())
  }

  # read pdb
  index <- grep(pattern = "TER", readLines(alignedPath))
  targetTemp <- grep(pattern = "ATOM[[:space:]]+[0-9]+",
                     readLines(alignedPath)[1:index],
                     value = TRUE)
  for (ta in seq_along(targetTemp)) {
    targetTemp[ta] <- paste0(substring(targetTemp[ta], first = 1, last = 16),
                             "   ", substring(targetTemp[ta], first = 17, last = 38),
                             "   ", substring(targetTemp[ta], first = 39, last = 46),
                             "   ", substring(targetTemp[ta], first = 47, last = 60),
                             "   ", substring(targetTemp[ta], first = 61))
  }
  templateTemp <- grep(pattern = "ATOM[[:space:]]+[0-9]+",
                       readLines(alignedPath)[index:length(readLines(alignedPath))],
                       value = TRUE)
  for (te in seq_along(templateTemp)) {
    templateTemp[te] <- paste0(substring(templateTemp[te], first = 1, last = 16),
                               "   ", substring(templateTemp[te], first = 17, last = 38),
                               "   ", substring(templateTemp[te], first = 39, last = 46),
                               "   ", substring(templateTemp[te], first = 47, last = 60),
                               "   ", substring(templateTemp[te], first = 61))
  }
  outputTxt(outputData = targetTemp,
            fileName = paste0(targetName, ".txt"))
  outputTxt(outputData = templateTemp,
            fileName = paste0(templateName, ".txt"))
  targetTemp <- read.table(file = paste0(targetName, ".txt"),
                           col.names = c("ATOM", "num", "info1", "amino acid",
                                         "chainID", "amino acid number",
                                         "x", "y", "z"))
  templateTemp <- read.table(file = paste0(templateName, ".txt"),
                             col.names = c("ATOM", "num", "info1", "amino acid",
                                           "chainID", "amino acid number",
                                           "x", "y", "z"))

  # draw a 3D plot
  xTa <- targetTemp$x
  yTa <- targetTemp$y
  zTa <- targetTemp$z
  xTe <- templateTemp$x
  yTe <- templateTemp$y
  zTe <- templateTemp$z
  rgl_init <- function(){
    if (rgl::rgl.cur() == 0) {
      rgl::rgl.open()
      rgl::par3d(windowRect = 50 + c(0, 0, 640, 640))
      rgl::rgl.bg(color = "white")
    }
    rgl::rgl.clear(type = c("shapes", "bboxdeco"))
    rgl::rgl.viewpoint(theta = 10, phi = 10, zoom = 1)
  }
  rgl_init()
  rgl::lines3d(xTa, yTa, zTa, r = 0.3, color = "red", alpah = 0.5)
  rgl::lines3d(xTe, yTe, zTe, r = 0.3, color = "blue", alpha = 0.5)

  #remove temperary files
  unlink(paste0(targetName, ".txt"))
  unlink(paste0(templateName, ".txt"))

  return()
}

# [END]



