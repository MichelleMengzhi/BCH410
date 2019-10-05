# GetPdbFileGenerator.R
#
# Purpose: main function of GetPdbFileGenerator
# Version: 1.0.0
# Date: 2019-09
# Author: Yuexin Yu
#
# Input: No input for the function, but do ensure
# there is a pdbList.txt in current work directory.
# pdbList.txt will be deleted after the execution.
# Output: pdb file in directory templatePDB
# Dependencies: xml2, filesstrings
#
# ===============================================================
#' GetPdbFileGenerator
#'
#' Get pdb file from RCSB website. To run this function
#' induvisually, ensure there is a pdbList.txt in current
#' work directory containing the pdb name. pdbList.txt
#' will be deleted after the execution.
#'
#' @return return nothing but output required pdb files
#' @examples
#' cat("4GSA \n 4A0R \n", file = "pdbList.txt")
#' GetPdbFileGenerator()
#'
#' @export
#' @import xml2
#' @import filesstrings
#' @import utils
#' @import curl
GetPdbFileGenerator <- function () {

  # store the input template PDB list
  templatePDBList <- c("pdbList.txt")

  # a function generating html links and return likes in a character vector
  linkGenerator <- function(list, pattern1, pattern2 = NULL) {
    link <- character(0)
    for (i in seq_along(list$pdb)) {
      link <- c(link, paste0(pattern1, as.character(list$pdb[i]),pattern2))
    }
    return(link)
  }

  # read the input list, generate the link for the capture of pdb file
  # and store them in one directory
  pdbList <- read.table(templatePDBList, col.names = c("pdb"))
  dir.create("templatePDB")                                                    # create a directory in the work directory
                                                                               # for storing all template pdb files
  links <- linkGenerator(pdbList,
                         pattern1 = "https://files.rcsb.org/view/",
                         pattern2 = ".pdb")
  for (lk in seq_along(links)) {
    xml2::download_html(links[lk])
    pathGeneratorMovement(fileName = pdbList$pdb[lk], suffix = ".pdb",
                          destination = "templatePDB", move = TRUE)
  }
  return()
}

# [END]
