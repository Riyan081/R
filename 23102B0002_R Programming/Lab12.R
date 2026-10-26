# bar diagram

cust = matrix(nrow = 4, ncol = 3, data = c(2, 20, 30, 26, 53 ,40, 42, 15, 25, 30, 75 ,100), byrow = T)

cust

barplot(cust)

barplot(cust, names.arg = c("Shop 1", " Shop 2", " Shop 3"), xlab = " Shops", ylab = "Days", col = c("red", "green", "orange", "brown"))


# pie diagram

gender = c(1, 2, 1, 2, 1 , 1, 1 , 2 , 1 , 1)

pie(gender)

pie(table(gender))

direction = c(1,1,2,1,2,3,2,2,3,3,3,1,2,3,2,2,3,1,1,3,3,1,2,
    1,3,3,3,2,2,2,2,1,2,2,1,1,1,3,2,2,1,2,3,2,2,1,
    2,3,3,2,1,2,2,3,1,1,2,1,2,3,2,3,2,2,3,1,2,3,3,3,
    2,1,1,1,2,1,1,2,1,2,3,3,1,2,3,3,2,1,2,3,2,1,3,
    2,2,2,2,3,2,2)

pie(table(direction))

pie(table(direction), col = c("red", "green", "blue"), main = "Directions of Food Delivery")

# combining graphics

par(mfrow = c(1, 2))

barplot(table(direction))

pie(table(direction))

par(mfrow = c(2, 1))

barplot(table(direction))

pie(table(direction))


# histogram

height = c(166,125,130,142,147,159,159,147,
           165,156,149,164,137,166,135,142,133,136,127,143,
           165,121,142,148,158,146,154,157,124,125,158,159,
           164,143,154,152,141,164,131,152,152,161,143,143,
           139,131,125,145,140,163)

hist(height)

hist(height, main = "Heights of people", col = "green", xlab = "Heights", ylab = "Number of People")

hist(height, main = "Heights of people", col = c("green", "red", "blue"), xlab = "Heights", ylab = "Number of People")
# shaded lines
hist(height, main = "Heights of people", col = "red", xlab = "Heights", ylab = "Number of People", density = 2)
# more shaded lines
hist(height, main = "Heights of people", col = "blue", xlab = "Heights", ylab = "Number of People", density = 10)
# changed angle for shading
# shaded lines
hist(height, main = "Heights of people", col = "red", xlab = "Heights", ylab = "Number of People", density = 8, angle = 100)


# associativity plots (bivariate plots)

par(mfrow = c(1, 1))

marks =
  c(337,316,327,340,374,330,352,353,370,380,384,398,413,428,430,438,439,479,460,450)

hours =
  c(23,25,26,27,30,26,29,32,33,34,35,38,39,42,43,44,45,46,44,41)
# simple
plot(hours, marks)
# lines
plot(hours, marks, "l")
# line and point
plot(hours, marks, "b")
# both but overplotted
plot(hours, marks, "o")
# histogram like
plot(hours, marks, "h")
# steps
plot(hours, marks, "s")
# markers and labels
plot(hours, marks, xlab = "Number of weekly hours", ylab = "Marks obtained", main = "Marks obtained vs Number of hours per week")


# matrix scatter plot
# simple
pairs(cbind(hours, marks))
# labels and colors
pairs(cbind(hours, marks), labels = c("Study hours", "Marks obtained"), col = "red")


# scatter plots with smooth curves

scatter.smooth(hours, marks)

scatter.smooth(hours, marks, lpars = list(col = "red", lwd = 3, lty = 3))


# 3d scatter plot

install.packages("scatterplot3d")
library(scatterplot3d)

height = c(100, 125, 145, 160, 170)

weight = c(30, 35, 50, 65 ,70)

age = c(10, 15, 20, 30, 35)

scatterplot3d(height, weight, age)
# angle
scatterplot3d(height, weight, age, angle = 120)
# color
scatterplot3d(height, weight, age, color = "red")

# perspective plot

x = seq(-10, 10, length = 30)

y = x

f = function(x, y) {r = sqrt(x^2 + y^2); 10 * sin(r)/r}

z=  outer(x, y, f)

z[is.na(z)] = 1

op = par(bg = "white")

persp(x, y, z, theta = 30, phi = 30, expand = 0.5, col = "lightblue")
# shading and labels
persp(x, y, z, theta = 30, phi = 30, expand = 0.5, col = "lightblue", ltheta = 120, shade = 0.75, ticktype = "detailed", xlab = "X", ylab = "Y", zlab = "Sinc( r )")


# example 1 sum of squares of (x / y)

rm(list = ls())

x = c(10, 20, 30)
y = c(1, 2, 3)

ex1 = function(x, y)
{
  n = length(x)
  x1 = 0
  y1 = 0
  z1 = 0
  
  for(i in 1:n)
  {
    x1[i] = x[i]^2
    y1[i] = y[i]^2
    z1[i] = (x[i]/y[i])^2
  }
  sum_sq_x = sum(x1)
  sum_sq_y = sum(y1)
  sum_sq_z = sum(z1)
  
  g = sum_sq_x / sum_sq_y
  h = sum_sq_z
  
  cat("The value of g and h are ", g, " and ", h, "\n")
}  


ex1(x, y)

x=c(67,87,26,85,6,45)
y=c(54,64,22,94,20,88)
ex1(x, y)


# example 2

rm(list = ls())

g = function(x, y) 
{
  (x + log(y)) / y
}

f = function(x,y)
{
  (((g(x,y))^2)/(5+(g(x,y))^3))*(exp(g(x,y)))^(2/3)
}

x = 10
y = 20
f(x, y)

x = 1896
y = 23454
f(x, y)

# example 3

rm(list = ls())

f = function(x)
{
  if(x>0) {exp((x+log(1+x^3))/x^2)}
  else if(x==0) {10}
  else {(2+x^3)/x}
}

h = function()
{
  x = seq(-1,5,by=0.2)
  y = 0
  for(i in 1:length(x))
  {
    y[i] = f(x[i])
  }
  plot(x,y,type = "l")
}

f(123)
f(-123)
f(0)
f(8)
f(-4)

h()
