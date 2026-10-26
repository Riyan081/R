# print and format with concatenate

print("The zero occurs at")
print(2*pi)
print("radians")

cat("The zero occurs at", 2*pi, "radians.", "\n")

d = date()
cat("Today's date is:", d, "\n")

x = 1:10
x
cat(x, sep = " ++ ")
cat("\n")
cat(x, sep = " / ")

x = 7
cat("The square of", x, "is", x^2, "!\n")
cat("The square root of",x,"is approximately", format(sqrt(x),digits=3),"\n")

evenno = c(2,4,6,8,10)
evenno
cat("The first few even numbers are:", evenno, "...\n")

x = 1:10
x
cat(x, fill = 2, labels = paste("(", letters[1:10], "):"))

# paste function

paste(1:12)
as.character(1:12)

paste("Everybody", "loves", "R Programming.")
paste("Everybody", "loves", "R Programming.", sep="*")
paste("Everybody", "loves", "R Programming.", sep="===")

names = c("Prof. Singh", "Mr. Venkat", "Dr. Jha")
names
paste(names, "is", "a good", "person.")
paste(names, "is", "a good", "person.", collapse=", and ")

paste(1, " is first", 2, " is second", 3, " is third", sep = "#")
paste(1, " is first    ", 2, " is second     ", 3, " is third      ", sep = "#")

x = paste("Ex", 1:5, sep="_")
x
x[1]
x[2]
x[3]
x[5]

x = paste("Ex", 1:5, sep="_", collapse="")
x
x[1]

paste0(1:10)
paste(1:10)
paste0(1:10, c("st", "nd", "rd", rep("th", 7)))
paste(1:10, c("st", "nd", "rd", rep("th", 7)))

# split strings

x = "The&!syntax&!of&!paste&!is!&available!"
x
strsplit(x, split="!")
strsplit(x, split = "&!")
y = strsplit(x, split = "!&")
y
y[[1]][1]
y[[1]][2]
y[[1]][3]

dates = c("2020-07-24", "2021-08-25", "2022-09-26", "2023-10-27")
datesplt = strsplit(dates, split="-")
datesplt
datesplt

datemat = matrix(unlist(datesplt), nrow = 4, byrow = TRUE)
datemat

datematrix = matrix(unlist(datesplt), nrow = 4, byrow = TRUE)
datematrix

strsplit("Shalabh",split="")

# number of characters

x = "R course 24.07.2022"
y = "Number of participants: 25"
nchar(x) #Count the Number of Characters in x
nchar(y) #Count the Number of Characters in y

nzchar(x)
nzchar(y)

x = c("Apple", "Banana", "Cake")
x
nzchar(x)

y = c("Apple", "", "Cake")
y
nzchar(y)

x = c("Apple", "Banana", "Cake")
nchar(x)

y = c(2, 4, 6)
nchar(y)

z = c(11, 222, 3333)
nchar(z)

z1 = c(1.1, 2.22, 3.333)
nchar(z1)

# change case

x = "R course will start from 24.07.2022"
toupper(x)

z = "INDIAN INSTITUTE OF TECHNOLOGY"
tolower(z)
