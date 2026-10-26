x = matrix( nrow=4, ncol=3, data=c(1:12) )

x

rownames(x) = c("Row 1", "Row 2", "Row 3", "Row 4")

colnames(x) = c("Column 1", "Column 2", "Column 3")

x

d = diag(5, nrow = 4, ncol = 3)
d

t(x)

rowSums(x)

colSums(x)

