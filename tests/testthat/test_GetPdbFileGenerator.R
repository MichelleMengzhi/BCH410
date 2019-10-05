# test_GetPdbFileGenerator.R



test_that("pdbList.txt exists", {
  cat("4GSA \n", file = "pdbList.txt")
  expect_equal(file.exists("pdbList.txt"), TRUE)
  GetPdbFileGenerator()
  unlink("./templatePDB/4GSA.pdb")
  unlink("templatePDB", recursive = TRUE)
  unlink("pdbList.txt")
})

