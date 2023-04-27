#' Build package utility
#'
#' @param lib Path to library
#' @return NULL
#' @importFrom drat insertPackage
#' @export
#' @examples
#' \dontrun{
#' drat_source_build()
#' }
#' @author Abhijeet Mishra

drat_source_build <- function(lib = ".") {
  message("Building source .....")
  devtools::build(pkg = lib, path = lib)
  options(dratBranch = "docs")
  message("Finding source package .....")
  source_file <- grep(pattern = ".tar.gz", x = dir(path = "."), value = TRUE)
  tgz_path <- paste0("./", source_file)
  message("drat magic .....")
  insertPackage(file = tgz_path, repodir = "../drat/")
  message("Cleanup .....")
  file.remove(tgz_path)

  message("Finding drat directory .....")
}
