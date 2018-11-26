# Rasterize ourselves
require(tidyverse)

Rasterize <- function(cellSize, breaks, dataFrame ) {
  xvector<-seq(-180, 180, by=cellSize)
  yvector<-seq(-90, 90, by=cellSize)
  
  raster<-dataFrame %>% 
    group_by(Species, X=cut(Longitude, breaks= seq(-180, 180, by = cellSize), 
                            labels = FALSE) ) %>% 
    group_by(Species, X, Y=cut(Latitude, breaks=seq(-90, 90, by=cellSize), 
                               labels= FALSE)) %>%
    select(Species, X, Y) %>%
    unique() %>%
    group_by(X,Y)%>%
    summarise(Diversity= n()) %>%
    mutate(Longitude = xvector[X]+(cellSize/2)) %>%
    mutate(Latitude = yvector[Y]+(cellSize/2))
  #adding breaks for later
  raster1<-raster %>% group_by(Diversity, 
                               Breaks=cut(Diversity, breaks=breaks)) %>%
    select(Diversity, Longitude, Latitude, Breaks)
  return(raster1)
  
}


