#' Function for getting correct mapping of IFPRI regions (CTY to regions)
#'
#' @param type Defaults to "cty" for country mapping. Choose "fpu" for
#' IMPACT FPU mapping.
#' @param file Mapping file
#' @param sheet Sheet from which data is read. Ideally output of
#' tool_get_domain_mapping function
#' @param sp_mapping Column from Aggregation Regions sheet
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

tool_get_mapping <- function(type = NULL,
                             file = "mapping_items.xlsx",
                             sheet = NULL,
                             sp_mapping = "Standard-IMPACT_dis1") {

  fpath <- system.file("extdata", file, package = "DOORMAT")

  if (!file.exists(fpath)) stop("Could not find ",
                                file,
                                " in DOORMAT package installation on ",
                                .libPaths()[1],
                                "Make sure that the package installtion exists")
  if (!(sheet %in% excel_sheets(path = fpath))) {
    stop("Invalid sheet name. Available sheets - ", excel_sheets(path = fpath))
  }

  if (sheet == "Aggregation Regions") {
    range_vector <- "A8:W166"
    mapping <- read_xlsx(path = fpath,
                         sheet = sheet,
                         range = range_vector,
                         .name_repair = "unique_quiet")

    mapping <- mapping[, c("Cty",
                          "LongName",
                          "Standard-IMPACT_glo",
                          sp_mapping)]
    colnames(mapping) <- c("Country", "Name", "World", "Region")
    } else if (sheet == "Aggregation Crops") {
      range_vector <- "A8:G150"
      mapping <- read_xlsx(path = fpath,
                           sheet = sheet,
                           range = range_vector,
                           .name_repair = "unique_quiet")
      mapping <- mapping[, c("Commodities",
                            "Groups",
                            "Long Name")]
    } else if (sheet == "param_naming") {
      range_vector <- "A1:B49"

      mapping <- read_xlsx(path = fpath,
                           sheet = sheet,
                           range = range_vector,
                           .name_repair = "unique_quiet")
      mapping <- mapping[, c("Parameter",
                            "Description")]
    }

  colnames(mapping) <- tolower(colnames(mapping))
  colnames(mapping) <- gsub(pattern = " ",
                            replacement = "_",
                            x = colnames(mapping))
  return(as.data.frame(mapping))
}
