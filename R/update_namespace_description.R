#' update_namespace_description
#'
#' @param pkg Package directory
#'
#' @importFrom devtools document
#' @importFrom usethis use_latest_dependencies
#'
#' @return NULL
#' @export
#'
#' @examples
#' \dontrun{
#' update_namespace_description()
#' }
#' @author Abhijeet Mishra

update_namespace_description <- function(pkg="."){
  document(pkg=pkg)
  use_latest_dependencies(overwrite=TRUE, source="local")
}
