#Get ranges of RGB dimensions
get_ranges <- function(X){
  c("red" = diff(range(X$red)),
    "green" = diff(range(X$green)),
    "blue" = diff(range(X$blue)))
}

#Splits individual groups into two groups (used in split_pixels)
split_group <- function(group){
  #group <- unlist(group, recursive = FALSE)
  sub_groups <- list()
  spliting_channel <- names(which.max(get_ranges(group)))
  
  sub_groups[[1]] <- list("red"   = group$red[group[spliting_channel][[1]] < median(group[spliting_channel][[1]])],
                          "green" = group$green[group[spliting_channel][[1]] < median(group[spliting_channel][[1]])],
                          "blue"  = group$blue[group[spliting_channel][[1]] < median(group[spliting_channel][[1]])])
  
  sub_groups[[2]] <- list("red"   = group$red[group[spliting_channel][[1]] >= median(group[spliting_channel][[1]])],
                          "green" = group$green[group[spliting_channel][[1]] >= median(group[spliting_channel][[1]])],
                          "blue"  = group$blue[group[spliting_channel][[1]] >= median(group[spliting_channel][[1]])])
  
  return(sub_groups)
}

#Split list of groups at median point of highest range dimension 
split_pixels <- function(image){
  unlist(lapply(image, split_group), recursive = FALSE)
}

#Average the color dimensions in each group
average_color <- function(group){
  colors <- list("red"   = mean(group$red),
                 "green" = mean(group$green),
                 "blue"  = mean(group$blue))
}

#Bring it all together to quantize
quantize_colors <- function(image_path, ncolor = 8){
  image <- readJPEG(image_path)
  image <- list(list("red"   = as.vector(image[,,1]), 
                     "green" = as.vector(image[,,2]), 
                     "blue"  = as.vector(image[,,3])))
  
  #Number of cycles to calculate enough colors (number of calculated averages is always base 2)
  cycle_stop <- ceiling(log2(ncolor))
  cycle <- 0
  
  #Recurse function until cycle number is reached
  while(cycle < cycle_stop){
    image <- split_pixels(image)
    cycle <- cycle + 1
  }
  
  #RGB means
  mean_colors <- lapply(image, average_color)
  mean_colors <- matrix(unlist(mean_colors), ncol = 3, byrow = TRUE)
  #Convert to hex color
  mean_colors <- rgb(mean_colors[,1], mean_colors[,2], mean_colors[,3])
  return(mean_colors)
}




