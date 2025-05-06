# multispectral
Derivation of vegetation indices from multispectral air images 

Based on the RStoolbox package (https://bleutner.github.io/RStoolbox/), Mulispectral allows the automated derivation of vegetation indices from multispectral images. 

The band sequence can be stored in the parameters to adapt the script to specific sensors. So far, the script includes the DJI Multispectral 
as well as the aerial images provided by the State of NRW in Germany under a free licence. (https://www.opengeodata.nrw.de/produkte/geobasis/lbi/dop/)

The script requires all input GeoTIFF files to be in an input folder that is in the same folder as the script. GeoTIFF files need to have a known band sequence. Subsequently, the indices to be calculated can be specified in the parameters 
(described here in detail: https://bleutner.github.io/RStoolbox/). 

Ouput is a plot of the calculated indices and for each calculated index a grid is created as GeoTIFF. 
