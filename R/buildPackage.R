#' Build package utility
#'
#' @param lib Path to library
#' @param quiet If CMD check output is sent to terminal. Set to TRUE if
#' additional info is not needed
#' @param ignore_lintr If lintr should be ignored for readability
#'
#' @importFrom devtools check document
#' @importFrom pak pkg_install
#' @importFrom utils menu
#' @importFrom rlang is_empty
#' @importFrom usethis use_version
#' @importFrom lintr lint_package
#' @importFrom gert git_add git_commit git_push
#' @return NULL
#' @export
#' @examples
#' \dontrun{
#' buildPackage()
#' }
#' @author Abhijeet Mishra

buildPackage <- function(lib = ".", quiet = FALSE, ignore_lintr = FALSE) {
  cat("Running lintr ....\n")
  if (!ignore_lintr) {
    lintr_out <- lintr::lint_package(path = lib)
    if (length(lintr_out) > 0) {
      cat("Run lintr::lint_package('.') to see lintr warnings.\n")
      stop("Please fix lintr issues before proceeding with package build.")
    }
  }
  cat("Updating NAMESPACE and DESCRIPTION\n")
  update_namespace_description(pkg = lib)
  cat("Building package\n")
  check_package <- check(pkg = lib, document = TRUE,
                         check_dir = tempdir(),
                         cran = FALSE,
                         force_suggests = TRUE,
                         quiet = quiet)
  errors <- !is_empty(check_package$errors)
  warns  <- !is_empty(check_package$warnings)
  notes  <- !is_empty(check_package$notes)

  check_flag <- any(errors, warns, notes)

  if (check_flag) {
    cat(check_package$errors, "\n")
    cat(check_package$warnings, "\n")
    cat(check_package$notes, "\n")
    stop("Build package failed, please fix above Error(s)/Warning(s)/Note(s)")
  } else if (!check_flag) {
    cat("Package check successful\n")
    message("Installing package locally ...")
    use_version()
    pkg_install(pkg = lib, ask = FALSE)
    gert::git_add(lib)
    # Use new key formats -
    # https://stackoverflow.com/a/62278407
    gert::git_commit(message = paste0("package update ", check_package$version))
    gert::git_push()
    message("Commit successful .....")
    drat_source_build()
  }
}
