# substitution and replacement of strings

y = "Number of participants: 25"
y
sub("25", "30", y)

y = "Mr. Singh is the smart one. Mr. Singh is funny, too."
y
sub("Mr. Singh","Professor Jha", y)
gsub("Mr. Singh","Professor Jha", y)
sub("Mr. Singh","Professor Jha", y)

# grep

str = c("R Course", "exercises", "include examples of R language")
grep("ex", str, value=T)

str = c("R Course", "exercises", "include examples of R language")
grep("ex", str, value=F)

str = c("R Course", "exercises", "include examples of r language", "in R software.")
grep("R", str, ignore.case=F, value=T)
grep("R", str, ignore.case=T, value=T)
grep("R", str, ignore.case=T, value=F)
grep("R", str, ignore.case=F, value=F)

x = "R course 24.07.2021"
y = "Number of participants: 25"
c(x,y) # Combine the two strings
grep("our", c(x,y))
grep("Num", c(x,y))

# grepl

str = c("R Course", "exercises", "include examples of R language")
grepl("R", str)
grepl("ex", str)

# data frames

library(MASS)
painters

rownames(painters)

is.numeric(painters$School)
is.numeric(painters$Drawing)

is.factor(painters$School)
is.factor(painters$Drawing)

colnames(painters)
summary(painters)

library(MASS)
painters

summary(painters$School)

attach(painters)
summary(School) # Character variable
summary(Composition) # Numeric variable
detach(painters)
summary(School)

subset(painters, School=='F')
painters[ painters[["School"]] == "F", ]
subset(painters, Composition <= 6)
subset(painters, School=="F", select=c(-3,-5))

splitted = split(painters, painters$School)
splitted
is.data.frame(splitted$A)

# combining data frames

df1 = data.frame(state = c("Alabama", "Alaska", "Arizona"),
                 population = c(4779736, 710231, 639201))
df2 = data.frame(state = c("Alabama", "Alaska", "Arizona"),
                 area = c(52423, 665384, 113990))
df1
df2
cbind(df1,df2)
merge(df1,df2,by="state")

df11 = data.frame(x = c(1,2,3), y = c(4,5,6))
df22 = data.frame(x = c(7,8,9), y = c(10,11,12))
df11
df22
rbind(df11,df22)
