#' Function to aggregate IMPACT results at a specified level
#'
#' @param df Specific IMPACT results as a list object. Likely output of readGDX
#' @param level "reg" Short for regional. "regglo" for regional+global
#' result being passed on to this function
#' @param aggr_type sum or mean
#' @param sp_mapping Column from Aggregation Regions sheet
#' @param keep_cty Overwriting flag for regional aggregation. If set to TRUE,
#' provides only country level data.
#'
#' @return Country or FPU level aggregation of IMPACT results
#' @importFrom dplyr group_by summarise %>% across all_of
#' @export
#' @examples
#' \dontrun{
#' aggregateIMPACT()
#' }
#' @author Abhijeet Mishra

aggregateIMPACT <- function(df = NULL,
                            level = "regglo",
                            aggr_type = "sum",
                            sp_mapping = "CG6",
                            keep_cty = FALSE) {
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
      sheet = valid_domains[[domain_names]],
      sp_mapping = sp_mapping)
  }

  if (keep_cty && "cty" %in% names(map_list)) {
    map_list$cty$region <- map_list$cty$country
  }

  dfx  <- df[["data"]]

  for (name in names(map_list)) {
    map_dummy <- as.data.frame(map_list[[name]])
    if (!("GLO" %in% map_dummy$cty)) {
      map_dummy[nrow(map_dummy) + 1, ] <- rep("GLO", ncol(map_dummy))
    }
    colnames(map_dummy)[1] <- name
    temp <- merge(dfx, map_dummy, by = name, all = TRUE)
    dfx <- temp
  }

  if (aggr_type == "sum") {
    aggr_cols <- colnames(dfx)[
      !(colnames(dfx) %in% c(intersect(names(domain_vector),
                                       names(valid_domains)),
                             "value", "name", "world"))]
    pre_sum <- sum(dfx$value, na.rm = TRUE)
    out <- dfx %>%
      group_by(across(all_of(aggr_cols))) %>%
      summarise(value = sum(value, na.rm = TRUE))
    post_sum <- sum(out$value)
    if (round(pre_sum) != round(post_sum)) {
      stop("Possible error in aggregation.")
    }

    if (level == "regglo") {
      aggr_cols <- aggr_cols[!(aggr_cols %in% "region")]
      if (nrow(out[out$region != "GLO", ]) == 0) {
        return(out)
        stop()
      }
      out_glo <- out %>%
        group_by(across(all_of(aggr_cols))) %>%
        summarise(value = sum(value, na.rm = TRUE))
      out_glo$region <- "GLO"
      out_glo <- out_glo[, colnames(out)]

      out <- rbind(out, out_glo)
    }
  }

  return(out)
}
