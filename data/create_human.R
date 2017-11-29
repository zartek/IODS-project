# Mikael Jumppanen 29.11.17
# Data wrangling

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