# Mikael Jumppanen, 21.11.17 
# Logistic regression model exercice data wrangling. 

math <- read.csv("student-mat.csv", sep=";")
por <- read.csv("student-por.csv", sep=";")

dim(math)
dim(por)
str(math)
str(math)

library("dplyr")

# Let's join data and use as key columns defined below

join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")

# We use inner_join because we want to keep only student present in both datasets. Ofcourse might be that some students are lost this way
# because if for example age have changed between the studies age doesn't match anymore. 

math_por <- inner_join(mathData,porData, by= join_by, suffix=c("x.Math","y.Por"))

dim(math_por)
str(math_por)
# Data seems to match :)

# Next we want to get rid of duplicate answers by calculating mean if they are numeric and selecting firs one if not.

# create a new data frame with only the joined columns
alc <- select(math_por, one_of(join_by))

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]

# print out the columns not used for joining
print(notjoined_columns)

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}
glimpse(alc)
# glimpse at the new combined data

# Let's create new variable alcohol use for dataset. one good thing in piping is that new variable can be used straight away to create newone
alc <- alc %>% mutate(alc_use = (Dalc + Walc)/2) %>% mutate(high_use = alc_use>2)

glimpse(alc)

write.csv(alc, "modified_data.csv")
write.csv(math_por, "joined_data.csv")
# Everything seems to be in order. I am still thinking my own solution for question number 5... it can be achieved by using pipes and dplyr. 