### Fact checking ----

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



# data visualization one 
foia_data_2 |> 
  group_by(referral_year) |> 
  filter(referral_year > 2010) |> 
  count() |> 
  view()

foia_data_2 |> 
  filter(diversion_closed_year > 2010) |> 
  group_by(diversion_closed_year) |> 
  filter(diversion_result == "Graduated") |> 
  count() |> 
  view()

foia_data_2 |> 
  filter(diversion_closed_year > 2010) |> 
  group_by(diversion_closed_year) |> 
  filter(diversion_result == "Failed") |> 
  count() |> 
  view()

















