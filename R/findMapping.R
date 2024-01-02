#' Function to get IMPACT mapping for crops, activities, regions(from country)
#' This function is just a glorified file reader as you can provide any mapping
#' you want. See description below.
#'
#' @param name Name of mapping to get.
#' You can provide any name here but the options when using default mapping are
#' \itemize{
#'  \item{"c"}{ --> Crops}
#'  \item{"j"}{ --> Activities}
#'  \item{"cty"}{ --> Countries with 6 CGIAR region mappings}
#' }
#' If using the "multimap" switch for this function. Your mapping MUST have the
#' first column named "type" which should contain the same text as "name"
#' parameter of this function. For example, if the "type" column is filled with
#' "blabla" then the "name" parameter here should also be called "blabla".
#' In default example, for crops, the "type" column is filled with "c" in the
#' default file.
#' @param file Mapping file in excel format. Uses the file provided with this
#' package by default.
#' @param ... All other parameters to be passed on to read_xlsx function for
#' reading the excel file of mapping using read_xlsx. See ?read_xlsx.
#' @param multimap If the mapping file contains multiple mappings in single
#' file. See the "default_mappings.xlsx" file provided with this package for
#' example. There, single excel file contains "j", "c" and "cty" mappings. You
#' have to stick to naming conventions described above if you activate this
#' switch. Defaults to FALSE. Set it to TRUE if using multiple mapping in 1 file
#' If "multimap" is set to TRUE, your mapping MUST have the
#' first column named "type" which should contain the same text as "name"
#' parameter of this function. For example, if the "type" column is filled with
#' "blabla" then the "name" parameter here should also be called "blabla".
#' In default example, for crops, the "type" column is filled with "c" in the
#' default file.
#'
#' @export
#' @examples
#' \dontrun{
#' getMapping(name = "c")
#' }
#' @author Abhijeet Mishra

findMapping <- function(name = NULL,
                        file = "default_mappings.xlsx",
                        multimap = FALSE, # Set as FALSE even for default map
                        ...) {
  if (file == "default_mappings.xlsx")  {
    fpath <- system.file("extdata", file, package = "DOORMAT")
    multimap <- TRUE
    message("Forced multimap to be TRUE for default mapping")
    } else {
      if (multimap && is.null(name)) {
        message("Looks like you are using your own mapping.")
        warning("multimap option is set to TRUE.")
        warning("Make sure to add a 'type' column to your mapping.")
        warning("See function description for details.")
        warning("If this does not apply, set multimap to FALSE.")
      }
      fpath <- file
    }

  grab_data <- function(fpath, ...) {
    mapping <- read_xlsx(path = fpath, ...)
    colnames(mapping) <- tolower(colnames(mapping))
    return(mapping)
  }

  mapping <- grab_data(fpath = fpath, ...)

  if (multimap) {
    # Subset and then kick out column which is not needed
    mapping <- mapping[mapping$type == name, -1]
  }

  if (!is.null(name)) message("Returning '", name, "' mapping.")
  if (is.null(name)) message("Returning user specified mapping.")
  return(mapping)
}
