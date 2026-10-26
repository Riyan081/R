x <- NA

is.na(x)

dx = c(11, NA, 43, NA)

is.na(dx)

mean(dx)

mean(dx, na.rm = T)

# NA is placeholder for what's missing

# null stands for something that doesnt exist

which(is.na(dx))

sum(is.na(dx))      

complete.cases(dx)

y = na.omit(dx)

y

mean(dx)
mean(y)

a = 4

b = 2

if(is.na(x)) 45 * 3

if(a > 3) 43
if(b < 3) 34 

if(a < 3) 43

if(a > 3) print("a is greater than 3")

if(a > 3) {
  print("a is greater than 3")
  print("test")
} else
  print("a is smaller than 3")
}

x = 4

if(x == 1){
  print("x is 1")
}else if(x == 2){
  print("x is 2")
}else if(x == 3){
  print("x is 3")
}else {
  print("x is something")
}

if(x==3)  {
  x = x - 1
} else if(x<3)  {
  x = x + 5
} else {
  x = 2 * x
}
x

arr = 1:10
arr

ifelse(arr<6, arr^2, arr+1)

x = c(7, 9, 8, 4)

ifelse(x %% 2 == 0, "Even Number", "Odd Number")

switch(1, "One", "Two", "Three", "Four", "Five", "Six")

ask = "volume"

switch(ask, "color" = "blue", "gender" = "male", "volume" = 50)

switch(7, "One", "Two", "Three", "Four", "Five", "Six")

x = c(10, 15, 8, 14, 6, 12)

which(x == 14)

which(x != 12)

which(x > 10)

x = matrix(nrow = 3, ncol = 3, data = 1:9)

which.min(x)
which.max(x)

which(x %% 2 == 1)

which(x %% 2 == 1, arr.ind = T)
