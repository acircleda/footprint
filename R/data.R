#' Emission conversion factors per flight type.
#'
#' A dataset containing information on emission conversion factors
#' considering flight type and distance flown
#'
#' @format A data frame with 20 rows and 10 variables:
#' \describe{
#'   \item{distance}{flight distance category}
#'   \item{flightclass}{flight class category}
#'   \item{co2e}{}
#'   \item{co2}{}
#'   \item{ch4}{}
#'   \item{n2o}{}
#'   \item{co2e_norf}{}
#'   \item{co2_norf}{}
#'   \item{ch4_norf}{}
#'   \item{n2o-norf}{}
#' }
#' @source \url{https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2019}
"conversion_factors"
