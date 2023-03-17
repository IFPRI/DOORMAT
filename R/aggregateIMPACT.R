#' aggregateIMPACT
#'
#' @param df dataframe from IMPACT results. Likely output of readGDX
#' @param level "reg" Short for regional.
#' result being passed on to this function
#' @param aggr_type sum
#' @param weight Weight by which aggregation can be made
#'
#' @return Country or FPU level aggregation of IMPACT results
#' @importFrom dplyr group_by summarise %>% across all_of
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
    domain_vector <- sapply(df[["domains"]],
                            tool_get_domain_mapping,USE.NAMES = T)
    map_list <- mapply(tool_get_mapping, sheet = domain_vector, USE.NAMES = TRUE)
    dfx  <- df[["data"]]
    for(name in names(map_list)){
      map_dummy <- as.data.frame(map_list[[name]])
      colnames(map_dummy)[1] <- name
      temp <- merge(dfx, map_dummy, by = name)
      if (nrow(temp) != nrow(dfx)) warning(
        "Merge was likley not successful.\nProceed with EXTREME caution")
      dfx <- temp
    }
  }
  if (aggr_type == "sum"){
    aggr_cols <- colnames(dfx)[!(colnames(dfx) %in% c("c","cty","name","world"))]
    dfx <- dfx %>%
      group_by(across(all_of(aggr_cols))) %>%
      summarise(value = sum(.data$value))
    out <- dfx
  }
  return(out)
}
