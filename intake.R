### Data processing ----

# load packages 
library(tidyverse)
library(here)

# load data ----
# intake data 
intake <- read_csv(here("data/Intake_20250514.csv")) |> 
  janitor::clean_names()


intake |> 
  view()
