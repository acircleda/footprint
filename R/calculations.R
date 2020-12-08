#' Calculate emissions per flight distance and type
#'
#' @param departure {character} IATA code for outbound destination
#' @param arrival {character} IATA code for inbound destination
#' @param flightClass {character} flight class category, one of ""Unknown",  "Economy",
#'   "Economy+", "Business" or "First"
#' @param output {character} emissions metric of the output
#'
#' @return numeric
#' @export
#'
#' @examples
#' airport_footprint("LAX", "PUS")
#' airport_footprint("LAX", "PUS", "First")
#' airport_footprint("LAX", "PUS", "First", "ch4")
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
    distance_vector * emissions_vector
  }
