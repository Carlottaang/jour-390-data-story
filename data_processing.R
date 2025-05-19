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

# data processing 
diversion <- diversion |> 
  mutate(
    # changing variable types / formatting of dates 
    referral_date = as.POSIXct(
      referral_date, 
      format = "%m/%d/%Y %I:%M:%S %p"
    ),
    diversion_closed_date = as.POSIXct(
      diversion_closed_date,
      format = "%m/%d/%Y %I:%M:%S %p")
  ) |> 
  # finding number of days between when defendant was referred
  # to a diversion program and when they graduated/failed 
  mutate(
    days_between = as.numeric(
      as.Date(diversion_closed_date) - as.Date(referral_date)
    )
  ) |> 
  # finding years, rounded to two decimal places 
  mutate(
    years = round(days_between / 365, 2) 
  ) |> 
  
 

# breakdown of participants in diversion programs 
diversion |> 
  group_by(diversion_program, race, gender) |> 
  count(offense_category) |> 
  arrange(desc(n)) |> 
  view()

# female participants in programs 
diversion |> 
  filter(gender == "Female") |> 
  count(diversion_program) |> 
  view()

# male participants in programs
diversion |> 
  filter(gender == "Male") |> 
  count(diversion_program) |> 
  view()



# processing steps to explore
# joining data? 
# deciding how to handle NA values // missing data 

  
  
  
  