# README

![LifeCycle: Stable](https://img.shields.io/badge/lifecycle-stable-brightgreen "LifeCycle: Stable")

**Note to John**:  find at  `~/analysis_dvs_cal`

API orchestration with **SpringShare LibCal** to generate

- beginning of semester workshop list
- workshop attendance sheets


This repository contains a mixture of handy scripts and datasets used by the [Center for Data and Visualization Sciences](library.duke.edu/data) for marketing, assessing, and managing our [DVS Workshop Series](library.duke.edu/news).

This repository was **forked** from https://github.com/herndonj/dvs_cal

* **02_make_main_workshop_list.Rmd** - a migration from `rvestLibcalCode.R`.  Use this to generate the pre-semester _list of workshops_ and the pre-semester advertising **flyer**.  Gathers data from the LibCal API, writes a CSV file, writes a GoogleSheet to the google account holder's home directory (via `library(googlesheets4)`).  This script _sources_ `01_gather_and_wrangle.R` so there is **no need to run that file separately.  i.e. the main script is `02_make_main_workshop_list.Rmd`.**
* **03_attendance_worksheets.Rmd** - make an attendance sheet for each workshop, upload to Google Drive (CDVS folder)
* **01_gather_and_wrangle.R** - havest LibCal API data to make a data_frame of all the workshops as reported at the beginning of the semester. 
(Called from `02_make_main_workshop_list.Rmd`.  Do not need to run separately/manually.)

### Not in use

* **05_panopto_report.Rmd** - generate a report for Sophia to send to Paul so Paul can program the room recordings
* **06_duke_devents_report.Rmd** - generate a report for Sophia to review and send to the Duke Events Calendar people

## Changes in Registration Form

### 2018-01-22

Question 3 "Are you from Duke University, Duke Medical Center, DCRI, or another Duke group" changed to "Are you affiliated with Duke University, Duke Medical Center, DCRI, or another Duke group?"

"Attendance" field added to the asssement spreadsheet (not present in the interface that registrants see.)

<< analysis_dvs_cal >>

