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


  
  