# test_selectTemplate.R


test_that("Corrupt input generates errors", {
  expect_error(selectTemplates(),
               "argument \"targetSequence\" is missing, with no default")
  expect_error(selectTemplates("wrong_path",
                               "databaseExample.fasta", "databaseExample.txt"),
                               "cannot open file 'wrong_path'")
  expect_error(selectTemplates("targetExample.fasta", "wrong_path",
                               "databaseExample.txt"),
                               "cannot open file 'wrong_path'")
  expect_error(selectTemplates("wrong_path",
                               "databaseExample.fasta", "wrong_path"),
                               "cannot open file 'wrong_path'")
})

