# CRAN NOTE avoidance
utils::globalVariables(c("aez", "daas"))


.create_dt <- function(x) {
  x <- data.table::rbindlist(lapply(x, stack), idcol = "location")
  return(data.table::dcast(x, location ~ ind, value.var = "values"))
}
