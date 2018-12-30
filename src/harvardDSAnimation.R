# title: "Harvard DS Animation Contest"
# author: "Michel Benites Nascimento"
# date: "29 de dezembro de 2018"

library(ggplot2)
library(plotly)

# Generating random dataset
x <- runif(1000,  -5, 5)
y <- runif(1000, -25, 25)
z <- runif(1000,   1, 2)

# Transforming in a data frame
sim.data       <- data.frame(cbind(x,y,z))

# Creating a complete data frame with all stage of scales
sim.data.total        <- sim.data
sim.data.total$pscale <- 0

# Steps of 10%
ntry <- 1:10
sim.part <- NULL
for (i in ntry) {
  
  # define the part (start and end) of the dataset to take
  end.r        <- 100 * i
  ini.r        <- end.r - 99
  sim.part     <- data.frame(rbind(sim.part, scale(sim.data[ini.r:end.r,])))
  
  # Scale only one part of the dataset
  if ((end.r)<nrow(sim.data)) {
    sim.data.scl <- data.frame(rbind(sim.part, sim.data[(end.r+1):nrow(sim.data),]))
  } 
  # if end.r < nrow(sim.data) scale full dataset
  else {
    sim.data.scl <- data.frame(scale(sim.data))
  }
  
  sim.data.total <- rbind(sim.data.total, data.frame(x=sim.data.scl$x, y=sim.data.scl$y, z=sim.data.scl$z, pscale=i*10))
    
}

# Store in p variable the ggplot object
p <- ggplot(sim.data.total, aes(x=x, y=y, color=z)) + geom_point(aes(frame = pscale)) + ggtitle("Scaling the Dataset") + theme(plot.title = element_text(hjust = -5, vjust=0))

# Animate the ggplot object with ggploty
ggplotly(p) %>% animation_opts(1000) %>% animation_slider(currentvalue = list(prefix = "Scale ", posfix = "%", font = list(size=12, color="red")))  %>% config(displayModeBar = F)

sessionInfo()

