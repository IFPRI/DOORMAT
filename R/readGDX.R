#' readGDX
#'
#' @param gdx Path to the gdx file
#' @param name name of the parameter being read
#' @param use_model_name Which model name should be shown. Use "IMPACT" for
#' IMPACT results.
#' @param verbosity If additional messages should be printed about variable
#' being read
#'
#' @importFrom dplyr relocate
#' @return Parameter and domain of gdx output result queried
#' @export
#'
#' @examples
#' \dontrun{
#' readGDX()
#' }
#' @author Abhijeet Mishra

readGDX <- function(gdx, name, use_model_name = "IMPACT", verbosity = FALSE) {
  value <- model <- NULL

  # Grab gamstransfer version
  gt_rev <- as.numeric(packageDescription("gamstransfer")$Version)

  m <- gamstransfer::Container$new()

  if(gt_rev <= 1.12){
    m$read(gdx, name)

    # Container pulling value is not case sensitive but it will not pull records
    # as that is case sensitive - the list element name is case sensitive

    property_name <- names(m$data)
    df <- m$data[[property_name]]$records
    colnames(df) <- tolower(c(m$data[[property_name]]$domain, "value"))
    df$description <- m$data[[property_name]]$description
    domains <- m$data[[property_name]]$domain

  } else {
    m$read(gdx, name, records = TRUE)
    property_name = m$listSymbols()
    df <- m[property_name]$records
    colnames(df) <- tolower(c(m$data[[property_name]]$domain, "value"))
    df$description <- m$data[[property_name]]$description
    domains <- m$data[[property_name]]$domain
  }

  domains <- tolower(domains[!(domains %in% c("YRS", "yrs"))])

  df$model <- use_model_name

  df <- df %>% relocate(value, .after = model)
  if (verbosity) message("Reading '", name, "' from\n", gdx)
  out_list <- list()
  out_list[["data"]] <- df
  out_list[["domains"]] <- domains
  return(out_list)
}
