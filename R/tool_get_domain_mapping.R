#' tool_get_domain_mapping
#'
#' @param domain set
#' @param file Mapping file
#'
#' @return Mapping object for IMPACT framework
#' @importFrom readxl read_xlsx excel_sheets
#' @export
#'
#' @examples
#' \dontrun{
#' tool_get_mapping()
#' }
#' @author Abhijeet Mishra

tool_get_domain_mapping <- function(domain = NULL,
                             file = "mapping_items.xlsx") {
  sheet = "domain_pointer"
  fpath <- system.file("extdata", file, package = "DOORMAT")
  mapping <- read_xlsx(path = fpath,
                       sheet = sheet)
  sheet <- mapping$Sheet[mapping$Domain == domain]
  if(is_empty(sheet) && !(domain %in% c('lvsys','h','fctr','lnd'))) stop("'",domain, "' not found in mapping")
  return(sheet)
}
