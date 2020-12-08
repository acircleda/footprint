# required packages ----
library(tidyverse)
library(airportr)

# requried data ----

  # from https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2019 - "Conversion factors 2019: full set (for advanced users)" - Business Air Travel tab
load("R/calculations.Rdata")

data(airports) #from `airportr`

# emissions calculations based on airport codes ----

  # example data
  travel_data <- data.frame(name=c("Mike", "Will", "Elle"),
                          from=c("LAX", "LGA", "TYS"),
                          to=c("PUS", "LHR", "TPA")
  )

  # function arguments
    # departure = departure city
    # arrival = arrival city
    # flightClass =
      # Unknown (default if blank)
      # Economy
      # Economy+
      # First
      # Business
    # output =
      # co2e (default if blank) - CO2 equivalent
      # co2 - carbon dioxide
      # ch4 - methane
      # n20 - nitrous oxide
        # note: co2e vs co2 https://ecometrica.com/assets/GHGs-CO2-CO2e-and-Carbon-What-Do-These-Mean-v2.1.pdf


    airport_footprint <- function(departure, arrival, flightClass = "Unknown", output = "co2e") {

      #get distance in km
      distance_vector <- airport_distance(departure, arrival)

      #get distance type (long, short, domestic/medium)
      distance_type <- ifelse(distance_vector <= 483, "short",
                              ifelse(distance_vector >= 3700, "long", "medium"))

      #set flight class
      flightclass_vector <- flightClass

      #find correct calculation value
      emissions_table <- calculations %>%
        filter(distance == distance_type) %>%
        filter(flightclass == flightclass_vector) %>%
        select(output) %>%
        rename(output_col = output)

      emissions_vector <- as.vector(emissions_table$output_col)
      emissions_vector


      #calculate
      emissions_calc <- distance_vector*emissions_vector

      #return co2 in metric tons
      emissions_calc

}

  # testing

    travel_data %>%
      rowwise() %>% #anyway to include this in function?
      mutate(emissions = airport_footprint(from, to, output="co2e"))


# emissions calculations based on longitude/lattitude ----

  # example data
  travel_data_latlong <- tribble(~name, ~departure_lat, ~departure_long, ~arrival_lat, ~arrival_long,
        # Los Angeles -> Busan
        "Mike", 34.052235, -118.243683, 35.179554, 129.075638,
        # New York -> London
        "Will", 40.712776, -74.005974, 51.52, -0.10)

  # function

    coord_footprint <- function(departure_lat, departure_long, arrival_lat, arrival_long, flightClass = "Unknown", output = "co2e") {

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
        distance = radius * b

      #get distance in km
      # distance_vector <- d

      #get distance type (long, short, domestic/medium)
      distance_type <- ifelse(distance <= 483, "short",
                              ifelse(distance >= 3700, "long", "medium"))

      #set flight class
      flightclass_vector <- flightClass

      #find correct calculation value
      emissions_table <- conversion_factors %>%
        filter(distance == distance_type) %>%
        filter(flightclass == flightclass_vector) %>%
        select(output) %>%
        rename(output_col = output)

      emissions_vector <- as.vector(emissions_table$output_col)
      emissions_vector


      #calculate
      emissions_calc <- distance*emissions_vector

      #return co2 in metric tons
      emissions_calc

    }

    travel_data_latlong %>%
      rowwise() %>% #anyway to include this in function?
      mutate(emissions = coord_footprint(departure_lat, departure_long, arrival_lat, arrival_long, output="co2e")) %>% view()
