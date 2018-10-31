#Fill this in as we go

# Basic operations
# declaration
vector1<-c(1,2,3,4,5)
vector2<-c(5,4,3,2,1)
df<-as.data.frame(cbind(vector1,vector2))

# Types of objects
typeof(vector1)

# Accessing object
df
df$vector1

# Starting the map
# install.pacakges("tidyverse) 
# load packages

library(tidyverse)
library(maps)
library(mapdata)
library(ggrepel)

## Retrieving map data

world<-map_data("world")
head(world)

#Plotting
ggplot(world)+
geom_polygon(aes(x=long, y=lat, group=group))

#Polygons have a fill (inside) and a color (border).
#They also have a size (border)
ggplot(world)+
  geom_polygon(aes(x=long, y=lat, group=group),
               fill="grey50")

#Filter for a country
taiwan1<-subset(world, region %in% c("Taiwan"))
taiwan2<-world %>% filter(region=="Taiwan")

ggplot(taiwan2)+
  geom_polygon(aes(x=long, y=lat, group=group),
               fill="grey50")

## Alterations to basic plot

map<-ggplot(world)+
  geom_polygon(aes(x=long, y=lat, group=group), fill="darkgrey")+
  coord_fixed(ratio=1.3)+
  ggtitle("A World Map")+
  xlab("Longitude")+
  ylab("Latitude")+
  theme_classic()+
  theme(plot.title = element_text(hjust = 0.5))

map

## Read data from a tab-delimited file sep="\t"
# Characters here: space \s, newline \n, tab \t
data<-read.csv(file = "./1-BasicMap/cities.txt", 
               sep="\t")

#Plotting "data"
ggplot()+geom_point(data=data, aes(x=Longitude, y=Latitude))

#Making more informative
ggplot()+geom_point(data=data, aes(x=Longitude, y=Latitude, size=Population), color="blue")+
  geom_label_repel(data=data, aes(x=Longitude, y=Latitude, label=City))

#A final plot
map+geom_point(data=data, aes(x=Longitude, y=Latitude, size=Population), color="blue")+
  geom_label_repel(data=data, aes(x=Longitude, y=Latitude, label=City))+
  coord_cartesian(xlim=c(min(data$Longitude)-1, max(data$Longitude)+1),
                  ylim=c(min(data$Latitude)-1, max(data$Latitude)+1))