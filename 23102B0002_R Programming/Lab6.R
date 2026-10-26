# for loop

for(i in 1:15)  {
  print(i^2)
}

for(i in c(2, 4, 6, 7)) {
  print(i^2)
}

x = c(2, 4, 6, 8 , 10, 12)

excount = function(x) {
  count = 0
  for(xval in x)  {
    if(xval / 2 > 3)  {
      count = count + 1
    }
  }
  print(count)
}

excount(x)

child = c("child1", "child2", "child3")
sweet = c("sweet1", "sweet2", "sweet3")

for(x in child) {
  for(y in sweet) {
    print(paste(x, y))
  }
}


drink = c("coffee", "lemonade", "tea", "juice")


for(x in drink) {
  if(x == "tea")  {
    break
  }
  print(x)
}

for(x in drink) {
  if(x == "lemonade") {
    next
  }
  print(x)
}


for(x in drink) {
  if(x == "tea") {
    next
  }
  print(x)
}


# while loop

i = 1

while(i < 10) {
  print(i^2)
  i = i + 2
}

sumfunc = function()  {
  sum = 0
  number = as.integer(readline(prompt = "please select any number less than 25: "))
  while(number <= 25) {
    sum = sum + number
    number = number + 1
  }
  print(paste("The sum of numbers received from the while loop: ", sum))
}

sumfunc()

# repeat

i = 1
repeat{
  print(i^2)
  i = i + 2
  if(i > 10)
    break
}

i = 1
repeat{
  i = i + 1
  if(i < 10)
    next
  print(i^2)
  if(i >= 13)
    break
}

# functions

abc = function(x) {
  x^2
}

abc(3)

abc(6)

abc(9)

xyz = function(x, y)  {
  x^2 + y^2
}

xyz(1, 2)

xyz(3, 4)

xyz(10, 10)

xyz(-2, -3)

pqr = function()  {
  for(i in 1:3) {
    print(i^3)
  }
}

pqr()

# sequences

seq(from = 2, to = 4)

seq(from = 4, to = 2)

seq(from = -4, to = 4)

seq(from = 10, to = 20, by = 2)

seq(from = 20, to = 10, by = -2)

seq(from = 3, to = -2, by = -.5)

seq(to = 10, length = 10)

seq(from = 10, length = 10)

seq(from = 10, length = 10, by = 0.1)

seq(from = 10, length = 10, by = -2)

seq(from = 10, length = 5, by = -.2)

# temp delete later

for(i in 5:7) print(i + 3*i - 2*i**2)

y = 1
while(y < 16){
  print(c("MOOC c ar helpful"))
  y = y + 2
  print(c("MOOC c ar not helpful"))
  y = y + 3
}

x = 2
while(x < 25) {
  x = x^2 - 20
  if(x==35)
    break
  print(x)
}

y <- function(x){sqrt(log(x)+x^2)-x^(3/2)+5}
y(4)

z=function(x, y){sqrt(x^2+y^2)+log((x^4+y^4))-exp(x^-2-y^-2)}

z(1,2)

sqrt(abs(seq(-10, 10, by = 5)))

seq(5, -2, by = -2)

seq(to = 8, length = 6)

-seq(to = -8, length = 6)

X = c(25, 77,35,140,8,20,120,56,19)
Y = seq(along=X)
Y

Y[X[2]]

Y[X[7]]

x = c(34, 154, 176,43,88,92,37,65,59,26,38,74,66)

x[(x<40)]

x[(x - 30 > 100)]

x[(sqrt(x^2-10*x) < 30)]

y = 15:5

y[(2:5)]


