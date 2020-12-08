#' Calculate emissions per flight distance and type using IATA airport codes
#'
#' @param departure {character} IATA code for outbound destination
#' @param arrival {character} IATA code for inbound destination
#' @param flightClass {character} flight class category, one of "Unknown" "Economy", "Economy+", "Business" or "First". If no argument is included, "Unknown" is the default.
#' @param output {character} emissions metric of the output. For metrics that include radiative forcing, one of
#' - "co2e" (carbon dioxide equivalent with radiative forcing) - default
#' - "co2" (carbon dioxide with radiative forcing)
#' - "ch4" (methane with radiative forcing)
#' - "n2o" (nitrous oxide with radiative forcing)
#' - Metrics without radiative forcing: "co2e_norf", "co2_norf", "ch4_norf", or "n2o_norf".
#' #'
#' @return a single numeric value expressed in kilograms
#' @details The carbon footprint estimates are derived from the Department for Environment, Food & Rural Affiars (UK) 2019 Greenhouse Gas Conversion Factors for Business Travel (air): https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2019
#' @export
#'
#' @examples
#' airport_footprint("LAX", "LHR")
#' airport_footprint("LAX", "LHR", "First")
#' airport_footprint("LAX", "LHR", "First", "ch4")
#' airport_footprint("LAX", "LHR", output = "ch4")
#' data %>% rowwise() %>% mutate(co2e = to, from, "Economy")

airport_footprint <-
  function(departure,
           arrival,
           flightClass = "Unknown",
           output = "co2e") {
    #get distance in km
    distance_vector <-
      airportr::airport_distance(departure, arrival)

    #get distance type (long, short, domestic/medium)
    distance_type <-
      dplyr::case_when(distance_vector <= 483 ~ "short",
                       distance_vector >= 3700 ~ "long",
                       TRUE ~ "medium")

    #find correct calculation value
    emissions_vector <-  conversion_factors %>%
      dplyr::filter(distance == distance_type) %>%
      dplyr::filter(flightclass == flightClass) %>%
      dplyr::pull(output)

    #calculate output
    round(distance_vector * emissions_vector,3)
  }
