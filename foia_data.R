### FOIA data ----

# load packages 
library(tidyverse)
library(here)

# load data 
foia_data <- read_csv(here("data/Angiolillo__Carlotta_responsive_docs (3).csv")) |> 
  janitor::clean_names()

# data processing
foia_data_2 <- foia_data |> 
  mutate(
    referral_date = as.Date(referral_date, format = "%m/%d/%Y"),
    referral_year = format(referral_date, "%Y"),
    diversion_closed_date = as.Date(diversion_closed_date, format = "%m/%d/%Y"),
    diversion_closed_year = format(diversion_closed_date, "%Y")
  ) |> 
  # new variable - pre plea vs. post plea programs
  mutate(
    plea = case_when(
      diversion_program %in% c("BR9", "DDPP", "RJCC", "SEED")  ~ "pre",
      diversion_program %in% c("ACT", "DC", "MHC", "VC")  ~ "post"
    ) 
  ) |> 
  # finding number of days between when defendant was referred to a diversion program and when they graduated/failed 
  mutate(
    days_between = as.numeric(
      as.Date(diversion_closed_date) - as.Date(referral_date)
    )
  ) |> 
  # finding years, rounded to two decimal places 
  mutate(
    years = round(days_between / 365, 2) 
  ) |> 
  # categorizing how long people have spent in programs
  mutate(
    one_year = case_when(
      # less than one year 
      years <= 0.99 ~ "less",
      # one year 
      years == 1.00 ~ "one",
      # more than one year 
      years >= 1.01 ~ "more"
    )
  ) 


# data exploration ----
foia_data_2 |> 
  skimr::skim_without_charts() |> 
  view()

# breakdown of participants in diversion programs 
foia_data_2 |> 
  group_by(diversion_program, race, gender) |> 
  count(offense_category) |> 
  arrange(desc(n)) |> 
  view()

# largest programs 
foia_data_2 |> 
  count(diversion_program) |> 
  arrange(desc(n)) |> 
  view()


# female participants in programs 
foia_data_2 |> 
  filter(gender == "Female") |> 
  count(diversion_program) |> 
  arrange(desc(n)) |> 
  view()

# male participants in programs
foia_data_2 |> 
  filter(gender == "Male") |> 
  count(diversion_program) |> 
  arrange(desc(n)) |> 
  view()



# year 
foia_data_2 |> 
  # number of referrals each year 
  count(referral_year) |> 
  # most to least 
  arrange(referral_year) |> 
  view()


foia_data_2 |> 
  # number of closed cases each year 
  count(diversion_closed_year) |> 
  # most to least 
  arrange(desc(n)) |> 
  view()


# number of failed cases every year 
foia_data_2 |> 
  group_by(diversion_closed_year) |>
  filter(diversion_result == "Failed") |> 
  count(diversion_result) |> 
  arrange(diversion_closed_year) |> 
  select(n) |> 
  view()

# number of graduates every year
foia_data_2 |> 
  group_by(diversion_closed_year) |>
  filter(diversion_result == "Graduated") |> 
  count(diversion_result) |> 
  arrange(diversion_closed_year) |> 
  select(n) |> 
  view()



# pre vs. post plea success/failure
diversion |> 
  # setting up to compare pre vs. post plea outcomes
  group_by(plea) |> 
  # number of failures, graduations, current/unknown programs
  count(diversion_result) |> 
  arrange(desc(n)) |> 
  view()

# how long people are in programs, grouped by timing of plea
# pre 
foia_data_2 |> 
  filter(plea == "pre") |> 
  count(one_year) |> 
  arrange(desc(n)) |> 
  view()

# post 
foia_data_2 |> 
  filter(plea == "post") |> 
  count(one_year) |> 
  arrange(desc(n)) |> 
  view()


  
  