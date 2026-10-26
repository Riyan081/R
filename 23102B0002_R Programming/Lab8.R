# merge lists

list1 = list(1, 2, 3)
list2 = list("water", "juice", "lemonade")

list1
list2

list12 = c(list1, list2)
list12

# list to vector

list1 = list(1, 2, 3)
list2 = list("water", "juice", "lemonade")

unlist(list1)

unlist(list2)

mode(list1)

mode(unlist(list1))

# appending lists

list1 = list(1, 2, 3)
list2 = list("water", "juice", "lemonade")

append(list1, 100)

append(list2, "coffee")

list1 = list(1, 2, 3)
list2 = list("water", "juice", "lemonade")

append(list1, 100, after = 2)

append(list2, "coffee", after = 2)

# removing from lists

list1 = list(1, 2, 3)
list2 = list("water", "juice", "lemonade")

list1[-2]

list2[-1]

# extracting from lists

list1 = list(1, 2, 3, 4, 5, 6)

list2 = list("water", "juice", "lemonade", "tea", "coffee", "milk")

list1[2:4]

list1[c(1, 2, 3)]

list1 = list(1, 2, 3, 4, 5, 6)

list1[2:4]

list1[c(1, 3, 5)]

list2 = list("water", "juice", "lemonade", "tea", "coffee", "milk")

list2

list2[2:4]

list2[c(1, 3, 5)]

# vector indexing

x = 1:10
x

x[(x>5)]

x[(x%%2==0)]

x[(x%%2==1)]

x[5] = NA
x

y = x[!is.na(x)]
y

mean(x)

mean(y)

x = 1:10
x

x[-(1:5)]

x[(6:10)]

z = list(a1 = 1, a2 = "c", a3 = 1:3)
z

names(z)

z = list(a1 = 1, a2 = "c", a3 = 1:3)

names(z)[3] = "c2"
z

x = c(water = 1, juice = 2,lemonade = 3)

names(x)

x["juice"]

x = 1:10
x

x[]

# mixed modes

ab = list(1, 2, 3, "X", "Y", "Z")

dim(ab) = c(2, 3)

print(ab)

mode(print(ab))

# factors

x = c(3, 4, 5, 6, 1, 2, 3, 3, 4, 4, 5, 6)

y = as.factor(x)
y

x = factor(c("lemonade", "lemonade", "juice", "lemonade", "water"))
x

class(9)

class("9")

class(print)

x = matrix(nrow = 2, ncol = 2, data = 1:4)
class(x)

brands = c("A", "A", "B", "B", "B", "B", "C")
brands

brands_fac = factor(brands)
brands_fac

unclass(brands_fac)

colours = c("blue", "green", "red")
colours

unclass(brands_fac)

colours[unclass(brands_fac)]

x = factor(c("lemonade", "lemonade", "juice", "lemonade", "water"))

unclass(x)

x = factor(c("lemonade", "lemonade", "juice", "lemonade", "water"), levels = c("water", "juice", "lemonade"))

x

unclass(x)

levels(x)

income = ordered(c("high", "high", "low", "medium", "medium"), levels = c("low", "medium", "high"))
income

unclass(income)

# formatting

print(sqrt(2))

print(sqrt(2), digits = 5)

print(sqrt(2), digits = 10)

print("apple")
print(c("apple", "banana"))
print(c("apple", "banana", 6, 10))

print(format(0.5, digits = 10, nsmall = 15))

format(c("A", "BB", "CCC", "DDDD"), width = 7, justify = "centre")

format(c("A", "BB", "CCC", "DDDD"), width = 14, justify = "centre")

x = matrix(nrow = 3, ncol = 2, data = 1:6, byrow = T)
print(x)

format(1234567, big.mark = ",")

format(12345678, big.mark = ",")

format(123456789, big.mark = ",")

format(123456789, big.mark = "  ")