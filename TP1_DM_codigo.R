library(mongolite)
charts= mongo(collection = "charts", db = "DMUBA_SPOTIFY" )
df_charts<-charts$find(query='{}',fields='{"_id":false}')
#summarise(df_charts)
features= mongo(collection = "artist_audio_features_solo_art", db = "DMUBA_SPOTIFY" )
df_features<-features$find()
str(df_charts)
library(dplyr)
nrow(df_charts[duplicated(df_charts), ])
#Charts tiene las semanas duplicadas por algún motivo, las sacamos
df_charts=unique(df_charts)

barplot(table(df_charts$week_start))
names(charts_2019_2020)
df_charts$week_start = as.Date(df_charts$week_start)
df_charts$week_end = as.Date(df_charts$week_end)
ver=df_charts[df_charts$week_end<='2021-01-01',]
#charts_2019_2020=ver[ver$week_start>='2019-01-01',]
charts_2019_2020=ver#[ver$week_start>='2019-01-01',]
barplot(table(charts_2019_2020$week_start))
summary(charts_2019_2020)
ver=summarise(group_by(charts_2019_2020,week_start),n=n())
#Aasí vemos que hay semanas que tienen 201 puestos:
ver=ver[ver$n != 200,]
con_mas=charts_2019_2020[charts_2019_2020$week_start %in% ver$week_start,]
##Ahí me doy cuenta que mayo tiene filas con datos faltantes en Track$Name
barplot(table(con_mas$Position))
ver_2=summarise(group_by(con_mas,week_start),n=n())
may_2020=charts_2019_2020[charts_2019_2020$week_start=='2020-05-15',]
#Hay datos fatlantes en 4 observaciones de TrackName
charts_2019_2020$Track_Name[charts_2019_2020$Track_Name==as.character("")]<-NA
sum(is.na(charts_2019_2020$Track_Name))
#Elimino esas filas
charts_2018_a_2020=charts_2019_2020[!is.na(charts_2019_2020$Track_Name),]

#ver_2=summarise(group_by(charts_2019_2020,Position),sum(Streams))
#boxplot(charts_2019_2020$Streams[charts_2019_2020$week_start>='2020-01-01'] ~ charts_2019_2020$Position[charts_2019_2020$week_start>='2020-01-01'])
boxplot(charts_2018_a_2020$Streams ~ charts_2018_a_2020$Position)
#charts_top_10<-charts_2019_2020[charts_2019_2020$Position<=10,]
#charts_ultimos_190<-charts_2019_2020[charts_2019_2020$Position>10,]
#charts_ultimos_180<-charts_2019_2020[charts_2019_2020$Position>20,]
#charts_ultimos_170<-charts_2019_2020[charts_2019_2020$Position>30,]
#charts_ultimos_130<-charts_2019_2020[charts_2019_2020$Position>70,]
#boxplot(charts_top_10$Streams[charts_top_10$week_start>='2020-01-01'] ~ charts_top_10$Position[charts_top_10$week_start>='2020-01-01'])
#boxplot(charts_top_10$Streams ~ charts_top_10$Position)
hist(charts_2019_2020$Streams)
hist(charts_2018_a_2020$Streams)
#boxplot(charts_top_10$Streams ~ charts_top_10$week_start)

#boxplot(charts_ultimos_130$Streams ~ charts_ultimos_130$week_start)
#plot(charts_2019_2020$Streams[charts_2019_2020$Position==1] ~ charts_2019_2020$week_start[charts_2019_2020$Position==1])

#boxplot(charts_2019_2020$Streams ~ charts_2019_2020$Position,range=1.5)
#ar(bg="white")
#Me gustaría tener la media semanal
charts_medias=summarise(group_by(charts_2018_a_2020,week_start),mean)

library(ggplot2)
library(reshape2)
library(dplyr)

ver=summarise(group_by(charts_2019_2020,URL),n=n())
#unicos<-subset(charts_2019_2020,URL==ver[ver$n==1,1])
write.csv(ver,'ver.csv')
ver2=summarise(group_by(charts_2019_2020,Track_Name),n=n())
write.csv(charts_2019_2020,'charts.csv')
write.csv(df_featu,'df_featu.csv')
length(unique(charts_2019_2020$Track_Name,charts_2019_2020$Artist))
unicos_tracks=summarise(group_by(charts_2019_2020,Track_Name,Artist),n=n())
barplot(table(charts_2019_2020$Track_Name))
#El histograma de CHARTS
dev.off()
hist((charts_2018_a_2020$Streams/10000000),col='Black',border='white',breaks=25)
summary(charts_2018_a_2020$Streams)

Posiciones<-charts_2019_2020[,!names(charts_2019_2020) %in% c('Track_Name','Artist','URL')]
modas_pos=group_by(Posiciones,Position) 
modas_pos=summarise(modas_pos,mean(Streams))

library(tidyverse)
charts_year<-charts_2018_a_2020 %>% group_by(week_start) %>% summarise(streams_totales=sum(Streams))  

charts_year %>%
  ggplot( aes(x=week(week_start), y=streams_totales,group=year(week_start),col=year(week_start))) +
  geom_point()+geom_line()

bin_eq_width <- discretize(charts_year$week_start,"equalwidth",38)
charts_meses <- data.frame(charts_year$week_start,charts_year$streams_totales,bin_eq_width)
names(charts_meses)<-c("week_start","streams_totales","bins")
chart_mes<-charts_meses %>% group_by(charts_meses$bins) %>% summarise(streams_s=sum(streams_totales))



  
charts_2018=charts_2018_a_2020[year(charts_2019_2020$week_start)==2018,]
charts_2019=charts_2018_a_2020[year(charts_2019_2020$week_start)==2019,]
charts_2020=charts_2018_a_2020[year(charts_2019_2020$week_start)==2020,]
charts_year_2109<-charts_2019 %>% group_by(week_start) %>% summarise(streams_totales=sum(Streams))  
charts_year_2020<-chart_2020 %>% group_by(week_start) %>% summarise(streams_totales=sum(Streams))  

plot(charts_2018_a_2020$Position,charts_2018_a_2020$Streams)

charts_posiciones<-summarise(group_by(charts_2018_a_2020,Position),stream_p=mean(Streams))
plot(charts_posiciones$Position,charts_posiciones$stream_p)





##Si empezamos a ver que hay en features
features= mongo(collection = "artist_audio_features_solo_art", db = "DMUBA_SPOTIFY" )
df_features<-features$find("")
length(unique(df_features$track_id))
length(unique(df_features$track_name))
summary(df_features)
c=names(df_features)
df_features_original<-df_features
df_features=df_features[,!names(df_features) %in% c('available_markets')]
df_features=df_features[,!names(df_features) %in% c('artists','artist_id')]
df_features=df_features[,!names(df_features) %in% c('album_images')]
nombres_en_features=summarise(group_by(df_features,track_name),n=n())
Despacito=df_features[df_features$track_name=="Despacito",]

summary(Despacito)
#features_en_charts=merge(charts_2019_2020,df_features,by.x="Track_Name",by.y="track_name")
install.packages("gplots")
library(gplots)
library(RColorBrewer)
df_features_num=select_if(df_features,is.numeric)
df_features_num=df_features_num[,!names(df_features_num) %in% c('track_number','album_release_year')]
df_features_num=df_features_num[,!names(df_features_num) %in% c('disc_number')]
df_features_num=df_features_num[,!names(df_features_num) %in% c('time_signature')]
#Hisotgrama
library(tidyverse)
#ggplot(gather(df_features_num,cols,value),aes(value))+geom_histogram(binwidth = 20) + facet_grid(.~cols)
par(mfrow=c(3,4))
for (i in names(df_features_num)){hist(df_features_num[,i],main=i,xlab='')}
dev.off()
df_features_num=df_features_num[,!names(df_features_num) %in% c('duration_ms')]
df_featu=df_features_num[,!names(df_features_num) %in% c('tempo')]
df_featu=df_features_num[,!names(df_features_num) %in% c('key')]
par(mfrow=c(2,6))
for (i in names(df_features_num)){boxplot(df_features_num[i])}
features.cor=cor(df_features_num)
#ds.cor = cor(features_num[,1:9],use= "pairwise.complete.obs") # con el use "pairwise.complete.obs" descarta los nulos para el calculo
# Excluyo triangulo inferior para mayor claridad
library(RColorBrewer)
features.cor[lower.tri(features.cor)] <- NA
heatmap(features.cor,Colv = NA, Rowv = NA, scale="column")
library(tidyverse)
library(ggcorrplot)
#install.packages("ggcorrplot")
ggcorrplot(features.cor,type="upper",lab=TRUE)
summary(df_features)


#Mas que persistencia es como un conteo de cuántas veces se repiten
f_en_charts_2019=features_en_charts[year(features_en_charts$week_start)=="2019",]
f_en_charts_2020=features_en_charts[year(features_en_charts$week_start)=="2020",]
