#' tool_get_mapping
#'
#' @param type Defaults to "cty" for country mapping. Choose "fpu" for
#' IMPACT FPU mapping.
#'
#' @return Mapping object for IMPACT framework
#' @importFrom readxl read_xlsx
#' @export
#'
#' @examples
#' \dontrun{
#' tool_get_mapping()
#' }
#' @author Abhijeet Mishra

tool_get_mapping <- function(type = "cty") {
  fpath <- system.file("extdata", "regional_mapping.xlsx", package = "DOORMAT")

  type_vector <- c("cty",
                  "fpu",
                  "crops",
                  "animals",
                  "livsys")

  range_vector <- c("B8:F194",
                   "H8:L514",
                   "N8:T77",
                   "X8:AC17",
                   "AE8:AI17")

  if (!type %in% c(type_vector)) {
    stop(paste("Invalid `type` selection\n",
               "Available types are ",sep = " "),
         paste(shQuote(type_vector, type="sh"), collapse=", "))
  }

  names(type_vector) <- range_vector

  mapping <- read_xlsx(path = fpath,
                       range = names(type_vector)[type_vector == type])

  return(mapping)
}
