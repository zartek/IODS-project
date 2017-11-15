# Exercice 2. Regression and model validation
# Author: Mikael Jumppanen 15.11.2017 

# Let's first read data to r by using read.csv. We will give parameters to function which tell that file is tab separted
# and that there is header

learning2014 <- read.csv("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep = "\t", header = T)

# Let's look at the data
head(learning2014)

# For creation of dataset we will use dplyr
library("dplyr")

# gender, Age and Attitude can be picked from the data by using select(). But other variables have to be made by using mutate function. Let's firt make "deep" variable. This could be performed in one line but due the sake of sanity I will divide it to three steps  
analysisData <- learning2014 %>% mutate(d_sm=D03+D11+D19+D27, d_ri=D07+D14+D22+D30, d_ue=D06+D15+D23+D31) %>%  mutate(deep=d_sm+d_ri+d_ue)

# Next we will make variables Surf and Stra
analysisData <- analysisData %>%  mutate(st_os=ST01+ST09+ST17+ST25, st_tm=ST04+ST12+ST20+ST28, su_lp=SU02+SU10+SU18+SU26, su_um=SU05+SU13+SU21+SU29, su_sb=SU08+SU16+SU24+SU32) %>% mutate(Surf=su_lp+su_um+su_sb, Stra=st_os+st_tm)

# Now we have all the variables and we can use select() to pick variables which we need to our dataset 
analysisData <- analysisData %>% select("gender","Age","Attitude", "deep", "Surf", "Stra", "Points")

# Next we will scale variables based on number of questions. Otherwise comparison doesn't work :) for this we will use mutate() function because we dont want to drop other variables. Number of questions: Attitude(10), deep(12), Surf(12), Stra(8)

analysisData <- analysisData %>% mutate(Attitude=Attitude/10,deep=deep/12, Surf=Surf/12, Stra=Stra/8)

#Let's filter results if the points are 0

analysisData <- analysisData %>% filter(Points != 0)
# Let's look our newly created dataset and calculate number of rows and column and check if they correspond row(observations):166 and columns(variables):7

head(analysisData)
nrow(analysisData)
ncol(analysisData)


#4. Saving of the data to hard drive 

# In this part of the exercise we will save the data and check if it is ok. We don't want rownames to be written with the code

write.csv(analysisData, "learning2014.csv", row.names = F)

data <- read.csv("learning2014.csv")
head(data)

