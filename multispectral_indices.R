install.packages("RStoolbox")
install.packages("raster")
install.packages("rgdal")
install.packages("RColorBrewer")
install.packages("ggplot2")

################################
# PART 1 -  Load packages #
################################

library(raster)
library(RStoolbox)
library(rgdal)
library(RColorBrewer)
library(ggplot2)

###################################
# PART 2 -  Set working directory #
###################################

setwd("")

#the folder should contain just one image 

#####################################################
# PART 3 -  Load file with multiple bands           #
#####################################################


r <- brick("example.tif") 


######################################
# PART 4 -  Definition of band order #
######################################


#so far for DJI Multispectral (DJI) and for the images provided by Geobasisdaten-NRW (https://www.opengeodata.nrw.de/produkte/geobasis/lbi/dop/)
#if using the DJI Multispectral the band order might change if not all bands are stored during flight


INPUT <- "NRW" 


orthoName <- list.files(pattern = "*.tif")
orthoName <- unlist(strsplit(orthoName, split = ".tif"))


if(INPUT == "DJI"){
  redInput <- paste(c(orthoName,".3"),collapse = "")
  greenInput <- paste(c(orthoName,".2"),collapse = "")
  blueInput <- paste(c(orthoName,".1"),collapse = "")
  nirInput <- paste(c(orthoName,".5"),collapse = "")
  #redEdgeInput <- paste(c(orthoName,".4"),collapse = "")
} else if(INPUT == "NRW") {
  redInput <- paste(c(orthoName,".1"),collapse = "")
  greenInput <- paste(c(orthoName,".2"),collapse = "")
  blueInput <- paste(c(orthoName,".3"),collapse = "")
  nirInput <- paste(c(orthoName,".4"),collapse = "")

} else {
  cat("Der gewählte Input ist:" , INPUT, ".\n Dieser ist in der Auswahl nicht vorhanden.")
}

########################################
# PART 5 -  Calculate spectral indices #
########################################

#All parameters are described here in detail.: https://bleutner.github.io/RStoolbox/

SI <- spectralIndices(r, red = redInput, green = greenInput, nir = nirInput, indices = c("DVI","NDVI","GNDVI","WDVI","GEMI","NDWI"))


########################################
# PART 6 -  Plot results               # 
########################################

brewer.pal(11, "Spectral")
Spectral <- brewer.pal(11, "Spectral") 
ndvi <-  colorRampPalette(Spectral)


ggR(SI,1:6, geom_raster=TRUE,  stretch = "hist") +
  scale_fill_gradientn(name = "NDVI", colours = ndvi(20), guide=FALSE)  +
    theme(axis.text = element_text(size=8), 
          axis.text.y = element_text(angle=90),
          axis.title=element_blank()) +
        ggtitle(orthoName)
        
        
        
########################################
# PART 7 -  writeRaster                # 
########################################

#all calculated indices are exported as a single raster file

writeRaster(SI, filename=names(SI), bylayer=TRUE,format="GTiff")

