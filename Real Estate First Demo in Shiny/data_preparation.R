# Import data
# Here "result_deleted_redundant_columns.csv" just an eaxmple, you could substitute "data_sf.csv" for it
data_sf <- read.csv("result_deleted_redundant_columns.csv", stringsAsFactors=FALSE)

# Munge data
temp <- gsub("[\"\\[\\]]*", "", data_sf$latlon)
temp <- unlist(strsplit(temp, ",", fixed = T))
temp <- as.data.frame(matrix(temp, ncol = 2, byrow = T))
colnames(temp) <- c("lat", "lon")
data_sf <- cbind(data_sf, temp)

# Initially, lat and lon columns are factors
data_sf$lat <- as.numeric(levels(data_sf$lat))[data_sf$lat]
data_sf$lon <- as.numeric(levels(data_sf$lon))[data_sf$lon]

# Obtain numeric price
data_sf$price <- gsub(",", "", data_sf$price)
data_sf$price <- as.numeric(data_sf$price)
data_sf <- data_sf[!is.na(data_sf$price), ]

# Seperate 3 data sets: overvalued, average, undervalued
data_sf <- data_sf[order(data_sf$price, decreasing = F), ]

data_sf$label <- "overvalued"
data_sf$label[data_sf$price >= quantile(data_sf$price, 0.25) & 
                data_sf$price <= quantile(data_sf$price, 0.75)] <- "average"
data_sf$label[data_sf$price < quantile(data_sf$price, 0.25)] <- "undervalued"

overvalued <- data_sf[data_sf$label ==  "overvalued", ]
average <- data_sf[data_sf$label ==  "average", ]
undervalued <- data_sf[data_sf$label ==  "undervalued", ]
