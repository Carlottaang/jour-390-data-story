### FOIA data ----

# load packages 
library(tidyverse)
library(here)

# load data 
foia_data <- read_csv(here("data/Angiolillo__Carlotta_responsive_docs (3).csv")) |> 
  janitor::clean_names()

# exploring data 
foia_data |> 
  skimr::skim_without_charts() |> 
  view()

# breakdown of participants in diversion programs 
foia_data |> 
  group_by(diversion_program, race, gender) |> 
  count(offense_category) |> 
  arrange(desc(n)) |> 
  view()

# female participants in programs 
foia_data |> 
  filter(gender == "Female") |> 
  count(diversion_program) |> 
  arrange(desc(n)) |> 
  view()

# male participants in programs
foia_data |> 
  filter(gender == "Male") |> 
  count(diversion_program) |> 
  arrange(desc(n)) |> 
  view()


# handling dates
foia_data |> 
  mutate(received_date = mdy_hms(received_date),
         received_year = year(received_date),
         referral_date = mdy_hms(referral_date),
         referral_year = year(referral_date),
         diversion_closed_date = mdy_hms(diversion_closed_date),
         diversion_closed_year = year(diversion_closed_date),
         # finding time in programs from referral to close
         time = diversion_closed_year - referral_year) 
  
  
  