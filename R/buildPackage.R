#' Build package utility
#'
#' @param lib Path to library
#' @param quiet If CMD check output is sent to terminal. Set to TRUE if
#' additional info is not needed
#'
#' @importFrom devtools check document
#' @importFrom pak pkg_install
#' @importFrom utils menu
#' @importFrom rlang is_empty
#' @importFrom usethis use_version
#' @return NULL
#' @export
#' @examples
#' \dontrun{
#' buildPackage()
#' }

buildPackage <- function(lib = ".", quiet = FALSE){
  document(lib)
  cat("Building package silently\n")
  check_package <- check(pkg = lib, document = TRUE,
                         check_dir = tempdir(),
                         cran = FALSE,
                         force_suggests = TRUE,
                         quiet = FALSE)
  errors <- !is_empty(check_package$errors)
  warns  <- !is_empty(check_package$warnings)
  notes  <- !is_empty(check_package$notes)

  check_flag <- any(errors, warns, notes)

  if (check_flag){
    cat(check_package$errors,"\n")
    cat(check_package$warnings,"\n")
    cat(check_package$notes,"\n")
    stop("Building package failed and cannot proceed without fixing above Error(s)/Warning(s)/Note(s)")
  } else if(!check_flag){
    cat("Package check successful\n")
    user_promt <- menu(c("Yes", "No"), title="Would you like to install this package on your computer?")
    if(user_promt==1) {
      use_version()
      pkg_install(pkg=".")
      }
  }
}
