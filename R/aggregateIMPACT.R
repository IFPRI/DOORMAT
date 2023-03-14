#' aggregateIMPACT
#'
#' @param level "cty" or "fpu" - choose according to the dataset of IMPACT
#' result being passed on to this function
#' @param weight Weight by which aggregation can be made
#' @param df dataframe from IMPACT results
#' @param aggr_type sum
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
                            level = "cty",
                            aggr_type = "sum",
                            weight = NULL){
  if (is.null(df)) stop("Nothing passed to the function. Stopping.")
  if (level == "cty") {
    mapping <- tool_get_mapping(type = level)
    df2 <- merge(df,mapping,by.x = "CTY",by.y = "childkey")
    if (nrow(df2) != nrow(df)) warning(
      "Merge was likley not successful.\nProceed with EXTREME caution")
    df2 <- df2 %>%
      group_by(.data$parentkey,
               .data$identifier,
               .data$model,
               .data$variable,
               .data$unit,
               .data$YRS) %>%
      summarise(value = sum(.data$value))
  }
}
