
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![R-CMD-check](https://github.com/acircleda/footprint/workflows/R-CMD-check/badge.svg)](https://github.com/acircleda/footprint/actions)
[![Codecov test
coverage](https://codecov.io/gh/acircleda/footprint/branch/master/graph/badge.svg)](https://codecov.io/gh/acircleda/footprint?branch=master)
[![CRAN
status](https://www.r-pkg.org/badges/version/footprint)](https://CRAN.R-project.org/package=footprint)
<!-- badges: end -->

# footprint

<img src="man/figures/footprint_hex.png" align="right" height=150/>

The goal of footprint is to calculate carbon footprints from air travel
based on IATA airport codes or latitude and longitude.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("acircleda/footprint")
```

## Data and Methodology

Package `footprint` uses the the Haversine great-circle distance formula
to calculate distance between airports or distance between latitude and
longitude pairs. This distance is then used to derive a carbon footprint
estimate, which is based on conversion factors from the Department for
Environment, Food & Rural Affairs (UK) 2019 Greenhouse Gas Conversion
Factors for Business Travel (air):
<https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2019>.

## Example Usage

Load `footprint` using

``` r
library(footprint)
library(tidyverse)
#> ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
#> ✔ dplyr     1.1.4     ✔ readr     2.1.5
#> ✔ forcats   1.0.0     ✔ stringr   1.5.1
#> ✔ ggplot2   3.5.1     ✔ tibble    3.2.1
#> ✔ lubridate 1.9.3     ✔ tidyr     1.3.1
#> ✔ purrr     1.0.2     
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()
#> ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```

### Using Airport Codes

You can use pairs of three-letter IATA airport codes to calculate
distance. This function uses the
[`airportr`](https://github.com/dshkol/airportr) package, which contains
the data and does the work of getting the distance between airports.
*Note*: the `airportr` package offers a number of useful functions for
looking up airports by city or name and getting the IATA airport codes.

#### Calculating a Single Trip

The example below calculates a simple footprint estimation for an
economy flight from Los Angeles International (LAX) to Heathrow (LHR).
The estimate will be in CO<sub>2</sub>e (carbon dioxide equivalent,
including radiative forcing). The output is always in kilograms.

``` r
airport_footprint("LAX", "LHR", "Economy", "co2e")
#> [1] 1312.696
```

If there is a layover in Chicago, you could calculate each leg of the
trip as follows:

``` r
airport_footprint("LAX", "ORD", "Economy", "co2e") + 
  airport_footprint("ORD", "LHR", "Economy", "co2e")
#> [1] 1387.167
```

#### Calculating More than One Trip

We can calculate the footprint for multiple itineraries at the same time
and add to an existing data frame using `mutate`. Here is some example
data:

``` r
library(tibble)

travel_data <- tibble(
  name = c("Mike", "Will", "Elle"),
  from = c("LAX", "LGA", "TYS"),
  to = c("PUS", "LHR", "TPA")
)
```

| name | from | to  |
|:-----|:-----|:----|
| Mike | LAX  | PUS |
| Will | LGA  | LHR |
| Elle | TYS  | TPA |

Here is how you can take the `from` and `to` data and calculate
emissions for each trip. The following function calculates an estimate
for CO<sub>2</sub> (carbon dioxide with radiative forcing).

| name | from | to  | emissions |
|:-----|:-----|:----|----------:|
| Mike | LAX  | PUS |  1434.663 |
| Will | LGA  | LHR |   825.497 |
| Elle | TYS  | TPA |   136.721 |

#### Calculating More than One Trip and Different years

We can calculate the footprint for multiple itineraries at the same time
and add to an existing data frame using `mutate`. Here is some example
data:

``` r
library(tibble)

travel_data <- tibble(
  name = c("Mike", "Will", "Elle", "Elle"),
  from = c("LAX", "LGA", "TYS", "TYS"),
  to = c("PUS", "LHR", "TPA", "TPA"),
  date = c("2024-04-05", "2023-04-02", "2024-06-12", "2019-06-12")
)
```

| name | from | to  | date       | emissions |
|:-----|:-----|:----|:-----------|----------:|
| Mike | LAX  | PUS | 2024-04-05 |  1916.380 |
| Will | LGA  | LHR | 2023-04-02 |  1102.675 |
| Elle | TYS  | TPA | 2024-06-12 |   160.553 |
| Elle | TYS  | TPA | 2019-06-12 |   136.721 |

## From Latitude and Longitude

If you have a list of cities, it might be easier to calculate emissions
based on longitude and latitude rather than trying to locate the
airports used. For example, one could take city and state data and join
that with data from `maps::us.cities` to quickly get latitude and
longitude. They can then use the `latlong_footprint()` function to
easily calculate emissions based on either a single itinerary or
multiple itineraries:

### Calculating a Single Trip

The following example calculates the footprint of a flight from Los
Angeles (34.052235, -118.243683) to Busan, South Korea (35.179554,
129.075638). It assumes an average passenger (no `flightClass` argument
is included) and its output will be in kilograms of CO<sub>2</sub>e (the
default)

``` r
latlong_footprint(34.052235, -118.243683, 35.179554, 129.075638)
#> [1] 1881.589
```

### Calculating Multiple Trips

You can use `mutate` to calculate emissions based on a dataframe of
latitude and longitude pairs.

Here is some example data:

``` r
travel_data2 <- tribble(~name, ~departure_lat, ~departure_long, ~arrival_lat, ~arrival_long,
         # Los Angeles -> Busan
        "Mike", 34.052235, -118.243683, 35.179554, 129.075638,
        # New York -> London
        "Will", 40.712776, -74.005974, 51.52, -0.10)
```

| name | departure_lat | departure_long | arrival_lat | arrival_long |
|:-----|--------------:|---------------:|------------:|-------------:|
| Mike |      34.05224 |     -118.24368 |    35.17955 |     129.0756 |
| Will |      40.71278 |      -74.00597 |    51.52000 |      -0.1000 |

And here is code to apply it to a dataframe:

``` r
travel_data2 |>
  rowwise() |>
  mutate(emissions = latlong_footprint(departure_lat,
                                       departure_long,
                                       arrival_lat,
                                       arrival_long))
```

| name | departure_lat | departure_long | arrival_lat | arrival_long | emissions |
|:-----|--------------:|---------------:|------------:|-------------:|----------:|
| Mike |      34.05224 |     -118.24368 |    35.17955 |     129.0756 |  1881.589 |
| Will |      40.71278 |      -74.00597 |    51.52000 |      -0.1000 |  1090.260 |
