#########################################################################################
# License: Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)  #
# This license entitles you to Share (copy adn redistribute the material in any medium  #
# or format) and Adapt (remix, transform and build upon the material) the code listed   #
# in this file. The code in this page can be used for non-commercial purposes only.     #
# For a full copy of the license, please refer to                                       #
# https://creativecommons.org/licenses/by-nc/4.0/legalcode                              #
#########################################################################################

# Author: Outbox, Research Division
# Version: 0.1
# Date of version release:13 Oct 2017
# Purpose: To set defaults for the R environment

libraries <- c('dplyr', 
               'ggplot2', 
               'lubridate', 
               'tidyr', 
               'readr', 
               'ggmap', 
               'stringr', 
               'xts', 
               'scales')

# Attempt to load libraries into environment
loaded_libraries <- sapply(libraries, require, character.only = TRUE) 

# Attempt to install and load only missing libraries. If it fails, do not proceed
if(!all(loaded_libraries)) {
  install.packages(libraries[!loaded_libraries])
  sapply(libraries[!loaded_libraries], require, character.only = TRUE)
}

loaded_libraries <- libraries %in% (.packages())

if(!all(loaded_libraries)) {
  stop(paste('Failed to load the following packages: ', libraries[!loaded_libraries]))
} else {
  print(paste("Successfully installed package:", libraries[loaded_libraries]))
}

# Load data sets
pimaa <- read_csv(file = "../data/pimaa.csv") # PM2.5 data readings
nodes <- read_csv(file = "../data/nodes.csv") # Node locations

if(all(c('pimaa', 'nodes') %in% ls())) {
  print("Successfully loaded datasets.")
} else {
  stop("Cannot load datasets.")
}

# Clean up environment
rm(list = c('libraries', 'loaded_libraries'))

# Set up the pimaa dataset
pimaa <- pimaa %>% 
  mutate(
    pollutant = str_split_fixed(pimaa$sensor_code, '_', Inf)[,2]
  ) %>%
  select(
    node_id,
    pollutant,
    value,
    timestamp
  )

# Clean up the pimaa dataset with the noise attribute.
blank_noise_indexes <- which(pimaa$pollutant == "")
pimaa[blank_noise_indexes, 'pollutant'] <- 'noise'

# Convert the pimaa dataset into an xts object for better support with time series
pimaa <- xts(
  x = subset(pimaa, select = -timestamp), 
  order.by = dmy_hm(pimaa$timestamp),
  tzone = Sys.getenv('UG'))

# Collection of unique pollutants
pollutants <- unique(pimaa$pollutant)

# Clean up unnecessary objects from memory
rm('blank_noise_indexes')