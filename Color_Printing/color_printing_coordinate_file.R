# installing the imager package 

install.packages("imager"); 
install.packages("miscTools"); 
 
# loading the package imager and the dplyr package 

library("imager"); 
library("dplyr"); 
library("vctrs"); 
library("miscTools"); 
 
# accessing image "D:\Pictures\undefined" 

logo <- load.image("D:/Pictures/undefined.jpg.png") #change path to your custom path to image.
plot(logo); 

# making image grayscale 

logo_grayscale <- grayscale(logo); 
logo_grayscale; 

#display all the pixel values 
 
head(logo_grayscale) 
 
# splitting the image into 5 images along x and y 
 
c <- c(imsplit(logo_grayscale,"y",5)); 
 
# splitting each x-split image along y axis 
 
final <- list(dim = length(c)*5); 
t <- 1; 
for(i in c){ 
  final[t:(t+4)] <- c(imsplit(i,"x",5)); 
  t <- t+5; 
} 
 
# loading the images as tables.  
 
final_printer <- as.data.frame(final[[1]]) %>% mutate(value = round(value,2)); 
for (i in final) { 
   final_printer <-vec_rbind(final_printer, as.data.frame(i) %>% mutate(value = round(value,2))); 
 
} 

# normalizing the pixel values to droplets 
 
vals <- final_printer$value[final_printer$value <1]; 
final_printer$value[final_printer$value <1] <- final_printer$value * 100.00; 
vals <- final_printer$value[final_printer$value >1]; 
 
# modifying the dataset to look like printer field file 
 
final_printer %>% mutate_all(as.character); 
final_printer[,1] <- paste("~",final_printer[,2],final_printer[,1],sep = "/"); 
final_printer 
 
# mnodify the second column 
 
final_printer$y[final_printer$value != "1"||final_printer$value != "0"] = "1A1,"; 
final_printer$y[final_printer$value == "1"] = ""; 
final_printer$value[final_printer$value == "1"] = ""; 
final_printer$y[final_printer$value == "0"] = ""; 
final_printer$value[final_printer$value == "0"] = ""; 
 
# function to insert a row into a df after specific row 
 
insertRow <- function(existingDF, newrow, r) { 
  existingDF[seq(r+3,nrow(existingDF)+2),] <-    existingDF[seq(r+1,nrow(existingDF)),] 
  existingDF[r+1,] <- c("","",""); 
  existingDF[r+2,] <- newrow; 
  return(existingDF) 
} 

# inserting field demarcations 
 
d <- final_printer[final_printer$x== "~/74/74",]; 
h <- nrow(d) 
row.names(d) 
g<- 1; 
while(g< h){ 
  d <- final_printer[final_printer$x== "~/74/74",]; 
  e<- row.names(d); 
  f <- as.integer(e[g]); 
  field <- paste("[",as.character(g),",0,0]", sep = ""); 
  m <- c(field, " "," "); 
  final_printer <- insertRow(final_printer, m, f); 
  g <- g+1; 
} 
row.names(d) 
 
# at this stage, the file is good. Just need to delete the excel converter preventer (the ~/). 
# add comma 

final_printer$value<- paste(final_printer$value,",",sep =""); 
final_printer$value[final_printer$value == ","] =""; 
final_printer$value[as.integer(row.names(d))] =""; 
 
# writing to csv 

write.csv(final_printer,file = "printermap.csv", quote = TRUE, row.names = FALSE, col.names = FALSE); 
