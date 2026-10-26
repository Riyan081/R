library(readxl)
library(dplyr)
library(jsonlite)
library(DBI)
library(RSQLite)

# import the file into env
raw <- read_excel("Online Retail.xlsx", sheet = 1)

# splits the sheets
transactions <- raw %>%
  select(InvoiceNo, StockCode, CustomerID, Quantity, InvoiceDate)

products <- raw %>%
  distinct(StockCode, .keep_all = TRUE) %>%
  select(StockCode, Description, UnitPrice)

customers <- raw %>%
  distinct(CustomerID, .keep_all = TRUE) %>%
  select(CustomerID, Country)

# writes the contents of the sheets into separate files (csv for transactions, json for products and excel for customers)
write.csv(transactions, "transactions.csv", row.names = FALSE)
write_json(products, "products.json")
writexl::write_xlsx(customers, "customers.xlsx")

transactions <- read.csv("transactions.csv", stringsAsFactors = FALSE)
products <- fromJSON("products.json")
customers <- read_excel("customers.xlsx")

# cleaning each dataset
transactions <- transactions %>%
  filter(!is.na(CustomerID), !is.na(InvoiceNo), !is.na(StockCode)) %>%
  distinct() %>%
  filter(Quantity > 0)

products <- products %>%
  filter(!is.na(StockCode), !is.na(UnitPrice)) %>%
  distinct(StockCode, .keep_all = TRUE) %>%
  filter(UnitPrice > 0)

customers <- customers %>%
  filter(!is.na(CustomerID)) %>%
  distinct(CustomerID, .keep_all = TRUE)

# only keeps related data. in case some data has no match in other tables, it will be gone
integrated <- transactions %>%
  inner_join(products, by = "StockCode") %>%
  left_join(customers, by = "CustomerID") %>%
  mutate(Revenue = Quantity * UnitPrice)

dim(integrated)
sum(is.na(integrated$Country))

# statistics  and grouping
total_revenue <- sum(integrated$Revenue)

top5_products <- integrated %>%
  group_by(StockCode, Description) %>%
  summarise(Revenue = sum(Revenue), .groups = "drop") %>%
  arrange(desc(Revenue)) %>%
  head(5)

top5_countries <- integrated %>%
  group_by(Country) %>%
  summarise(Revenue = sum(Revenue), .groups = "drop") %>%
  arrange(desc(Revenue)) %>%
  head(5)

customer_value <- integrated %>%
  group_by(CustomerID) %>%
  summarise(TotalValue = sum(Revenue), .groups = "drop")

top5_customers <- customer_value %>%
  arrange(desc(TotalValue)) %>%
  head(5)

customer_value <- customer_value %>%
  mutate(Segment = case_when(
    TotalValue < 500 ~ "Low Value",
    TotalValue < 2000 ~ "Medium Value",
    TotalValue < 5000 ~ "High Value",
    TRUE ~ "Premium"
  ))

country_revenue <- integrated %>%
  group_by(Country) %>%
  summarise(Revenue = sum(Revenue), .groups = "drop") %>%
  arrange(desc(Revenue))

high_market <- country_revenue %>% slice(1)
low_market <- country_revenue %>% slice(n())

# sqlite storage tasks for storing the above analysis and data
con <- dbConnect(RSQLite::SQLite(), "retail_sales.db")
dbWriteTable(con, "retail_sales", integrated, overwrite = TRUE)

query1 <- dbGetQuery(con, "
  SELECT CustomerID, SUM(Revenue) AS TotalRevenue
  FROM retail_sales
  GROUP BY CustomerID
  ORDER BY TotalRevenue DESC
  LIMIT 5
")

query2 <- dbGetQuery(con, "
  SELECT Country, SUM(Revenue) AS TotalRevenue
  FROM retail_sales
  GROUP BY Country
  ORDER BY TotalRevenue DESC
")

dbDisconnect(con)

# console output for analysis
print(total_revenue)
print(top5_products)
print(top5_countries)
print(top5_customers)
print(high_market)
print(low_market)
print(query1)
print(query2)


# summary
# split the Excel file into 3 datasets
# cleaned nulls/duplicates/invalid values 
# joined transactions+products (inner) with customers (left) 
# computed Revenue, aggregated top products/countries/customers with group_by/summarise 
# segmented customers with case_when 
# saved everything to SQLite and queried it back to confirm.

# business insights from output
# revenue is heavily concentrated in a single market — United Kingdom, at over 82% of total sales.
# total revenue was 10,752,840, and the UK alone contributed 8,861,857. 
# the business is effectively a UK native with less international outreach. 
# this signals limited geographic diversification.

# the top 5 customers alone generated 1,303,492 — about 12% of total revenue 
# customer 18102 contributed 408,760 (nearly 4% of all revenue) individually.
# loss of such customers could lead to an obvious collapse of the business

# Saudi Arabia is the weakest market, and the gap suggests that it is a reachability issue and not a demand issue
# this is because the major contributors are in proximity of UK and Europe