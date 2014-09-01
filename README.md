Les départements Français les plus polluées
=====

On trouve sur [data.gouv.fr](data.gouv.fr) des données relatives aux entreprises polluantes ainsi que leurs géolocalisations

Pour récupérer les entreprises, c'est [ici](http://www.data.gouv.fr/fr/dataset/entreprises-produisant-des-emissions-polluantes-nd)

```r
download.file("http://www.pollutionsindustrielles.ecologie.gouv.fr/IREP/downloads/etablissements.csv",destfile = "etse_polluantes.csv")
```
### Représentation des zones à risques sur une carte avec utilisation de ggplot2

Voir sur [wordpress](http://sciencendata.wordpress.com)

### Code to shape data
Mise en forme des données et sta

```r
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
```

### Projets : 

> Réaliser une analyse textuelle des libellé APE déclarés à l'INSEE pour détecter les zones à risques

> Convertir les départements en utilisant le format topojson et fournir une analyse interactive des documents



## Contacts

* GjT

* Follow me on [wordpress](http://sciencendata.wordpress.com)

* Follow me on [github](http://github.io/gtanalytics)
