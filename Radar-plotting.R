#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Author: Zhaodong Hao
# Create data: 2018-05-22
# Description: Plotting radar
# Attention: you can use Inkscape to open the output file (.svg) and save as a PDF file
# Contact: haozd1992@163.com
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

# set the working dictionary as the path of 'source'd file
whereFrom=sys.calls()[[1]]
# This should be an expression that looks something like
# source("pathname/myfilename.R")
whereFrom=as.character(whereFrom[2]) # get the pathname/filename
whereFrom=paste(getwd(),whereFrom,sep="/") # prefix it with the current working directory
pathnameIndex=gregexpr(".*/",whereFrom) # we want the string up to the final '/'
pathnameLength=attr(pathnameIndex[[1]],"match.length")
whereFrom=substr(whereFrom,1,pathnameLength-1)
setwd(whereFrom)

# read the karyotype files
data <- read.table("data.txt", sep = "\t", header = T, stringsAsFactors = F, colClasses = c("character", "numeric", "character", "integer", "character"))

# A4 paper (210mm * 297mm)
# left, right, top, bottom ---margins--- 20mm, 20mm, 25mm, 25mm (plot region: 170mm * 247mm)
# 1cm = 35.43307px

#<circle cx cy r style="stroke:#006600; fill:#00cc00"/>
  
circos <- data.frame(paste("<circle cx=\"", 10.5 * 35.43307, "\" cy=\"", 7.5 * 35.43307, "\" r=\"", 1.25 * 35.43307, "\" style=\"stroke:#b7b7b7; stroke-width:1; stroke-dasharray: 10 5; fill:none\"/>", sep = ""),
                     paste("<circle cx=\"", 10.5 * 35.43307, "\" cy=\"", 7.5 * 35.43307, "\" r=\"", 2.50 * 35.43307, "\" style=\"stroke:#6c6b6b; stroke-width:2; fill:none\"/>", sep = ""),
                     paste("<circle cx=\"", 10.5 * 35.43307, "\" cy=\"", 7.5 * 35.43307, "\" r=\"", 3.75 * 35.43307, "\" style=\"stroke:#b7b7b7; stroke-width:1; stroke-dasharray: 10 5; fill:none\"/>", sep = ""),
                     paste("<circle cx=\"", 10.5 * 35.43307, "\" cy=\"", 7.5 * 35.43307, "\" r=\"", 5.00 * 35.43307, "\" style=\"stroke:#6c6b6b; stroke-width:2; fill:none\"/>", sep = "")
)

#<path d="Mx,y Cx1,y1 x2,y2 x3,y3" style="stroke: #006666; fill:none;"/> 

angle_base <- floor(360/nrow(data))
x1_length <- 35/(nrow(data)/6)

for (i in 1: nrow(data)) {
  data[i, 6] <- angle_base * (i-1)
}
names(data)[6] <- "angle"

data$bezier <- paste("<path d=\"M372.0472,265.748 C", 372.0472 - x1_length - 20 * data$ratio, ",", 265.748 - data$ratio * 59 / 0.25, ",", 372.0472 + x1_length + 20 * data$ratio, ",", 265.748 - data$ratio * 59 / 0.25, ",372.0472,265.748\" transform=\"rotate(", data$angle, " 372.0472 265.748)\"", " fill=\"#", data$fill, "\" stroke = \"black\" stroke-width = \"0.5px\" />", sep = "")

# text model <text x y font-size fill >words</text>

data$text <- paste("<text x=\"", 372.0472 - nchar(data$Name) * 3, "\" y=\"", 265.748 - 5.00 * 35.43307 - 6, "\" font-size=\"", data$text_size, "\" transform=\"rotate(", data$angle, " 372.0472 265.748)\"", " fill=\"#", data$text_color, "\" >", data$Name, "</text>", sep = "")

#write .svg file

first_line <- data.frame("<?xml version=\"1.0\" standalone=\"no\"?>",
                         "<!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\"",
                         "\"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">",
                         "",
                         paste("<svg id=\"svg\" width=\"744.0945\" height=\"1052.362\">", "\t")
)

write.table(first_line[1, 1], "radar.svg", col.names = FALSE, row.names = FALSE, quote = FALSE)
write.table(first_line[1, 2], "radar.svg", col.names = FALSE, row.names = FALSE, quote = FALSE, append = TRUE)
write.table(first_line[1, 3], "radar.svg", col.names = FALSE, row.names = FALSE, quote = FALSE, append = TRUE)
write.table(first_line[1, 4], "radar.svg", col.names = FALSE, row.names = FALSE, quote = FALSE, append = TRUE)
write.table(first_line[1, 5], "radar.svg", col.names = FALSE, row.names = FALSE, quote = FALSE, append = TRUE)

write.table(circos[1, 1], "radar.svg", col.names = FALSE, row.names = FALSE, quote = FALSE, append = TRUE)
write.table(circos[1, 2], "radar.svg", col.names = FALSE, row.names = FALSE, quote = FALSE, append = TRUE)
write.table(circos[1, 3], "radar.svg", col.names = FALSE, row.names = FALSE, quote = FALSE, append = TRUE)
write.table(circos[1, 4], "radar.svg", col.names = FALSE, row.names = FALSE, quote = FALSE, append = TRUE)
write.table(data$bezier, "radar.svg", col.names = FALSE, row.names = FALSE, quote = FALSE, append = TRUE)
write.table(data$text, "radar.svg", col.names = FALSE, row.names = FALSE, quote = FALSE, append = TRUE)

last_line <- data.frame(paste("</svg>"))
write.table(last_line[1, 1], "radar.svg", col.names = FALSE, row.names = FALSE, quote = FALSE, append = TRUE)
