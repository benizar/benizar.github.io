
# TODO: Ver el siguiente fork para estudiar algunos bindings
# https://github.com/bhaskarvk/leaflet

# TODO: post with examples
# http://www.r-bloggers.com/interactive-mapping-with-leaflet-in-r/

library("leaflet")
library("rgdal")

geomatica<-readOGR("http://www.sigua.ua.es/api/pub/estancia/0037P1015", layer = "OGRGeoJSON", verbose=FALSE)

geomatica_popup <- paste(sep = "<br><center>", 
                         "<strong>", geomatica$denominacion,"</strong>",
                         "<b><a href='https://www.sigua.ua.es/index.html?id=0037P1015'>Find me in SIGUA</a></b>")


leaflet() %>% 
  addTiles() %>%
  setView(geomatica$lon, geomatica$lat, zoom = 15) %>% 
  addPolygons(data = geomatica) %>%
  addMarkers(lng = geomatica$lon, lat = geomatica$lat, popup = geomatica_popup)
             
             