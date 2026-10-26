# addition
c(2,3,5,7) + c(-2,-3, -5, 8)

c(2,3,5,7) + c(8,9)

c(2,3,5,7) + c(8,9,10)

# subtraction 
c(2,3,5,7) - c(-2,-3, -5, 8)

c(12,13,15,17) - c(8,9) 

c(12,13,15,17) - c(8,9,10)

# multiplication
c(2,3,5,7) * c(-2,-3,-5,8)

c(2,3,5,7) * c(8,9)

c(2,3,5,7) * c(8,9,10)

# division
c(24,20,8,16) / c(3,4,2,8)

c(24,20,8,16) / c(4,2) 

c(24,20,8,16) / c(4,2,8)

# types
x = 20
is.numeric(x)

is.character(x)

y = "apple"
is.character(y)

is.numeric(y)

# conversion

x = 20
is.numeric(x)

y = as.character(x)
is.numeric(y)

is.character(y)

y


y = "apple" 
is.numeric(y)

is.character(y)
z = as.numeric(y)
is.numeric(z)
is.character(z)
z

# mode

x = 6
x

mode(x)

y = "apple"
y

mode(y)

x = 6  
storage.mode(x)
x = TRUE   
storage.mode(x)

x = "apple" 
storage.mode(x)

# infinity

3/0

5+Inf

x = 5+Inf
is.finite(x)

is.infinite(x)

# calculations

2+3

2*3

2-3

3/2

2*3-4+5/6

(2+3)*5 + 5 - 10

(((2+3)*5 + 5) - 10)/2

# scalar operations
c(2,3,5,7) + 10

c(12,13,15,17) - 10

c(2,3,5,7) * 10

c(12,13,15,17) / 10

