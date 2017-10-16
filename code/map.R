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
# Purpose: Mapping node locations

# Load necessary libraries if they are missing from environment
if(!all(c('load_libs', 'pimaa') %in% ls())) {
  stop("Run setup.R file.")
}

# Pull the map object
map <- ggmap(
  get_map(
    location = 'Kampala', 
    zoom = 14,
    maptype = 'roadmap',
    source = 'google')
  )

# Plot node locations onto map
map + 
  geom_point(
    data = nodes,
    aes(x = Longitude, y = Latitude), 
    color = 'red', 
    size = 3, 
    alpha = 0.5) +
  geom_text(
    data = nodes,
    aes(x = Longitude, y = Latitude, label=Node),
    vjust = 0,
    hjust = 0,
    nudge_x = 0.001,
    size = 2,
    fontface = 'bold') + 
  xlab('Longitude') + 
  ylab('Latitude')