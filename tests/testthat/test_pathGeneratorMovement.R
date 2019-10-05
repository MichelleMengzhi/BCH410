# test_pathGeneratorMovement.R

test_that("Corrupt input generates errors", {
  expect_error(pathGeneratorMovement(),
               "argument \"fileName\" is missing, with no default")
})
