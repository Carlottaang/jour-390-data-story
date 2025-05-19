### Data processing ----

# load packages 
library(tidyverse)
library(here)

# load data ----
# intake data 
intake <- read_csv(here("data/Intake_20250514.csv")) |> 
  janitor::clean_names()


# finding number of intake cases that resulted in an approved felony case
intake |> 
    filter(
      felony_review_result == "Approved" | felony_review_result == "Charge(S) Approved"
    ) |> 
    mutate(
      felony_review_year = as.POSIXct(
        felony_review_date, 
        format = "%m/%d/%Y"
      )
    ) 
