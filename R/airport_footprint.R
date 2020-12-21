#' Calculate flight emissions based on airport code pairs
#'
#'@description A function that calculates emissions per flight based on pairs of three-letter airport codes, flight classes, and emissions metrics. Emissions are returned in kilograms of the chosen metric.
#'
#' @param departure a character vector naming one or more three-letter IATA (International Air Transport Association) airport codes for outbound destination
#' @param arrival a character vector naming one or more three-letter IATA (International Air Transport Association) airport codes for inbound destination
#' @param flightClass a character vector naming one or more flight class categories. Must be of the following "Unknown" "Economy", "Economy+", "Business" or "First". If no argument is included, "Unknown" is the default and represents the average passenger.
#' @param output a single character argument naming the emissions metric of the output. For metrics that include radiative forcing, one of
#' - "co2e" (carbon dioxide equivalent with radiative forcing) - default
#' - "co2" (carbon dioxide with radiative forcing)
#' - "ch4" (methane with radiative forcing)
#' - "n2o" (nitrous oxide with radiative forcing)
#' - Metrics without radiative forcing: "co2e_norf", "co2_norf", "ch4_norf", or "n2o_norf".
#'
#' @return a numeric value expressed in kilograms of chosen metric
#' @details Distances between airports are based on the Haversine great-circle distane formula, which assumes a spherical earth. They are calculated using the `airportr` package. The carbon footprint estimates are derived from the Department for Environment, Food & Rural Affairs (UK) 2019 Greenhouse Gas Conversion Factors for Business Travel (air): https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2019
#' @importFrom rlang .data
#' @import airportr
#'
#' @export
#'
#' @examples
#'
#' # Calculations based on individual flights
#' airport_footprint("LAX", "LHR")
#' airport_footprint("LAX", "LHR", "First")
#' airport_footprint("LAX", "LHR", "First", "ch4")
#' airport_footprint("LAX", "LHR", output = "ch4")
#'
#' # Calculations based on a data frame of flights
#' library(dplyr)
#' library(tibble)
#'
#' travel_data <- tribble(~name, ~from, ~to, ~class,
#'                       "Mike", "LAX", "PUS", "Economy",
#'                       "Will", "LGA", "LHR", "Economy+",
#'                       "Elle", "TYS", "TPA", "Business")
#'
#' travel_data %>%
#'    rowwise() %>%
#'    mutate(emissions = airport_footprint(from, to,
#'                                         flightClass = class,
#'                                         output="co2e"))
#'

airport_footprint <-
  function(departure,
           arrival,
           flightClass = "Unknown",
           output = "co2e") {

    if (!all(is.character(c(departure, arrival)))) {
      stop("Airport IATA codes must be a character string")
    }

    if (!all(nchar(c(departure, arrival)) %in% 2:3)) {
      stop("Invalid IATA codes: make sure they consist of no more than 3 characters")
    }

    if (!all(grepl("^([A-Za-z]{2,3})", c(departure, arrival)))) {
      stop("Invalid IATA codes: make sure they consist only of letters")
    }

    departure <- toupper(departure)
    arrival <- toupper(arrival)

    #get distance in km
    suppressWarnings(distance_vector <-
                       airportr::airport_distance(departure, arrival))

    #get distance type (long, short, domestic/medium)
    distance_type <-
      dplyr::case_when(distance_vector <= 483 ~ "short",
                       distance_vector >= 3700 ~ "long",
                       TRUE ~ "medium")

    #find correct calculation value
    emissions_vector <-  conversion_factors %>%
      dplyr::filter(.data$distance == distance_type) %>%
      dplyr::filter(.data$flightclass == flightClass) %>%
      dplyr::pull(output)

    #calculate output
    round(distance_vector * emissions_vector, 3)
  }
