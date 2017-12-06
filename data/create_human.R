# Mikael Jumppanen 29.11.17
# Data wrangling

library("dplyr")
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# Structure of the data
str(hd)
str(gii)

# Dimensions
dim(hd)
dim(gii)

# renaming of variables
hd <- hd %>% rename(HDI=Human.Development.Index..HDI., LEAB=Life.Expectancy.at.Birth, ExpYEd =Expected.Years.of.Education, MYEd = Mean.Years.of.Education, GNICap =Gross.National.Income..GNI..per.Capita, GNI_HDIRan =GNI.per.Capita.Rank.Minus.HDI.Rank)

gii <- gii %>% rename(GII=Gender.Inequality.Index..GII., MRR=Maternal.Mortality.Ratio, ABR=Adolescent.Birth.Rate, PRiPar=Percent.Representation.in.Parliament, PopWSecEdF=Population.with.Secondary.Education..Female., PopWSecEdM=Population.with.Secondary.Education..Male., LabFParRF=Labour.Force.Participation.Rate..Female.,LabFParRM=Labour.Force.Participation.Rate..Male.)

# two new variables with mutate
gii <- gii %>% mutate(FeMaRaSecEd = PopWSecEdF/PopWSecEdM, FeMaLabPar = LabFParRF/LabFParRM)

# inner joine by Country as key
human <- inner_join(gii, hd, by="Country")

dim(human)

write.csv2(human,"human.csv")


# It seems my orginal variable names are not so good, i prefer using those one which were given in exercice
library("stringr")

human_ <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt")

# structure of the data
str(human_)

# dimensions of the data
dim(human_)


# transform GNI as numeric variable(previously factor), dot notation refers to "human_"

human_ %>% transmute(GNI = as.numeric(str_replace(.$GNI, pattern=",", replace =""))) 

# check if the transmutation worked

str(human_)

summary(human_)

# create variable "keep" which contains variables which we want to keep
keep <- c("Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")

# I prefer using piping( %>% ) always when possible. In datacamp exercises it is not always used. 

human_ <- human_ %>% select(one_of(keep))

# in {base} there is na.omit() function which omits rows containing NA. 
human_ <- human_ %>% na.omit() 

# Remove regions from the dataset: First we need to identify those.

# look at the last 10 observations of human

tail(human_,n=10)

# define the last indice we want to keep
last <- nrow(human_) - 7

# choose everything until the last 7 observations
human_ <- human_[1:last, ]

# add countries as rownames
rownames(human_) <- human_$Country



# exclude country variable
human_ <- human_ %>%  select(-Country)

# check dimensions

dim(human_)

write.csv2(human_,"human.csv", row.names = T)