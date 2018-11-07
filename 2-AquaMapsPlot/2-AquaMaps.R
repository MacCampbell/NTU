library(tidyverse)
library(maps)
library(mapdata)

world<-map_data("world")
ggplot(world)+
  geom_polygon(data=world, aes(x=long, y=lat, 
                               group=group))+
  coord_fixed(1.3)

data<-read.csv(file="./2-AquaMapsPlot/bothidae.csv",
               skip=7)

ggplot()+geom_raster(data=data, 
                     aes(x=Center.Longitude, 
                         y=Center.Latitude, 
                         fill=Species.Count))+
  coord_fixed(1.3)

#Create to identical objects from world
w1 <- world
w2 <- world
# Make one go 360 degrees longer
w2$long <- w2$long + 360
# Extend the groups so that they are not redundant
w2$group <- w2$group + max(w2$group) + 1
#Combine them
newWorld <- rbind(w1, w2)

#Plot
map<-ggplot(newWorld)+geom_polygon(aes(x=long, y=lat, group=group))+
  coord_fixed(1.3, xlim = c(0, 360), ylim=c(-90,90))

map

##Double the raster data
raster1<-data
raster2<-data
raster2$Center.Longitude <- raster2$Center.Longitude + 360
raster<-rbind(raster1, raster2)

##Make a plot

ggplot(newWorld)+geom_polygon(aes(x=long, y=lat,
                                  group=group))+
  geom_raster(data=raster, aes(x=Center.Longitude,
                               y=Center.Latitude, 
                               fill=Species.Count))+
  scale_fill_gradient2(low="white", mid="yellow",
                       high="red")+
  coord_fixed(ratio=1.3, xlim = c(-0, 360), 
              ylim=c(-90,90))

#Manipulate title/axes with theme
pdf("A4landscape.pdf", paper="a4r")
map+ggtitle("World Map")+
  xlab("Longitude")+
  ylab("Latitude")+
  theme(plot.title=element_text(face="bold", 
                           hjust = 0.5, 
                           family="Times"),
        axis.title = element_text(family="Times"))
dev.off()

