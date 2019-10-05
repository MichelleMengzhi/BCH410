# selectedTemplates.R
#
# Purpose: main function of selectTemplates
# Version: 1.0.0
# Date: 2019-09
# Author: Yuexin Yu
#
# Input: fasta files path, text files path
# Output: Visualization of pairwise alignment of selected
# templates and target sequences; corresponding online pdb
# files in local
# Dependencies: Biostrings, DECIPHER
#
# ===============================================================
#' selectTemplates
#'
#' File movements in disk
#'
#' @param fileName File name(s) in a character vector. It must in
#'  the current work directory. Make sure file(s) exists.
#' @param suffix (optional) A character string representingthe
#'  suffix of the file, or NULL. Default is NULL.
#' @param destination (optional) The directory name if not doing
#' file moving, or the directory path if doing file moving.
#' Default is "". Make sure the destination exists.
#' @param move (optional) A boolean. TRUE for file moving, FALSE
#' for generating file path. Default is FALSE.
#' @return \itemize{
#' \item If move = TRUE, return nothing, but the input file(s)
#'  are moved to the destination
#' \item If move = FALSE, return generated path(s)
#' }
#' @examples
#' # move myFile.txt to C:/Users
#' cat("test", file = "myFile.txt")
#' pathGeneratorMovement(fileName = "myFile", suffix = ".txt",
#'                       destination = "C:/Users/new", move = TRUE)
#' pathGeneratorMovement(fileName = "myFile.txt",
#'                       destination = "C:/Users/new", move = TRUE)
#'
#' # generate file path "C:/Users/new/myFile.txt".
#' pathGeneratorMovement(fileName = "myFile", suffix = ".txt",
#'                       destination = "/new", move = FALSE)
#' pathGeneratorMovement(fileName = "myFile.txt",
#'                       destination = "/new")
#'
#' @export
#' @import filesstrings
pathGeneratorMovement <- function(fileName, suffix = NULL,
                                  destination = "", move = FALSE) {
  if (move != FALSE) {
    FilePath <- paste0(getwd(), '/', fileName, suffix)
    file.move(FilePath, paste0(getwd(), '/', destination))
    return()
  } else {
    FilePath <- paste0(getwd(), '/', destination, '/', fileName, suffix)
  }
  return(FilePath)
}

#[END]
