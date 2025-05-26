### Data sets ----

# load packages 
library(tidyverse)
library(here)

# load data ----
# intake data 
intake <- read_csv(here("data/Intake_20250514.csv")) |> 
  janitor::clean_names()

# dispositions data 
dispositions <- read_csv(here("data/Dispositions_20250514.csv")) |> 
  janitor::clean_names()

# initiation data 
initiation <- read_csv(here("data/Initiation_20250514.csv")) |> 
  janitor::clean_names()

# sentencing data 
sentencing <- read_csv(here("data/Sentencing_20250514.csv")) |> 
  janitor::clean_names()