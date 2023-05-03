#' Build package utility for DRAT linkage of IFPRI R packages
#'
#' @param lib Path to library
#' @return NULL
#' @importFrom drat insertPackage
#' @importFrom git2r add commit
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

  keep_path <- getwd()

  message("Temporarliy moving to drat directory .....")
  new_path <- "../drat/"
  setwd(new_path)
  add(path = ".")
  commit(all = TRUE, message = paste0("DRAT update", tgz_path))
  # Use new key formats - only for DRAT
  # https://stackoverflow.com/a/62278407
  # git config --add --local core.sshCommand 'ssh -i <<<PATH_TO_SSH_KEY>>>'
  # push(object = ".")
  setwd(keep_path)
}
