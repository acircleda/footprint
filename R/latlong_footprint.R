#' Calculate flight emissions based on longitude and latitude pairs
#'
#' @description   A function that calculates emissions per flight based on longitude and latitude, flight classes, and emissions metrics. Emissions are returned in kilograms of the chosen metric.
#'
#' @param departure_lat a numeric vector of one or more latitudes for departure location
#' @param departure_long a numeric vector of one or more longitudes for outbound location
#' @param arrival_lat a numeric vector of one or more latitudes for arrival location
#' @param arrival_long a numeric vector of one or more longitudes for arrival location
#' @param flightClass a character vector naming one or more flight class categories. Must be of the following "Unknown" "Economy", "Economy+", "Business" or "First". If no argument is included, "Unknown" is the default and represents the average passenger.
#' @param output {character} emissions metric of the output. For metrics that include radiative forcing, one of
#' - "co2e" (carbon dioxide equivalent with radiative forcing) - default
#' - "co2" (carbon dioxide with radiative forcing)
#' - "ch4" (methane with radiative forcing)
#' - "n2o" (nitrous oxide with radiative forcing)
#' - Metrics without radiative forcing: "co2e_norf", "co2_norf", "ch4_norf", or "n2o_norf".
#' @param year A numeric or string representing a year between 2019-2024, inclusive. Default is 2019.
#' @return a numeric value expressed in kilograms of chosen metric
#' @details Distances between latitude and longitude pairs are based on the Haversine great-circle distance formula, which assumes a spherical earth. The carbon footprint estimates are derived from the Department for Environment, Food & Rural Affairs (UK) Greenhouse Gas Conversion Factors for Business Travel (air). These factors vary by year, which can be acounted for by the `year` argument.
#' @importFrom rlang .data
#'
#' @export
#'
#' @examples
#' # Calculations based on individual flights
#' latlong_footprint(34.052235, -118.243683, 35.179554, 129.075638)
#' latlong_footprint(34.052235, -118.243683, 35.179554, 129.075638, "First")
#' latlong_footprint(34.052235, -118.243683, 35.179554, 129.075638, "First", "ch4")
#' latlong_footprint(34.052235, -118.243683, 35.179554, 129.075638, output = "ch4")
#'
#' # Calculations based on a data frame of flight
#' library(dplyr)
#' library(tibble)
#'
#' travel_data <- tribble(~name, ~departure_lat, ~departure_long, ~arrival_lat, ~arrival_long,
#'      # Los Angeles -> Busan
#'      "Mike", 34.052235, -118.243683, 35.179554, 129.075638,
#'      # New York -> London
#'      "Will", 40.712776, -74.005974, 51.52, -0.10)
#'
#'travel_data |>
#'   rowwise() |>
#'   mutate(emissions = latlong_footprint(departure_lat,
#'                                        departure_long,
#'                                        arrival_lat,
#'                                        arrival_long,
#'                                        output="co2e"))

latlong_footprint <-
  function(departure_lat,
           departure_long,
           arrival_lat,
           arrival_long,
           flightClass = "Unknown",
           output = "co2e",
           year = 2019) {

    # input valudation
    if (!(all(is.numeric(c(departure_long, arrival_long))) &&
          departure_long >= -180 &&
          arrival_long >= -180 &&
          departure_long <= 180 &&
          arrival_long <= 180)) {
      stop("Airport longitude must be numeric and has values between -180 and 180")
    }

    if (!(all(is.numeric(c(departure_lat, arrival_lat))) &&
        departure_lat >= -90 &&
        arrival_lat >= -90 &&
        departure_lat <= 90 &&
        arrival_lat <= 90)) {
      stop("Airport latitude must be numeric and has values between -90 and 90")
    }

    if(as.numeric(year) < min(conversion_factors$year)){
      stop("Argument year must be between the years 2019 to 2024, inclusive")
    }

    if(as.numeric(year) > max(conversion_factors$year)){
      stop("Argument year must be between the years 2019 to 2024, inclusive")
    }

    # calculate distance (method from airportr)
    lon1 = departure_long * pi / 180
    lat1 = departure_lat * pi / 180
    lon2 = arrival_long * pi / 180
    lat2 = arrival_lat * pi / 180
    radius = 6373
    dlon = lon2 - lon1
    dlat = lat2 - lat1
    a = (sin(dlat / 2)) ^ 2 + cos(lat1) * cos(lat2) * (sin(dlon / 2)) ^ 2
    b = 2 * atan2(sqrt(a), sqrt(1 - a))
    distance = radius * b # in km

    year_input <- as.character(year)

    #get distance type (long, short, domestic/medium)
    distance_type <-
      dplyr::case_when(distance <= 483 ~ "short",
                       distance >= 3700 ~ "long",
                       TRUE ~ "medium")

    #find correct calculation value
    emissions_vector <-  conversion_factors |>
      dplyr::filter(.data$year == year_input) |>
      dplyr::filter(.data$distance == distance_type) |>
      dplyr::filter(.data$flightclass == flightClass) |>
      dplyr::pull(output)

    #calculate output
    round(distance * emissions_vector, 3)

  }
