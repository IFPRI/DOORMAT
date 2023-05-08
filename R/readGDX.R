#' R utility package for reading objects from a GDX file.
#'
#' @param gdx Path to the gdx file
#' @param name name of the parameter being read
#' @param use_model_name Which model name should be shown. Use "IMPACT" for
#' IMPACT results.
#' @param verbosity If additional messages should be printed about variable
#' being read
#'
#' @importFrom dplyr relocate
#' @importFrom utils packageDescription
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

  # GAMS released gamstransfer 1.6 before 1.12 not sure why
  # gasmtransfer 1.6 was release with GAMS 41
  # gasmtransfer 1.12 was released with GAMS 42!

  # Temp bugfix for v1.6 and 1.8 of gamstransfer
  # Force downgrade with one order of magnitude
  if (gt_rev %in% c(1.6, 1.8)) gt_rev <- gt_rev / 10

  m <- gamstransfer::Container$new()

  if (gt_rev >= 1.12) {

    m$read(gdx, name, records = TRUE)
    property_name <- m$listSymbols()
    df <- m[property_name]$records
    colnames(df) <- tolower(c(m[property_name]$domain, "value"))
    df$description <- m[property_name]$description
    domains <- m[property_name]$domain

  } else {

    m$read(gdx, name)

    # Container pulling value is not case sensitive but it will not pull records
    # as that is case sensitive - the list element name is case sensitive

    property_name <- names(m$data)
    df <- m$data[[property_name]]$records
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
