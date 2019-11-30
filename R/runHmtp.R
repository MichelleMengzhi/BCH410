# 3dAlignment.R
#
# Purpose: run shiny app
# Version: 1.0.0
# Date: 2019-011
# Author: Yuexin Yu
#
# Input: null
# Output: shiny app
# Dependencies: shiny
#
# ===============================================================
#' 3dAlignment
#'
#' Launch the shiny app for package gmtp
#' A function that launches the shiny app for this package.
#' The code has been placed in \code{./inst/shiny-scripts}
#'
#' @return No return value but open up a shiny page
#' @examples
#' \donyrun{
#' runHmtp()
#' }
#'
#' @export
#' @importFrom shiny runApp
#'
runHmtp <- function(){
  appDir <- system.file("", package = "hmtp")
  shiny::runApp(appDir, display.mode = "normal")
  return()
}
