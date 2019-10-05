# test_alignment3dVisualization.R

test_that("user given proper pdb file", {
  expect_equal(length(grep("TER", readLines("alignedExample.pdb"))), 1)
})

test_that("user given non string argument", {
  expect_error(alignment3dVisualization("alignedExample.pdb", A3SNF5, GSA),
               "object 'A3SNF5' not found")
  expect_error(alignment3dVisualization("alignedExample.pdb", A3SNF5, "GSA"),
               "object 'A3SNF5' not found")
  expect_error(alignment3dVisualization("alignedExample.pdb", "A3SNF5", GSA),
               "object 'GSA' not found")
})


