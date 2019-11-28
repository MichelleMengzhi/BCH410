# crossReferenceList.R
#
# Purpose: main function of crossReferenceList
# Version: 1.0.0
# Date: 2019-09
# Author: Yuexin Yu
#
# Input: text file path, S4 class
# Output: A dataframe with column "entry", "crossReference" which stores
# entry names and their corresponding PDB name
# Dependencies: \
#
# ===============================================================
#' crossReferenceList
#'
#' Create a dataframe storing entries and corresponding cross reference.
#' There might be more than one pdb names for one sequence, the package
#' only pick the last one in given file.
#'
#' @param crossReferenceFile The filepath of sequence database whose
#' sequences have pdb in text.
#' @param mySubjectClass A S4 class storing all information from the
#'  given sequence database in fasta.
#' @return A dataframe with column "entry", "crossReference" which stores
#' entry names and their corresponding PDB name
#' @examples
#' # Go to UniPort, download IPR005814 family entry database in text that is reviewed and has
#' # 3D structure (databaseExample.fasta, databaseExample.txt).
#'
#' mySubject <- Biostrings::readAAStringSet("databaseExample.fasta")
#' crossReferenceList("databaseExample.txt", mySubject)
#'
#' @export
crossReferenceList <- function(crossReferenceFile, mySubjectClass) {
  entryCrossreference <- data.frame("entry" = character(length(mySubjectClass)),
                                    "crossReference" = character(length(mySubjectClass)),
                                    stringsAsFactors = FALSE)
  crossReferenceFilter <- grep(pattern = "DR   SMR; |DR   PDBsum; ", readLines(crossReferenceFile), value = TRUE)
  ct <- 1
  for (l in seq_along(crossReferenceFilter)) {
    if (grepl("SMR", crossReferenceFilter[l]) == TRUE) {
      entryCrossreference$entry[ct] <- c(gsub(' ', '', gsub('; -.', '', gsub('DR   SMR;', '', crossReferenceFilter[l]))))
      ct <- ct+1
    } else {
      entryCrossreference$crossReference[ct] <- c(gsub(' ', '', gsub('; -.', '', gsub('DR   PDBsum;', '', crossReferenceFilter[l]))))
    }
  }
  rownames(entryCrossreference) <- entryCrossreference[ , 1]
  return(entryCrossreference)
}

# [END]


