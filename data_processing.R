### Data processing ----

# load packages 
library(tidyverse)
library(here)

# load data ----
# dispositions data 
dispositions <- read_csv(here("data/Dispositions_20250514.csv")) |> 
  janitor::clean_names()

# initiation data 
initiation <- read_csv(here("data/Initiation_20250514.csv")) |> 
  janitor::clean_names()

# intake data 
intake <- read_csv(here("data/Intake_20250514.csv")) |> 
  janitor::clean_names()

# diversion data 
diversion <- read_csv(here("data/Diversion_20250514.csv")) |> 
  janitor::clean_names()

# sentencing data 
sentencing <- read_csv(here("data/Sentencing_20250514.csv")) |> 
  janitor::clean_names()




# data processing ----
diversion <- diversion |> 
  mutate(
    # changing variable types / formatting of dates 
    referral_date = as.POSIXct(
      referral_date, 
      format = "%m/%d/%Y %I:%M:%S %p"
    ),
    diversion_closed_date = as.POSIXct(
      diversion_closed_date,
      format = "%m/%d/%Y %I:%M:%S %p")
  ) |> 
  # finding number of days between when defendant was referred
  # to a diversion program and when they graduated/failed 
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
      diversion_program %in% c("BR9", "DDPP", "RJCC", "SEED")  ~ "pre-plea",
      diversion_program %in% c("ACT", "DC", "MHC", "VC")  ~ "post-plea"
    ) 
  ) |> 
  # extracting year from date
  mutate(
    referral_year = year(referral_date),
    diversion_closed_year = year(diversion_closed_date)
  ) |> 
  # removing incorrect values 
  filter(!referral_year < 1970 )


# data analysis & findings ----
diversion |> 
  filter(referral_year < 1970 ) |> 
  view()


# offense category
diversion |> 
  count(offense_category) |> 
  arrange(desc(n)) |> 
  view()
  
# year 
diversion |> 
  count(diversion_closed_year) |> 
  arrange(desc(n)) |> 
  view()

diversion |> 
  count(referral_year) |> 
  arrange(desc(n)) |> 
  view()

# pre vs. post plea success/failure
diversion |> 
  group_by(plea) |> 
  count(diversion_result) |> 
  view()


# breakdown of participants in diversion programs 
diversion |> 
  group_by(diversion_program, race, gender) |> 
  count(offense_category) |> 
  arrange(desc(n)) |> 
  view()

# female participants in programs 
diversion |> 
  filter(gender == "Female") |> 
  count(diversion_program) |> 
  view()

# male participants in programs
diversion |> 
  filter(gender == "Male") |> 
  count(diversion_program) |> 
  view()

  
  
  
  