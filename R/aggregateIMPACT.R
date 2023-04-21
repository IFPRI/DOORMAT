#' aggregateIMPACT
#'
#' @param df list object from IMPACT results. Likely output of readGDX
#' @param level "reg" Short for regional. "regglo" fore regional+global
#' result being passed on to this function
#' @param aggr_type sum or mean
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
                            level = "regglo",
                            aggr_type = "sum",
                            weight = NULL) {
  # ****************************************************************************
  # Visible binding for global variable fix
  value <- dfx <- NULL
  # ****************************************************************************

  if (is.null(df)) stop("No dataframe passed to the function. Stopping.")
  if (!(level %in% c("reg", "regglo"))) stop("Invalid aggregation level.")

  domain_vector <- sapply(df[["domains"]],
                          tool_get_domain_mapping, USE.NAMES = TRUE)

  valid_domains <- domain_vector[lapply(domain_vector, length) > 0]

  map_list <- list()
  for (domain_names in names(valid_domains)) {
    map_list[[domain_names]] <- tool_get_mapping(
      sheet = valid_domains[[domain_names]])
  }

  dfx  <- df[["data"]]

  for (name in names(map_list)) {
    map_dummy <- as.data.frame(map_list[[name]])
    if (!("GLO" %in% map_dummy$cty)) {
      map_dummy[nrow(map_dummy) + 1, ] <- rep("GLO", ncol(map_dummy))
    }
    colnames(map_dummy)[1] <- name
    temp <- merge(dfx, map_dummy, by = name)
    if (nrow(temp) != nrow(dfx)) warning(
      "Merge was likley not successful.\nProceed with EXTREME caution")
    dfx <- temp
  }

  if (aggr_type == "sum") {
    aggr_cols <- colnames(dfx)[
      !(colnames(dfx) %in% c(intersect(names(domain_vector),
                                       names(valid_domains)),
                             "value", "name", "world"))]
    pre_sum <- sum(dfx$value)
    out <- dfx %>%
      group_by(across(all_of(aggr_cols))) %>%
      summarise(value = sum(value, na.rm = TRUE))
    post_sum <- sum(out$value)
    if (round(pre_sum) != round(post_sum)
        ) stop(
          "Possible error in aggregation.")

    if (level == "regglo") {
      aggr_cols <- aggr_cols[!(aggr_cols %in% "region")]
      if (nrow(out[out$region != "GLO", ]) == 0) {
        return(out)
        stop()
      }
      pre_sum <- sum(out[out$region != "GLO", ]$value)
      out_glo <- out %>%
        group_by(across(all_of(aggr_cols))) %>%
        summarise(value = sum(value, na.rm = TRUE))
      out_glo$region <- "GLO"
      out_glo <- out_glo[, colnames(out)]
      post_sum <- sum(out_glo[out_glo$region == "GLO", ]$value)
      if (round(pre_sum) != round(post_sum)
      ) stop(
        "Possible error in aggregation.")
      out <- rbind(out, out_glo)
    }
  }

  if (aggr_type == "mean") {
    aggr_cols <-
      colnames(dfx)[!(colnames(dfx) %in% c(intersect(names(domain_vector),
                                                     names(valid_domains)),
                                           "value", "name", "world"))]
    out <- dfx %>%
      group_by(across(all_of(aggr_cols))) %>%
      summarise(value = mean(value))

    if (level == "regglo") {
      aggr_cols <- aggr_cols[!(aggr_cols %in% "region")]
      if (nrow(out[out$region != "GLO", ]) == 0) {
        return(out)
        stop()
      }
      out_glo <- out %>%
        group_by(across(all_of(aggr_cols))) %>%
        summarise(value = mean(value, na.rm = TRUE))
      out_glo$region <- "GLO"
      out_glo <- out_glo[, colnames(out)]
      out <- rbind(out, out_glo)
    }
  }


  return(out)
}
