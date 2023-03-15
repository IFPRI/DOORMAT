#' aggregateIMPACT
#'
#' @param df dataframe from IMPACT results. Likely output of readGDX
#' @param level "reg" Short for regional.
#' result being passed on to this function
#' @param aggr_type sum
#' @param weight Weight by which aggregation can be made
#'
#' @return Country or FPU level aggregation of IMPACT results
#' @importFrom dplyr group_by summarise %>%
#' @importFrom rlang .data
#' @export
#' @examples
#' \dontrun{
#' aggregateIMPACT()
#' }
#' @author Abhijeet Mishra

aggregateIMPACT <- function(df = NULL,
                            level = "reg",
                            aggr_type = "sum",
                            weight = NULL){
# ****************************************************************************
# Visible binding for global variable fix
  region <- yrs <- groups <- long_name <- parameter <- model <- NULL
# ****************************************************************************

  if (is.null(df)) stop("No dataframe passed to the function. Stopping.")
  if (level == "reg") {
    if ("cty" %in% colnames(df)) {
      mapping <- tool_get_mapping(sheet = "Aggregation Regions",
                                  type = "cty")
      df2 <- merge(df,mapping,
                   by.x = "cty",
                   by.y = "country")
      df2 <- df2[,c(colnames(df),"region")]
      if (nrow(df2) != nrow(df)) warning(
        "Merge was likley not successful.\nProceed with EXTREME caution")
      df <- df2
    }

    if ("c" %in% colnames(df)) {
      mapping <- tool_get_mapping(sheet = "Aggregation Crops")
      df2 <- merge(df,mapping,
                   by.x = "c",
                   by.y = "commodities")
      df2 <- df2[,c(colnames(df),"groups", "long_name")]
      if (nrow(df2) != nrow(df)) warning(
        "Merge was likley not successful.\nProceed with EXTREME caution")
      df <- df2
    }

    if(sum(c("region","groups","long_name") %in% colnames(df))==3){
      df2 <- df %>%
        group_by(region,
                 yrs,
                 groups,
                 long_name,
                 parameter,
                 model) %>%
        summarise(value = sum(.data$value))
      df <- df2
    }
    if(sum(c("groups","long_name") %in% colnames(df))==0){
      df$groups <- NA
      df$long_name <- NA
      df2 <- df %>%
        group_by(region,
                 yrs,
                 groups,
                 long_name,
                 parameter,
                 model) %>%
        summarise(value = sum(.data$value))
      df <- df2
    }
  }

  param_naming <- tool_get_mapping(sheet = "param_naming")
  df2 <- merge(df,param_naming,
               by.x = "parameter",
               by.y = "parameter")
  df2 <- df2[,c(colnames(df),"description")]
  if (nrow(df2) != nrow(df)) warning(
    "Merge was likley not successful.\nProceed with EXTREME caution")
  df <- df2

  out <- df
  return(as.data.frame(out))
}
