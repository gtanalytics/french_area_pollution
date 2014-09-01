Les départements Français les plus polluées
=====

On trouve sur [data.gouv.fr](data.gouv.fr) des données relatives aux entreprises polluantes ainsi que leurs géolocalisations

Pour récupérer les entreprises, c'est [http://www.data.gouv.fr/fr/dataset/entreprises-produisant-des-emissions-polluantes-nd](http://www.data.gouv.fr/fr/dataset/entreprises-produisant-des-emissions-polluantes-nd)

```r
download.file("http://www.pollutionsindustrielles.ecologie.gouv.fr/IREP/downloads/etablissements.csv",destfile = "etse_polluantes.csv")
```
### Représentation des zones à risques sur une carte avec utilisation de ggplot2

![zones polluées](/images/zones_polluees.png)
Format: ![on wordpress](http://sciencendata.wordpress.com)

### Projets : 

> Réaliser une analyse textuelle des libellé APE déclarés à l'INSEE pour détecter les zones à risques

> Convertir les départements en utilisant le format topojson et fournir une analyse interactive des documents



## Contacts

* GjT

* Follow me on [wordpress](http://sciencendata.wordpress.com)

* Follow me on [github](http://github.io/gtanalytics)
