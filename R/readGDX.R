#' readGDX
#'
#' @param gdx Path to the gdx file
#' @param name name of the parameter being read
#' @param use_model_name Which model name should be shown. Use "IMPACT" for
#' IMPACT results.
#'
#' @import gdxrrw
#' @importFrom dplyr relocate
#' @return data frame of gdx output result queried
#' @export
#'
#' @examples
#' \dontrun{
#' readGDX()
#' }
#' @author Abhijeet Mishra

readGDX <- function(gdx,name,use_model_name = "IMPACT"){
  value <- model <- NULL
  df <- rgdx.param(gdxName = gdx, symName = name, compress = TRUE)
  colnames(df)[length(colnames(df))] <- "value"
  df$parameter <- name
  df$model <- use_model_name
  colnames(df) <- tolower(colnames(df))
  df <- df %>% relocate(value, .after = model)
  message("Returning model name as '", use_model_name,"'",
          " while reading ", name, " from ",gdx)
  return(df)
}
