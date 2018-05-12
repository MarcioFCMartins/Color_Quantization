#Implements the color quantization through median cut algorithm
library(jpeg)
library(ggplot2)
library(dplyr)
library(scales)
source("./scripts/helper_functions.R")

#Import image as 3-dimentional array
picture <- readJPEG("./test_images/a.jpg")

#Convert it to a list
picture <- list(list("red"   = as.vector(picture[,,1]), 
                      "green" = as.vector(picture[,,2]), 
                      "blue"  = as.vector(picture[,,3])))


#Split image into bins and average them
palette_custom <- quantize_colors(picture, 16)

show_col(palette_custom)
