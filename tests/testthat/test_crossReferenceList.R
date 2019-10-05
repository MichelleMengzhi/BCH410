# test_crossReference.R

test_that("missing input filepath", {
  mysubject <- Biostrings::readAAStringSet("databaseExample.fasta")
  expect_error(crossReferenceList(mySubject = mysubject),
               "argument \"crossReferenceFile\" is missing, with no default")
})

test_that("The result should be a dataframe", {
  mysubject <- Biostrings::readAAStringSet("databaseExample.fasta")
  expect_is(crossReferenceList("databaseExample.txt", mysubject), "data.frame")
})
