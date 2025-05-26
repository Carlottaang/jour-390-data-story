### Data processing/analysis ----

# load packages 
library(tidyverse)
library(here)

# load data ----
# intake data 
intake <- read_csv(here("data/Intake_20250514.csv")) |> 
  janitor::clean_names()


# data processing/analysis ----
# number of approved felony cases per year 
intake |> 
  # finding number of intake cases that resulted in an approved felony case
    filter(
      felony_review_result == "Approved" | felony_review_result == "Charge(S) Approved"
    ) |> 
  # pulling year out of felony review date 
    mutate(
      felony_review_year = year(mdy(felony_review_date))
    ) |> 
  # filtering for correct years
  filter(felony_review_year > 1970) |>
  filter(felony_review_year < 2030) |> 
  # grouping by year 
  group_by(felony_review_year) |> 
  # finding number of approved felony cases by year 
  summarise(approved_felony_cases = n()) |> 
  arrange(felony_review_year) |> 
  view()


# approved felony (narcotics) cases per year 
intake |> 
  # finding number of intake cases that resulted in an approved felony case
  filter(
    felony_review_result == "Approved" | felony_review_result == "Charge(S) Approved"
  ) |> 
  # pulling year out of felony review date 
  mutate(
    felony_review_year = year(mdy(felony_review_date))
  ) |> 
  # filtering for correct years
  filter(felony_review_year > 1970) |>
  filter(felony_review_year < 2030) |> 
  # grouping by year 
  group_by(felony_review_year, update_offense_category) |> 
  filter(update_offense_category == "Narcotics") |> 
  count(update_offense_category) |> 
  arrange(felony_review_year) |> 
  view()

# offense category counts
intake |> 
  count(offense_category) |> 
  arrange(desc(n)) |> 
  view()

# narcotics = 181,635

# update offense category counts
intake |> 
  count(update_offense_category) |> 
  arrange(desc(n)) |> 
  view()

# narcotics = 184,939

intake |> 
  count(felony_review_result) |> 
  view()

intake |> 
  filter(is.na(felony_review_result)) |> 
  filter(update_offense_category == "Narcotics") |> 
  view()

intake |> 
  filter(update_offense_category == "Narcotics") |> 
  filter(!(felony_review_result == "Rejected")) |> 
  filter(!(felony_review_result == "Disregard")) |> 
  count(felony_review_result) |> 
  view()

intake |> 
  filter(felony_review_result == "Rejected" | felony_review_result == "Disregard") |> 
  count()

intake |> 
  filter(!(felony_review_result == "Rejected") | !(felony_review_result == "Disregard")) |> 
  count()

# cases where offense category changed
intake |> 
  select(offense_category, update_offense_category) |> 
  filter(!(offense_category == update_offense_category)) |> 
  view()












