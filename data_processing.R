### Data processing ----

# load packages 
library(tidyverse)
library(here)

# load data ----
# dispositions data 
dispositions <- read_csv(here("data/Dispositions_20250514.csv")) |> 
  janitor::clean_names()

# initiation data 
initiation <- read_csv(here("data/Initiation_20250514.csv")) |> 
  janitor::clean_names()

# intake data 
intake <- read_csv(here("data/Intake_20250514.csv")) |> 
  janitor::clean_names()

# diversion data 
diversion <- read_csv(here("data/Diversion_20250514.csv")) |> 
  janitor::clean_names()

# sentencing data 
sentencing <- read_csv(here("data/Sentencing_20250514.csv")) |> 
  janitor::clean_names()

# data processing/analysis 
diversion |> 
  # getting rid of cases where diversion_result = NA 
  filter(!is.na(diversion_result)) |> 
  # getting rid of cases where race is unknown 
  filter(!(race == "Unknown")) |> 
  # getting rid of cases where gender is unknown
  filter(!(gender == "Unknown")) |> 
  # making dates usable + adding in year variables
  mutate(received_date = mdy_hms(received_date),
         received_year = year(received_date),
         referral_date = mdy_hms(referral_date),
         referral_year = year(referral_date),
         diversion_closed_date = mdy_hms(diversion_closed_date),
         diversion_closed_year = year(diversion_closed_date),
         # finding time in programs from referral to close
         time = diversion_closed_year - referral_year) |>
  filter(diversion_result == "Graduated") |> 
  count(time) |> 
  arrange(desc(n)) |> 
  view()


# processing steps to explore
# joining data? 
# deciding how to handle NA values // missing data 

  
  
  
  