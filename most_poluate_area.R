# Objectifs : 
# Classer les départements par type d'activités polluantes et montrer les départements où il y a le plus de pollution


# Data
rm(list=ls())
##download.file("http://www.pollutionsindustrielles.ecologie.gouv.fr/IREP/downloads/etablissements.csv",
##              destfile = "etse_polluantes.csv")
ets = read.csv2("etse_polluantes.csv", sep = ";",stringsAsFactor=F,dec =".")
# Library
library(plyr) ; library(dplyr) ; library(reshape2)
library(ggplot2)
library(rgeos) ;library(maptools) ; library(scales) ;library(proj4) ; library(rgdal)

# Data wrangling

## Colnames
names(ets)
ets <- select(ets, nom_etablissement,code_postal,departement,coordonnées_x,coordonnées_y,libellé_ape,code_eprtr)
names(ets) = c("nom_etab","code_postal","nom_dept","long_ets","lat_ets","ape","code_eprtr")
# Simple stats
dept = group_by(ets,nom_dept)
stat= dept %.% summarise(nb_etabs = n()) %>% arrange(desc(nb_etabs))
head(stat)
# French departments from ign
shp=readShapeSpatial(fn='D:/Data/geo/DEPARTEMENTS/DEPARTEMENT.SHP',proj4string=CRS("+init=epsg:2154"))
shp_data = shp@data ; names(shp_data)=tolower(names(shp_data))
shp_df=fortify(shp,region = "CODE_DEPT")
shp_data= select(left_join(shp_data,stat),code_dept,nom_dept,nb_etabs)
shp_df$code_dept=shp_df$id
shp_df=select(left_join(shp_df,shp_data),- code_dept)
library(ggthemes)
infodept = aggregate(cbind(long, lat,nb_etabs) ~ nom_dept, data=shp_df, FUN=function(x)mean(range(x)))
infodept = filter(arrange(infodept,desc(nb_etabs)), nb_etabs>150)
str(shp_df)
g= ggplot(shp_df, aes(long,lat, group=group)) + geom_polygon(aes(fill=nb_etabs))+ geom_path(color="grey", size=0.5)
g = g+ scale_fill_gradient2(low = "#F2F1ED", mid = "white", high ="#B22222", 
                            midpoint = median(shp_df$nb_etabs,na.rm = T),
                            space = "rgb", guide = "colourbar")

g = g+ theme_gdocs() + labs(x="", y="", title="Départements de France et Nombre d'entreprises polluantes")
g = g+ theme(axis.line = element_blank(),
             axis.text = element_blank(), axis.ticks = element_blank())
g = g+geom_text(data=infodept, hjust=0.5, vjust=-0.5, 
                aes(x=long, y=lat,label=nom_dept, group = NULL), colour="grey10", size=4)
ggsave(filename = "zones_pollues.png",plot = g,width=13,height=8)




g = g + geom_point(data=pros_par_bv, aes(long_deg, lat_deg, group=NULL, fill=NULL, size=tot_pros_bv),
                   color="#D181B0", alpha=I(3/10)) 
g=g+scale_size_area(max_size = 30, breaks = c(0,100,300,700,1000,1600,5000,10000,20000, 80000)) # A moduler en fonction des données
g = g+ labs(x="", y="", title="Densités des pros par communes")
ggsave(filename = "./figure/densite_pros.png",g,width=13,height=8)

})
