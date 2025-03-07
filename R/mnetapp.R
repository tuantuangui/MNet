#' @title MNet shiny app start function.
#' @description MNet shiny app start function.
#'
#' @return MNet shiny app.
#'
#' @importFrom shiny runApp
#' @export
#'
#' @examples
#' library(MNet)
#' # MNet::mnetapp()
#'
mnetapp <- function() {
  app_path <- system.file("shinyapp", package = "MNet")
  
  if (is.na(app_path)) {
    stop("Shiny app folder not found in the package directory.")
  }
  
  shiny::runApp(appDir = app_path)
}