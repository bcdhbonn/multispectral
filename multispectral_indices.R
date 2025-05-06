######################################################################
# This script derives a number of multispectral indices from DJI and #
# Landsat based imagery. It requires input data in form of GeoTIFF   #
# files inside the 'input' folder. A plot indicating all calculated  #
# indices and for each index a corresponding GeoTIFF are saved within#
# the 'output' folder.                                               #
######################################################################

################################
# PART 0 - Install packages    #
################################

install.packages("RStoolbox")
install.packages("terra")
install.packages("RColorBrewer")
install.packages("ggplot2")

################################
# PART 1 -  Load packages      #
################################

library(RStoolbox)
library(terra)
library(RColorBrewer)
library(ggplot2)

###################################
# PART 2 -  Set working directory #
###################################

#setwd("") # Depending on your setup (IDE, etc.) you might need to set the working directory here


###################################
# PART 3 -  Load file list        #
###################################

files <- list.files(path="input", pattern = "*.tif", full.names = TRUE,recursive = FALSE)

###################################
# PART 4 -  Define input type     #
###################################

INPUT <- "NRW" # Define the type of your input data here! Valid types are DJI, NRW and SEQ.

###################################
# PART 5 -  Create color palette  #
###################################

brewer.pal(11, "Spectral")
Spectral <- brewer.pal(11, "Spectral") 
ndvi <-  colorRampPalette(Spectral)

############################################
# PART 6 - Calculate indices for all files #
############################################

lapply(files,function(x){
  
  print(paste("Erzeuge Indizes für", x))
  
  ###################################
  # PART 6.1 -  Open file           #
  ###################################
  
  r <- rast(x) 

  ########################################
  # PART 6.2 -  Definition of band order #
  ########################################

  #so far for DJI Multispectral (DJI) and Geobasisdaten-NRW (NRW)
  orthoName <- strsplit(x, split = "[/.]")[[1]][[2]]
  # bands <- c("red", "green", "blue", "nir", "redEdge")
  if(INPUT == "SEQ"){
    bands <- c(2,1,NULL,4,3)
  }else if(INPUT == "DJI"){
    bands <- c(3,2,1,5, NULL)
  } else if(INPUT == "NRW") {
    bands <- c(1,2,3,4, NULL)
  } else {
    cat("Der gewählte Input ist:" , INPUT, ".\n Dieser ist in der Auswahl nicht vorhanden.")
  }

  ##########################################
  # PART 6.3 -  Calculate spectral indices #
  ##########################################
  
  SI <- spectralIndices(r, red = bands[1], green = bands[2], nir = bands[4], indices = c("DVI","NDVI","GNDVI","WDVI","GEMI","NDWI"))
 
  ########################################
  # PART 6.4 -  Plot results             # 
  ########################################
  
  plot <- ggR(SI,1:6, geom_raster=TRUE,  stretch = "hist") +
    scale_fill_gradientn(name = "scale", colours = ndvi(20))  +
    theme(axis.text = element_text(size=8), 
          axis.text.y = element_text(angle=90),
          axis.title=element_blank()) +
    ggtitle(orthoName)
  
  ########################################
  # PART 6.5 -  Save indices to file     # 
  ########################################
  dir_name <- paste0("output/",orthoName)
  dir.create(dir_name, recursive = TRUE, showWarnings = FALSE)
  names <- paste0(dir_name,"/",orthoName,"_", names(SI), ".tif")
  writeRaster(SI, filename=names, filetype="GTiff", overwrite=TRUE)
  
  png(paste0(dir_name,"/",orthoName,"_plot.png"),units = "cm",width = 16, height = 9, res = 300)
  print(plot)
  dev.off()

})
