library(tidyverse)
library(ggrepel)

data<-as_tibble(read.csv(file="Chelidoperca_geodata.csv"))

#Rename a column
step1<-rename(data, Species=Species.name)

#Rename with "pipe" %>%
data %>% rename(Species=Species.name)

#Rename with pipe and store as df1
df1<-data %>% rename(Species=Species.name, MeanDepth=Mean.depth..m.)

#Grouping samples that are the same species, collected the same place
#And, are at the same depth, Counting how many:
df1 %>% group_by(Species, Latitude, Longitude, MeanDepth) %>%
       count()

df2<-df1 %>% group_by(Species, Latitude, Longitude, MeanDepth) %>%
  count() %>%
  rename(N=n)

#Basic plot with ggplot and geom_point
ggplot()+geom_point(data=df2, aes(x=Longitude, y=Latitude))
  
#Coding for species by color
ggplot()+geom_point(data=df2, aes(x=Longitude, y=Latitude,
                                  size=N, color=Species))+
  theme(legend.title.align = 0.5)

#Make legend labels italic and change default colors
ggplot()+geom_point(data=df2, aes(x=Longitude, y=Latitude,
                                  size=N, fill=Species),
                    color="black", shape=21)+
  theme(legend.text = element_text(face="italic"))+
  scale_fill_brewer(type="div", palette = "Spectral")

#Facet
ggplot()+geom_point(data=df2, aes(x=Longitude, y=Latitude,
                                  size=N, fill=Species), shape=21,
                    alpha=0.75)+
  facet_wrap(.~Species, nrow=3)

#
plot<-ggplot()+geom_point(data=df2, aes(x=Longitude, y=Latitude,
size=N, fill=MeanDepth), shape=21,
alpha=0.75)+
  theme_bw()+
  theme(legend.title.align = 0.5,
        axis.text.x = element_text(angle = 90, hjust = 1))+
  scale_fill_viridis_c()+
  coord_fixed(1.3, xlim = c(110, 175), ylim=c(-29,25) )+
  facet_wrap(.~Species, nrow=3)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())

plot

#Adding a world map
library(maps)
library(mapdata)

world<-map_data("world")
worldMap<-geom_polygon(data=world,aes(x=long, y=lat, group=group),
                      fill="grey50", color="grey50")

plot+worldMap

##Bathymetry data for part of the world
library("marmap")
load(file="bathy.rda")
bathyDf<-fortify.bathy(bathy)
ggplot()+geom_raster(data=bathyDf, aes(x=x, y=y, fill=z))

##How do we remove z values > 0 from our data frame?

#replace positives with 0
bathyDf2<-bathyDf %>% mutate(Depth = ifelse(z > 0, 0, z))

#remove all positive values
test<-filter(bathyDf, z < 0)
ggplot()+geom_raster(data=test, aes(x=x, y=y, fill=z))
raster<-geom_raster(data=test, aes(x=x, y=y, fill=z))
#You can now add this on to our existing plot

plot+worldMap+raster

#Oh noes! The raster covers the points

#Here it goes in order
#Note that Adrian's points were positive for depth while the raster is
# negative. fill=(MeanDepth*-1) should fix that.
ggplot()+
  geom_raster(data=bathyDf2, aes(x=x, y=y, fill=Depth))+
  geom_polygon(data=world, aes(x=long, y=lat, group=group),
               fill="grey50", color="grey50")+
  geom_point(data=df2, aes(x=Longitude, y=Latitude,
                           size=N, fill=(MeanDepth*-1)), shape=21,
             alpha=0.75)+
  theme_bw()+
  theme(legend.title.align = 0.5,
        axis.text.x = element_text(angle = 90, hjust = 1))+
  theme(panel.grid.major = element_blank(), panel.grid.minor =  element_blank())+
  scale_fill_viridis_c()+
  coord_fixed(1.3, xlim = c(110, 175), ylim=c(-29,25) )+
  facet_wrap(.~Species, nrow=3)

##Plotting as shapes
ggplot()+geom_point(data=df2, aes(x=Longitude, y=Latitude, shape=Species))+
  scale_shape_manual(values=seq(0,length(levels(df2$Species))))