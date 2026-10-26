# sequences

1:10

10:1

5:15

15:5

-1:-10

-10:-1

-5:-15

-15:-1

1.23:10

1.23:10.54

10.54:2.23

-1.23:-10

-5.23:6

seq(10)

seq(1:10)

x = 2

seq(1, x, x/10)

x = 50

seq(0, x, x/10)

x = seq(1, 50, 1/2)
x

y = 2*x
y

#sequences index vector

x = c(9,8,7,6)

ind = seq(along = x)
ind

x[ind[2]]

Sys.time()

Sys.Date()

# date time sequences

seq(as.Date("2010-01-01"), as.Date("2017-01-01"), by = "years")

seq(as.Date("2017-01-01"), by = "days",length = 6)

seq(as.Date("2017-01-01"), by = "months",length = 6)

seq(as.Date("2017-01-01"),by = "years",length = 6)

startdate = as.Date("2016-1-1")

enddate = as.Date("2017-1-1")

out = seq(enddate, startdate, by = "-1 month")
out

# alphabet sequences

letters

letters[1:3]

letters[3:1]

letters[21:23]

letters[2]

LETTERS

LETTERS[1:3]

LETTERS[3:1]

LETTERS[21:23]

LETTERS[2]

# repeats

rep(3.5, times=10)

rep(1:4, 2)

x = 1:4
x

rep(x,times=3)

rep(x, each=3)

rep(1:4, each=2)
rep(1:4,each=2,times=3)
rep(1:4,times=3,each=2)

rep(1:4,2:5)

ans = seq(from=2,to=8,by=2)
ans

rep(1:4,ans)

x = matrix(nrow=2, ncol=2, data=1:4, byrow=T)
x

rep(x,3)

rep(c("a","b","c"),2)

rep(c("apple","banana","cake"),2)

rep(2, length.out=5)

rep(2, length=5)

rep(c(2,3), length=5)

rep(c(2,3,4), length=5)

rep("apple", length=5)

rep(c("a","b","c"), length=2)

rep(c("a","b","c"), length=5)

# sorting

y=c(8,5,7,6)
y

sort(y)

sort(y,decreasing = TRUE)

# ordering

y=c(9,8,5,7,6)
y

order(y)

order(y,decreasing = TRUE)

# mode

mode(2.432)

mode(c(3,4,5,6,7,8))

mode("India")

mode(c("India","CANADA"))

mode(factor(c("UP","MP")))

mode(data.frame(x=1:2, y=c("India","USA")))

mode(print)

# lists

x1 = matrix(nrow=2, ncol=2, data=1:4, byrow=T) 
x2 = matrix(nrow=2, ncol=2, data=5:8, byrow=T) 
x1

x2

x1+x2

x1 = matrix(nrow=2, ncol=2, data=1:4, byrow=T) 
x2 = matrix(nrow=2, ncol=2, data=5:8, byrow=T) 
x1
x2

matlist = list(x1, x2)

matlist

matlist[1] 

matlist[2] 

z1 = list( c("water", "juice", "lemonade"), 
           rep(1:4, each=2), matrix(data=5:8, nrow=2, 
                                    ncol=2, byrow=T) ) 

z1 

z1[[1]] 

z1[1][2]

z1[[1]][2]