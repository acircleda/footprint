## code to prepare `DATASET` dataset goes here

library(tidyverse)

# create base data
distances <- c("short", "medium", "long", "international")

flightclasses <- c("Unknown", "Economy", "Economy+", "Business", "First")

base_columns <- expand.grid(distance=distances, flightclass  = flightclasses) |>
  mutate(distance = factor(distance, levels=distances),
         flightclass = factor(flightclass,
                              levels=flightclasses)) |>
  arrange(distance, flightclass)

cols <- c("co2e","co2","ch4","n2o","co2e_norf", "co2_norf","ch4_norf","n2o_norf")

# process 2019 data from https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2019

data_2019_raw <- readxl::read_excel(
  "reference/ghg-conversion-factors-2019-condensed-set-v01-02.xls",
  sheet = "Business travel- air", skip=21)


data_2019_processed <- data_2019_raw |>
  slice(1:14) |>
  mutate(distance = case_when(
    Haul == "Domestic, to/from UK" ~ "short",
    Haul == "Short-haul, to/from UK" ~ "medium",
    Haul == "Long-haul, to/from UK" ~ "long",
    Haul == "International, to/from non-UK" ~ "international"
  ), .before=1) |>
  fill(distance, .direction="down") |>
  mutate(flightclass = case_when(
    Class == "Average passenger" ~ "Unknown",
    Class == "Economy class" ~ "Economy",
    Class == "Business class" ~ "Business",
    Class == "Premium economy class" ~ "Economy+",
    Class == "First class" ~ "First"
  ), .after=1) |>
  select(-c(Activity, Haul, Class, Unit)) |>
  rename_at(vars(contains("kg")), ~ cols)


data_2019 <- base_columns |>
  left_join(data_2019_processed) |>
  fill(all_of(cols), .direction = "down") |>
  mutate(year = 2019, .before=1)


# process 2020  data from https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2020

data_2020_raw <- readxl::read_excel(
  "reference/Conversion_Factors_2020_-_Condensed_set__for_most_users.xlsx",
  sheet = "Business travel- air", skip=21)


data_2020_processed <- data_2020_raw |>
  slice(1:14) |>
  mutate(distance = case_when(
    Haul == "Domestic, to/from UK" ~ "short",
    Haul == "Short-haul, to/from UK" ~ "medium",
    Haul == "Long-haul, to/from UK" ~ "long",
    Haul == "International, to/from non-UK" ~ "international"
  ), .before=1) |>
  fill(distance, .direction="down") |>
  mutate(flightclass = case_when(
    Class == "Average passenger" ~ "Unknown",
    Class == "Economy class" ~ "Economy",
    Class == "Business class" ~ "Business",
    Class == "Premium economy class" ~ "Economy+",
    Class == "First class" ~ "First"
  ), .after=1) |>
  select(-c(Activity, Haul, Class, Unit)) |>
  rename_at(vars(contains("kg")), ~ cols)


data_2020 <- base_columns |>
  left_join(data_2020_processed) |>
  fill(all_of(cols), .direction = "down") |>
  mutate(year = 2020, .before=1)

# process 2021  data from https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2021

data_2021_raw <- readxl::read_excel(
  "reference/conversion-factors-2021-condensed-set-most-users.xls",
  sheet = "Business travel- air", skip=21)


data_2021_processed <- data_2021_raw |>
  slice(1:14) |>
  mutate(distance = case_when(
    Haul == "Domestic, to/from UK" ~ "short",
    Haul == "Short-haul, to/from UK" ~ "medium",
    Haul == "Long-haul, to/from UK" ~ "long",
    Haul == "International, to/from non-UK" ~ "international"
  ), .before=1) |>
  fill(distance, .direction="down") |>
  mutate(flightclass = case_when(
    Class == "Average passenger" ~ "Unknown",
    Class == "Economy class" ~ "Economy",
    Class == "Business class" ~ "Business",
    Class == "Premium economy class" ~ "Economy+",
    Class == "First class" ~ "First"
  ), .after=1) |>
  select(-c(Activity, Haul, Class, Unit)) |>
  rename_at(vars(contains("kg")), ~ cols)


data_2021 <- base_columns |>
  left_join(data_2021_processed) |>
  fill(all_of(cols), .direction = "down") |>
  mutate(year = 2021, .before=1)

# process 2022  data from https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2022

data_2022_raw <- readxl::read_excel(
  "reference/ghg-conversion-factors-2022-condensed-set.xls",
  sheet = "Business travel- air", skip=21)


data_2022_processed <- data_2022_raw |>
  slice(1:14) |>
  mutate(distance = case_when(
    Haul == "Domestic, to/from UK" ~ "short",
    Haul == "Short-haul, to/from UK" ~ "medium",
    Haul == "Long-haul, to/from UK" ~ "long",
    Haul == "International, to/from non-UK" ~ "international"
  ), .before=1) |>
  fill(distance, .direction="down") |>
  mutate(flightclass = case_when(
    Class == "Average passenger" ~ "Unknown",
    Class == "Economy class" ~ "Economy",
    Class == "Business class" ~ "Business",
    Class == "Premium economy class" ~ "Economy+",
    Class == "First class" ~ "First"
  ), .after=1) |>
  select(-c(Activity, Haul, Class, Unit)) |>
  rename_at(vars(contains("kg")), ~ cols)


data_2022 <- base_columns |>
  left_join(data_2022_processed) |>
  fill(all_of(cols), .direction = "down") |>
  mutate(year = 2022, .before=1)

# process 2023  data from https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2023

data_2023_raw <- readxl::read_excel(
  "reference/ghg-conversion-factors-2023-condensed-set-update.xlsx",
  sheet = "Business travel- air", skip=21)


data_2023_processed <- data_2023_raw |>
  slice(1:14) |>
  mutate(distance = case_when(
    Haul == "Domestic, to/from UK" ~ "short",
    Haul == "Short-haul, to/from UK" ~ "medium",
    Haul == "Long-haul, to/from UK" ~ "long",
    Haul == "International, to/from non-UK" ~ "international"
  ), .before=1) |>
  fill(distance, .direction="down") |>
  mutate(flightclass = case_when(
    Class == "Average passenger" ~ "Unknown",
    Class == "Economy class" ~ "Economy",
    Class == "Business class" ~ "Business",
    Class == "Premium economy class" ~ "Economy+",
    Class == "First class" ~ "First"
  ), .after=1) |>
  select(-c(Activity, Haul, Class, Unit)) |>
  rename_at(vars(contains("kg")), ~ cols)


data_2023 <- base_columns |>
  left_join(data_2023_processed) |>
  fill(all_of(cols), .direction = "down") |>
  mutate(year = 2023, .before=1)

# process 2024  data from https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2024

data_2024_raw <- readxl::read_excel(
  "reference/ghg-conversion-factors-2024_condensed_set__for_most_users_.xlsx",
  sheet = "Business travel- air", skip=21)


data_2024_processed <- data_2024_raw |>
  slice(1:14) |>
  mutate(distance = case_when(
    Haul == "Domestic, to/from UK" ~ "short",
    Haul == "Short-haul, to/from UK" ~ "medium",
    Haul == "Long-haul, to/from UK" ~ "long",
    Haul == "International, to/from non-UK" ~ "international"
  ), .before=1) |>
  fill(distance, .direction="down") |>
  mutate(flightclass = case_when(
    Class == "Average passenger" ~ "Unknown",
    Class == "Economy class" ~ "Economy",
    Class == "Business class" ~ "Business",
    Class == "Premium economy class" ~ "Economy+",
    Class == "First class" ~ "First"
  ), .after=1) |>
  select(-c(Activity, Haul, Class, Unit)) |>
  rename_at(vars(contains("kg")), ~ cols)


data_2024 <- base_columns |>
  left_join(data_2024_processed) |>
  fill(all_of(cols), .direction = "down") |>
  mutate(year = 2024, .before=1)


conversion_factors <- rbind(data_2024, data_2023, data_2022, data_2021, data_2020, data_2019)


usethis::use_data(conversion_factors, internal = TRUE, overwrite = TRUE)
