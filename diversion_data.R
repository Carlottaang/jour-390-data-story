### Data processing ----

# load packages 
library(tidyverse)
library(here)

# load data ----
diversion <- read_csv(here("data/Diversion_20250514.csv")) |> 
  janitor::clean_names()


# data processing ----
diversion <- diversion |> 
  mutate(
    # changing variable types / formatting of dates 
    referral_date = as.POSIXct(
      referral_date, 
      # used chat gpt to help determine correct format for data set 
      format = "%m/%d/%Y %I:%M:%S %p"
    ),
    diversion_closed_date = as.POSIXct(
      diversion_closed_date,
      # used chat gpt to help determine correct format for data set 
      format = "%m/%d/%Y %I:%M:%S %p")
  ) |> 
  # finding number of days between when defendant was referred to a diversion program and when they graduated/failed 
  mutate(
    days_between = as.numeric(
      as.Date(diversion_closed_date) - as.Date(referral_date)
    )
  ) |> 
  # finding years, rounded to two decimal places 
  mutate(
    years = round(days_between / 365, 2) 
  ) |> 
  # removing programs that no longer exist 
  filter(
    !diversion_program == "DS" & !diversion_program == "ARI"
  ) |> 
  # new variable - pre plea vs. post plea programs
  mutate(
    plea = case_when(
      diversion_program %in% c("BR9", "DDPP", "RJCC", "SEED")  ~ "pre",
      diversion_program %in% c("ACT", "DC", "MHC", "VC")  ~ "post"
    ) 
  ) |> 
  # extracting year from date
  mutate(
    referral_year = year(referral_date),
    diversion_closed_year = year(diversion_closed_date)
  ) |> 
  # removing observations from before 1970 
  filter(!referral_year < 1970) |> 
  # categorizing how long people have spent in programs
  mutate(
    one_year = case_when(
      # less than one year 
      years <= 0.99 ~ "less",
      # one year 
      years == 1.00 ~ "one",
      # more than one year 
      years >= 1.01 ~ "more"
    )
  ) 


# data analysis & findings ----

# offense category
diversion |> 
  # number of rows in each category
  count(offense_category) |> 
  # most to least
  arrange(desc(n)) |> 
  view()
  
# year 
diversion |> 
  # number of referrals each year 
  count(referral_year) |> 
  # most to least 
  arrange(desc(n)) |> 
  view()

diversion |> 
  # number of referrals each year 
  count(referral_year) |> 
  view()

diversion |> 
  # number of closed cases each year 
  count(diversion_closed_year) |> 
  # most to least 
  arrange(desc(n)) |> 
  view()

diversion |> 
  # number of closed cases each year 
  count(diversion_closed_year) |> 
  view()

# number of failed cases every year 
diversion |> 
  group_by(diversion_closed_year) |>
  filter(diversion_result == "Failed") |> 
  count(diversion_result) |> 
  view()
  
# number of graduates every year
diversion |> 
  group_by(diversion_closed_year) |>
  filter(diversion_result == "Graduated") |> 
  count(diversion_result) |> 
  view()


# pre vs. post plea success/failure
diversion |> 
  # setting up to compare pre vs. post plea outcomes
  group_by(plea) |> 
  # number of failures, graduations, current/unknown programs
  count(diversion_result) |> 
  view()

# how long people are in programs, grouped by timing of plea
# pre 
diversion |> 
  filter(plea == "pre") |> 
  count(one_year) |> 
  arrange(desc(n)) |> 
  view()

# post 
diversion |> 
  filter(plea == "post") |> 
  count(one_year) |> 
  arrange(desc(n)) |> 
  view()

# breakdown of participants in diversion programs 
diversion |> 
  group_by(diversion_program, race, gender) |> 
  count(offense_category) |> 
  arrange(desc(n)) |> 
  view()

# female participants in programs 
diversion |> 
  # selecting female participants only 
  filter(gender == "Female") |> 
  count(diversion_program) |> 
  arrange(desc(n)) |>
  view()

# male participants in programs
diversion |> 
  # selecting male participants only 
  filter(gender == "Male") |> 
  count(diversion_program) |> 
  arrange(desc(n)) |> 
  view()
  

  
  