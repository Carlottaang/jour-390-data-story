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

foia_data |> 
  group_by(diversion_program) |> 
  count(offense_category) |> 
  arrange(desc(n)) |> 
  view()
