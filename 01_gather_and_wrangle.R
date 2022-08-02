# ---
# title: "Create CSV file of Future Workshop"
# subtitle: "Data are from the LibCal API, parsed by rvest and dplyr"
# date: "`r Sys.Date()`"
# output: html_notebook
# ---

# Undertook this revision because the integratin of online and in-person workshops made Joel's script ineffective.  Nonetheless, borrowed heavily from his previous work.

# Run this script to harvest data from the SpringShare LibCal API.
# This script is calle by `02_make_main_workshop_list.Rmd`

Sys.setenv(TZ="America/New_York")
library(rvest)
library(clock)
library(tidyverse)
library(fs)


# Import LibCal API list of future workshops.
dvs_cal <- read_html("https://api3.libcal.com/api_events.php?iid=971&m=upc&cid=3819&c=&d=25858&l=50&target=_blank")


## Wrangle data
nregistration <- html_nodes(dvs_cal, ".s-lc-ea-treg a")
registration_list <- html_attr(nregistration, "href")


# Convert rvest response into a tibble by parsing the HTML table.
by_workshop <- html_nodes(dvs_cal, ".cat25858") %>% 
    html_table()

# Data come back in long tidy format.  Convert to wide.  lines 46 and 47 (ish) take into account that the API delivers inconsistent information based on workshop type.  i.e. online workshops report less data than in-person workshops
my_df <- tibble(by_workshop) %>%
    tidyr::unnest(cols = everything()) %>%
    mutate(X1 = if_else(X2 == "n/a", "Location:", X1)) %>%      # this line
    mutate(X2 = if_else(X2 == "n/a", "Online", X2)) %>%         # this line
    tidyr::pivot_wider(names_from = X1, values_from = X2, values_fn = list) %>%   # `values_fn = list` suppresses warnings
    janitor::clean_names() %>%
    # select(-c("campus", "categories")) %>%
    select(!c(contains("campus"), categories)) %>%
    unnest(cols = everything())

## This was a workaround because row 22 was a HYBRID workshop!!!
# my_df <- bind_rows(
#     tibble(by_workshop[1:20]) %>% 
#         tidyr::unnest(cols = everything()) %>% 
#         mutate(X1 = if_else(X2 == "n/a", "Location:", X1)) %>%      # this line
#         mutate(X2 = if_else(X2 == "n/a", "Online", X2)) %>%         # this line
#         tidyr::pivot_wider(names_from = X1, values_from = X2, values_fn = list) %>%   # `values_fn = list` suppresses warnings
#         janitor::clean_names() %>% 
#         select(!c(contains("campus"), categories)) %>% 
#         unnest(cols = everything())
#     ,
#     tibble(by_workshop[21]) %>% 
#         tidyr::unnest(cols = everything()) %>% 
#         mutate(X1 = if_else(X2 == "n/a", "Location:", X1)) %>%      # this line
#         mutate(X2 = if_else(X2 == "n/a", "Online", X2)) %>%         # this line
#         tidyr::pivot_wider(names_from = X1, values_from = X2, values_fn = list) %>%   # `values_fn = list` suppresses warnings
#         janitor::clean_names() %>% 
#         select(!c(contains("campus"), categories)) %>% 
#         unnest(cols = everything()) |> 
#         filter(location != "Online")
#     ,
#     tibble(by_workshop[22]) %>% 
#         tidyr::unnest(cols = everything()) %>% 
#         mutate(X1 = if_else(X2 == "n/a", "Location:", X1)) %>%      # this line
#         mutate(X2 = if_else(X2 == "n/a", "Online", X2)) %>%         # this line
#         tidyr::pivot_wider(names_from = X1, values_from = X2, values_fn = list) %>%   # `values_fn = list` suppresses warnings
#         janitor::clean_names() %>% 
#         select(!c(contains("campus"), categories)) %>% 
#         unnest(cols = everything())
# ) 

# Insert workshop URL into the data frame
my_df$registration <- registration_list

# Transform the data to look just like the original from Joel.
my_df <- my_df %>%
    mutate(workshop_id = str_extract(registration, "(?<=event/)\\d+")) %>% 
    mutate(workshop_begins = date_time_parse(glue::glue("{date} {str_extract(time, '.*[ap]m(?= - )')}"),
                                             "America/New_York",
                                             format = "%a, %b %d, %Y %I:%M%p")) %>% 
    mutate(begins_display = date_format(workshop_begins, format = "%I:%M %p")) %>% 
    mutate(workshop_ends = date_time_parse(glue::glue("{date} {str_extract(time, '(?<= - ).*[ap]m')}"),
                                           "America/New_York",
                                           format = "%a, %b %d, %Y %I:%M%p")) %>% 
    mutate(ends_display = date_format(workshop_ends, format = "%I:%M %p")) %>% 
    mutate(time_flyer = str_to_lower(glue::glue("{begins_display} - {ends_display}"))) %>% 
    mutate(duration = as.numeric(workshop_ends - workshop_begins) * 60) %>% 
    mutate(workshop_duration_minutes = as.character(duration)) %>% 
    # mutate(description = str_extract(description, ".*(?<=\\.)")) %>%            # take only the first paragraph
    mutate(registration_link = str_extract(registration, ".*(?=\\?)")) %>% 
    mutate(date = date_format(workshop_begins, format = "%F")) %>%
    mutate(day = date_format(workshop_begins, format = "%a")) %>% 
    mutate(day_flyer = date_format(workshop_begins, format = "%a, %h %d")) %>% 
    mutate(online_in_person_flyer = if_else(location == "Online", location, "In-Person"))



