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

diversion <- read_csv(here("data/Diversion_20250514.csv")) |> 
  janitor::clean_names()

sentencing <- read_csv(here("data/Sentencing_20250514.csv")) |> 
  janitor::clean_names()