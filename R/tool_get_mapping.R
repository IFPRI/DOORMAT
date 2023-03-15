#' tool_get_mapping
#'
#' @param type Defaults to "cty" for country mapping. Choose "fpu" for
#' IMPACT FPU mapping.
#' @param file Mapping file
#' @param sheet Sheet from which data is read.
#' @param sp_mapping Column from Aggregation Regions sheet
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

tool_get_mapping <- function(type = "cty",
                             file = "mapping_items.xlsx",
                             sheet = "Aggregation Regions",
                             sp_mapping = "Standard-IMPACT_dis1") {

  fpath <- system.file("extdata", file, package = "DOORMAT")

  if (!file.exists(fpath)) stop("Could not find ",
                                file,
                                " in DOORMAT package installation on ",
                                .libPaths()[1],
                                "Make sure that the package installtion exists")

  read_mapping_file <- function(fpath, type_vector){
    read_xlsx(path = fpath,
              range = names(type_vector)[type_vector == type],
              sheet = sheet)
  }

  if (sheet == "Classifications") {

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

    names(type_vector) <- range_vector

    if (!type %in% c(type_vector)) {
      stop(paste("Invalid `type` selection\n",
                 "Available types are ",sep = " "),
           paste(shQuote(type_vector, type = "sh"), collapse = ", "))
    }

    mapping <- read_mapping_file(fpath = fpath, type_vector = type_vector)

  } else if (sheet == "Aggregation Regions" && type == "cty") {
    type_vector  <- type
    range_vector <- "A8:T166"
    names(type_vector) <- range_vector
    mapping <- read_mapping_file(fpath = fpath, type_vector = type_vector)
    message("Returning Standard IMPACT regions. Other available options:\n",
            paste(
              colnames(mapping)[-c(1,length(colnames(mapping)))],
              collapse = ", "),"\n",
            "This can be changed by setting sp_mapping.")
    mapping <- mapping[,c("Cty",
                          "LongName",
                          "Standard-IMPACT_glo",
                          sp_mapping)]
    colnames(mapping) <- c("Country","Name","World","Region")
    } else if (sheet == "Aggregation Regions" && type != "cty") {
      stop("'Aggregation Regions' sheet can only be used for cty mapping")
      }
  return(as.data.frame(mapping))
}
