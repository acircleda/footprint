#' Calculate emissions per flight distance and type using latitude and longitude
#'
#' @param departure_lat {numeric} latitude of outbound destination
#' @param departure_long {numeric} longitude of outbound destination
#' @param arrival_lat {numeric} latitude of inbound destination
#' @param arrival_long {numeric} longitude of inbound destination
#' @param flightClass {character} flight class category, one of "Unknown" "Economy", "Economy+", "Business" or "First". If no argument is included, "Unknown" is the default.
#' @param output {character} emissions metric of the output. For matrics that include radiative forcing, one of
#' - "co2e" (carbon dioxide equivalent with radiative forcing) - default
#' - "co2" (carbon dioxide with radiative forcing)
#' - "ch4" (methane with radiative forcing)
#' - "n20" (nitrous oxide with radiative forcing)
#' - Metrics without radiative forcing: "co2e_norf", "co2_norf", "ch4_norf", or "n02_norf".
#' #'
#' @return a single numeric value expressed in kilograms
#' @details The carbon footprint estimates are derived from the Department for Environment, Food & Rural Affiars (UK) 2019 Greenhouse Gas Conversion Factors for Business Travel (air): https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2019
#' @export
#'
#' @examples
#' latlong_footprint(34.052235, -118.243683, 35.179554, 129.075638)
#' latlong_footprint(34.052235, -118.243683, 35.179554, 129.075638, "First")
#' latlong_footprint(34.052235, -118.243683, 35.179554, 129.075638, "First", "ch4")
#' latlong_footprint("34.052235, -118.243683, 35.179554, 129.075638, output = "ch4")
#' data %>% rowwise() %>% mutate(co2e = from_lat, from_long, to_lat, to_long, "Economy")

latlong_footprint <- function(departure_lat, departure_long, arrival_lat, arrival_long, flightClass = "Unknown", output = "co2e") {

  # calculate distance (method from airportr)

  lon1 = departure_long * pi/180
  lat1 = departure_lat * pi/180
  lon2 = arrival_long * pi/180
  lat2 = arrival_lat * pi/180
  radius = 6373
  dlon = lon2 - lon1
  dlat = lat2 - lat1
  a = (sin(dlat/2))^2 + cos(lat1) * cos(lat2) * (sin(dlon/2))^2
  b = 2 * atan2(sqrt(a), sqrt(1 - a))
  distance = radius * b # in km

  #get distance type (long, short, domestic/medium)
  distance_type <-
    dplyr::case_when(distance <= 483 ~ "short",
                     distance >= 3700 ~ "long",
                     TRUE ~ "medium")

  #set flight class
  flightclass_vector <- flightClass

  #find correct calculation value
  emissions_vector <-  conversion_factors %>%
    dplyr::filter(distance == distance_type) %>%
    dplyr::filter(flightclass == flightClass) %>%
    dplyr::pull(output)

  #calculate output
  round(distance * emissions_vector,3)

}
