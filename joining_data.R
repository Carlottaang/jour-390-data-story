### Joining data ----

# load packages 
library(tidyverse)
library(here)

# load data 
dispositions <- read_csv(here("data/Dispositions_20250514.csv")) |> 
  janitor::clean_names()

initiation <- read_csv(here("data/Initiation_20250514.csv")) |> 
  janitor::clean_names()

intake <- read_csv(here("data/Intake_20250514.csv")) |> 
  janitor::clean_names()


intake |> 
  filter(case_id == "347835278065") |> view()