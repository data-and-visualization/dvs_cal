# README

![LifeCycle: Stable](https://img.shields.io/badge/lifecycle-stable-brightgreen "LifeCycle: Stable")

API orchetration with **SpringShare LibCal** to generate

- beginning of semester workshop list
- workshop attendance sheets


This repository contains a mixture of handy scripts and datasets used by the [Center for Data and Visualization Sciences](library.duke.edu/data) for marketing, assessing, and managing our [DVS Workshop Series](library.duke.edu/news).

This repository was **forked** from https://github.com/herndonj/dvs_cal

* **02_make_main_workshop_list.Rmd** - a migration from `rvestLibcalCode.R`.  Use this to generate the pre-semester _list of workshops_ and the pre-semester advertising **flyer**.  Gathers data from the LibCal API, writes a CSV file, writes a GoogleSheet to the google account holder's home directory (via `library(googlesheets4)`)
* **03_attendance_worksheets.Rmd** - make an attendance sheet for each workshop, upload to Google Drive (CDVS folder)
* **01_gather_and_wrangle.R** - havest LibCal API data to make a data_frame of all the workshops as reported at the beginning of the semester.

##Changes in Registration Form

### 2018-01-22

Question 3 "Are you from Duke University, Duke Medical Center, DCRI, or another Duke group" changed to "Are you affiliated with Duke University, Duke Medical Center, DCRI, or another Duke group?"

"Attendance" field added to the asssement spreadsheet (not present in the interface that registrants see.)

