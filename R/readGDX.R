#' readGDX
#'
#' @param gdx Path to the gdx file
#' @param name name of the parameter being read
#' @param use_model_name Which model name should be shown. Use "IMPACT" for
#' IMPACT results.
#'
#' @import gamstransfer
#' @importFrom dplyr relocate
#' @return Parameter and domain of gdx output result queried
#' @export
#'
#' @examples
#' \dontrun{
#' readGDX()
#' }
#' @author Abhijeet Mishra

readGDX <- function(gdx,name,use_model_name = "IMPACT"){
  value <- model <- NULL

  m = Container$new()
  m$read(gdx, name)

  property_name <- names(m$data) # Conatiner pulling value is not case sensitive but it will not pull records as that is case sensitivy - the list element name is case sensitive

  df <- m$data[[property_name]]$records

  colnames(df) <- tolower(c(m$data[[property_name]]$domain, "value"))

  domains <- m$data[[property_name]]$domain
  domains <- tolower(domains[!(domains %in% c("YRS","yrs"))])

  df$model <- use_model_name

  df <- df %>% relocate(value, .after = model)
  message("Returning model name as '", use_model_name,"'",
          " while reading '", name, "' from\n",gdx)
  out_list <- list()
  out_list[["data"]] <- df
  out_list[["domains"]] <- domains
  return(out_list)
}
