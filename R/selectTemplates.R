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
#' Select template sequences for given target sequence
#' from given sequence database.
#'
#' @param targetSequence The filepath of target sequence.
#' @param databaseSequences The filepath of sequence database.
#' @param crossReference The filepath of database sequences in text file
#' with only entry and cross reference information.
#' @return return nothing but output:
#' \itemize{
#' \item A Visualization of pairwise alignment of selected templates
#' and target sequences in html.
#' \item Corresponding online pdb files in local
#' \item Corresponding alignment files in local
#' }
#' @examples
#' # Go to UniPort, download protein A3SNF5 sequence in fasta as the target
#' # sequence (targetExample.fasta); its IPR005814 family entry database
#' # in fasta and text that is reviewed and has 3D structure with pdb
#' # (databaseExample.fasta, databaseExample.txt).
#'
#' selectTemplates("targetExample.fasta", "databaseExample.fasta",
#'                 "databaseExample.txt")
#'
#' @export
#' @importFrom Biostrings readAAStringSet pairwiseAlignment BStringSet
#' AAStringSet writeXStringSet
#' @import DECIPHER
#'
selectTemplates <- function(targetSequence, databaseSequences,
                            crossReference) {
  # input error check
  if (is.na(targetSequence)
      | is.na(databaseSequences)
      | is.na(crossReference)) {
    stop("Need input!")
  }

  # store output data(should be a list or a column) into a text file
  outputTxt <- function(outputData, fileName){
    myOutput <- outputData
    write.table(myOutput,
                file = fileName,
                sep = "", quote = FALSE, eol = "\n",
                col.names = '', row.names = FALSE)
    return(invisible())
  }

  # prepare fasta file
  myPattern <- Biostrings::readAAStringSet(targetSequence)
  mySubject <- Biostrings::readAAStringSet(databaseSequences)

  # target entry name
  targetEntryName <- c(myPattern@ranges@NAMES)
  subjectEntryName <- c(mySubject@ranges@NAMES)

  # create a data frame for alignmentd data storing
  afterPairwiseAlign <- data.frame("names" = subjectEntryName,
                                   "pattern" = character(length(mySubject)),
                                   "subjects" = character(length(mySubject)),
                                   "scores" = numeric(length(mySubject)),
                                   stringsAsFactors = FALSE
  )

  # create cross reference dataframe to get entry corresponding pdb name
  crossReferenceDataframe <- crossReferenceList(crossReferenceFile = crossReference,
                                                mySubjectClass = mySubject)

  # do pairwise alignment for each protein from database
  # store their scores and their alignment files
  for (i in seq_along(mySubject)) {
    align <- Biostrings::pairwiseAlignment(pattern = myPattern,
                                           subject = mySubject[i],
                                           substitutionMatrix = "BLOSUM62")
    afterPairwiseAlign[i, "pattern"] <- c(toString(align@pattern))
    afterPairwiseAlign[i, "subjects"] <- c(toString(align@subject))
    afterPairwiseAlign[i, "scores"] <- align@score
    afterPairwiseAlign[i, "pdb"] <- crossReferenceDataframe[afterPairwiseAlign[i, "names"],2]
  }
  rownames(afterPairwiseAlign) <- afterPairwiseAlign[ , 1]

  # get TOP 5 scores sequence information and store them into directory templatePDB
  topFiveScores <- afterPairwiseAlign[order(-afterPairwiseAlign$scores),][c(1:5), ]
  outputTxt(outputData = topFiveScores$pdb, fileName = "pdbList.txt")
  GetPdbFileGenerator()
  unlink("pdbList.txt")

  # output a visualization of the results of
  # pairwise alignment of top 5 templates and the target
  for (b in seq_along(topFiveScores)) {
    seq <- c(Biostrings::BStringSet(topFiveScores$pattern[b]),
             Biostrings::BStringSet(topFiveScores$subjects[b]) )
    DECIPHER::BrowseSeqs(seq)
    Sys.sleep(1)
  }

  # a function output the entry path
  outputFilePath <- function(fileName) {
    return(paste0(fileName,".ali"))
  }

  # create a directory to store all alignment files
  dir.create("alignmentFiles")

  # stores top 5 into .ali file with proper format to alignmentFiles
  # and a template pdb names list
  targetInsert <- paste0("sequence:", targetEntryName,
                         ":.:.:.:.:.:::")
  alignFileName <- character(0)
  for (r in seq_along(topFiveScores$names)) {
    writeDown <- Biostrings::AAStringSet(c(topFiveScores$pattern[r],
                                           topFiveScores$subjects[r]))
    names(writeDown)[1] <- c(targetEntryName)
    names(writeDown)[2] <- c(toString(topFiveScores[r, "pdb"]))
    Biostrings::writeXStringSet(writeDown, outputFilePath(names(writeDown)[2]))
    templateInsert <- paste0("structureX:", topFiveScores$pdb[r],
                             ":.:.:.:.:.:::")
    file <- readLines(pathGeneratorMovement(fileName = outputFilePath(names(writeDown)[2])))
    chunkTwo <- grep(topFiveScores$pdb[r], file)
    ali <- c(paste0(">", "P1;", gsub(">", "", file[1])), targetInsert,
             file[2:(chunkTwo - 2)], paste0(file[chunkTwo - 1],"*"), " ",
             paste0(">", "P1;", gsub(">", "", file[chunkTwo])),
             templateInsert, file[(chunkTwo+1):(length(file)-1)],
             paste0(file[length(file)], "*"))
    write.table(ali, file = outputFilePath(names(writeDown)[2]),
                eol = "\n", quote = FALSE,
                 col.names = "", row.names = FALSE)
    pathGeneratorMovement(fileName = outputFilePath(names(writeDown)[2]),
                          destination = "alignmentFiles", move = TRUE)
    alignFileName <- c(alignFileName, names(writeDown)[2])
  }

  return()
}

#[END]

