# ==============================================================================
# PROJECT: Air Quality Data Exploration & Missing Value Treatment (PBL 1)
# DATASET: Beijing Air Quality Dataset (target.csv)
# ==============================================================================

# ------------------------------------------------------------------------------

# Goal: Load the dataset and inspect
# ------------------------------------------------------------------------------


tryCatch({
  
  # Check current working directory
  getwd()
  
  # Set directory if this local folder exists (safeguard for running on local PC or Colab)
  if (dir.exists("C:/SEM VII/R/Lab 1")) {
    setwd("C:/SEM VII/R/Lab 1")
  }
  
  # read.csv(): Reads 'target.csv' file from disk into an R data frame named 'air_data'
  air_data <- read.csv("target.csv")
  
  # cat(): Prints clean formatted text with newline (\n)
  cat("First 6 records per col:\n")
  # head(): Shows the first 6 rows of the dataset to give a quick preview of columns and data
  print(head(air_data))
  
  cat("\nStructure:\n")
  # str(): Displays the internal structure of the data frame (column types: int, num, chr)
  print(str(air_data))
  
  cat("\nRows and Columns:\n")
  # dim(): Returns a vector of dimensions (Number of Rows, Number of Columns) -> (35064, 18)
  print(dim(air_data))
  
  cat("\nAny missing values?\n")
  # is.na(): Checks every single cell for missing values (returns TRUE/FALSE)
  # any(): Returns TRUE if at least one TRUE exists in the entire dataset
  print(any(is.na(air_data)))
  
  cat("\nTotal missing values:\n")
  # sum(is.na()): Since in R TRUE=1 and FALSE=0, summing counts the total missing cells
  print(sum(is.na(air_data)))
  
},

# error callback: If an error occurs (e.g. file not found), this function catches and prints it
error = function(e){
  cat("Error:", e$message)
})


# ------------------------------------------------------------------------------
# 
# Goal: Show how R distinguishes between NA (missing), NULL (empty), and NaN (undefined math)
# ------------------------------------------------------------------------------
{
  # --- 1. NA (Not Available / Missing Value) ---
  cat("\nExample of NA values from PM2.5 column:\n")
  # Filter rows where PM2.5 is NA and select specific date/time columns to view
  ex1 <- air_data[is.na(air_data$PM2.5), c("year", "month", "day", "hour", "PM2.5")]
  # Preview first 6 rows containing NA
  print(head(ex1))
  
  cat("\nChecking NA:\n")
  # is.na() tests each value; returns TRUE for missing values
  print(is.na(head(ex1$PM2.5)))
  
  
  # --- 2. NULL (Absence of an object / Empty value) ---
  # Assign NULL: ex2 does not contain any value or data structure
  ex2 <- NULL
  
  cat("\nExample of NULL:\n")
  print(ex2)          # Prints NULL
  # is.null(): Tests whether the variable is NULL
  print(is.null(ex2)) # Returns TRUE
  
  
  # --- 3. NaN (Not a Number - Mathematical undefined result) ---
  # Dividing 0 by 0 is mathematically undefined; in R this produces NaN
  ex3 <- 0 / 0
  
  cat("\nExample of NaN:\n")
  print(ex3)         # Prints NaN
  # is.nan(): Tests whether the value is NaN
  print(is.nan(ex3)) # Returns TRUE
}


# ------------------------------------------------------------------------------
# 
# Goal: Create a reusable function to compute total missing count,
#       and missing percentage for selected variables.
# ------------------------------------------------------------------------------
{
  # Define a user-defined function named missing_summary that takes a dataframe as input
  missing_summary <- function(data){
    
    # Vector of variables we want to analyze for air quality
    variables <- c("PM2.5", "PM10", "SO2", "NO2", "TEMP", "WSPM", "wd")
    
    # Initialize an empty data frame with column names and types to store our summary report
    summary_df <- data.frame(
      Variable = character(),
      Total_Records = numeric(),
      Missing_Values = numeric(),
      Missing_Percentage = numeric(),
      stringsAsFactors = FALSE
    )
    
    # Loop through each variable name in the 'variables' vector
    for(var in variables){
      
      # nrow(data): Total number of rows in the dataset
      total <- nrow(data)
      
      # sum(is.na(...)): Count missing values in the current column
      missing <- sum(is.na(data[[var]]))
      
      # Calculate the percentage of missing values and round to 2 decimal places
      percent <- round((missing / total) * 100, 2)
      
      # rbind(): Appends a new row to summary_df with the stats for this variable
      summary_df <- rbind(summary_df,
                          data.frame(
                            Variable = var,
                            Total_Records = total,
                            Missing_Values = missing,
                            Missing_Percentage = percent
                          ))
      
      # Warning check: If missingness is > 20%, raise a warning to alert the analyst
      if(percent > 20){
        warning(paste(var,
                      "contains more than 20% missing values (",
                      percent, "% )"))
      }
    }
    
    # Return the completed summary table
    return(summary_df)
  }
} # Function definition block ends

# Caller block: Execute the function on air_data
{
  # Call missing_summary() with our dataset
  missing_report <- missing_summary(air_data)
  
  cat("\nMissing Value Summary:\n")
  # Display the table
  print(missing_report)
}


# ------------------------------------------------------------------------------
# TASK 4: Handling Invalid Mathematical Results (NaN and Infinite Values)
# Goal: Compute a derived ratio (PM2.5 / PM10) and safely handle division by zero.
# ------------------------------------------------------------------------------
{
  # Calculate ratio between PM2.5 (fine particles) and PM10 (coarse particles)
  air_data$pollution_ratio <- air_data$PM2.5 / air_data$PM10
  
  # Count invalid values created by division:
  # 1. Total NA values
  na_count <- sum(is.na(air_data$pollution_ratio))
  # 2. Total NaN values (e.g. if 0 / 0 occurred)
  nan_count <- sum(is.nan(air_data$pollution_ratio))
  # 3. Positive infinity (e.g. positive number divided by 0)
  pos_inf <- sum(air_data$pollution_ratio == Inf, na.rm = TRUE)
  # 4. Negative infinity (e.g. negative number divided by 0)
  neg_inf <- sum(air_data$pollution_ratio == -Inf, na.rm = TRUE)
  
  cat("NA Values:", na_count, "\n")
  cat("NaN Values:", nan_count, "\n")
  cat("Positive Infinity:", pos_inf, "\n")
  cat("Negative Infinity:", neg_inf, "\n")
  
  # Clean invalid values: Replace any NaN or Infinite values with standard NA
  air_data$pollution_ratio[
    is.nan(air_data$pollution_ratio) |
      is.infinite(air_data$pollution_ratio)
  ] <- NA

  #It makes invalid results easier to identify.
  #It helps us handle missing data consistently.
  #It reduces problems in later statistical calculations and analysis.

  # Verify replacement results
  cat("\nAfter Replacement:\n")
  cat("NA Values:", sum(is.na(air_data$pollution_ratio)), "\n")
  cat("NaN Values:", sum(is.nan(air_data$pollution_ratio)), "\n")
  cat("Infinite Values:", sum(is.infinite(air_data$pollution_ratio)), "\n")
}


# ------------------------------------------------------------------------------
# SNAPSHOT: Save "Before Cleaning" counts
# Goal: Record the exact count of missing values before imputation for Task 8 & 9.
# ------------------------------------------------------------------------------
{
  # sapply(): Applies sum(is.na(x)) across each selected column and returns a named vector
  before_missing <- sapply(
    air_data[c("PM2.5", "PM10", "SO2", "NO2", "TEMP", "WSPM", "wd")],
    function(x) sum(is.na(x))
  )
}


# ------------------------------------------------------------------------------
# TASK 5: Numerical Data Imputation using Median
# Goal: Fill missing values in numerical columns using their median value.
# .
# ------------------------------------------------------------------------------
{
  # List of numerical columns requiring imputation
  numeric_variables <- c("PM2.5", "PM10", "SO2", "NO2", "TEMP", "WSPM")
  
  # Loop through each numerical variable
  for(var in numeric_variables){
    
    # Check if the column actually exists in the data frame
    if(var %in% names(air_data)){
      
      # Count missing values before imputation
      before <- sum(is.na(air_data[[var]]))
      
      # Calculate median ignoring existing NA values (na.rm = TRUE)
      median_value <- median(air_data[[var]], na.rm = TRUE)
      
      # Replace all NA values in this column with the calculated median
      air_data[[var]][is.na(air_data[[var]])] <- median_value
      
      # Count missing values after imputation (should be 0)
      after <- sum(is.na(air_data[[var]]))
      
      # Print summary for this column
      cat("\n-----------------------------\n")
      cat("Variable:", var, "\n")
      cat("Missing Before:", before, "\n")
      cat("Median Used:", median_value, "\n")
      cat("Missing After:", after, "\n")
      
    } else {
      cat("\nColumn", var, "does not exist.\n")
    }
  }
}


# ------------------------------------------------------------------------------
# TASK 6: Categorical Data Imputation using Mode
# Goal: Fill missing values in categorical wind direction ('wd') with the mode.
# Reason: 'wd' has text categories (e.g. 'NNW', 'SE'); median/mean cannot be computed on text.
# ------------------------------------------------------------------------------
{
  # Custom function to calculate statistical Mode (most frequent value)
  calculate_mode <- function(x){
    
    # Remove any existing NA values so they don't count as a category
    x <- x[!is.na(x)]
    
    # Get distinct unique values
    unique_values <- unique(x)
    
    # match(): Finds positions of matches
    # tabulate(): Counts occurrences of each unique value
    # which.max(): Finds the index with the highest frequency count
    unique_values[which.max(tabulate(match(x, unique_values)))]
  }
  
  # Count missing values in 'wd' before cleaning
  before <- sum(is.na(air_data$wd))
  
  # Compute the most common wind direction
  mode_value <- calculate_mode(air_data$wd)
  
  # Replace all NA values in 'wd' with the mode value
  air_data$wd[is.na(air_data$wd)] <- mode_value
  
  # Count missing values after cleaning (should be 0)
  after <- sum(is.na(air_data$wd))
  
  # Print mode imputation results
  cat("Mode of wd:", mode_value, "\n")
  cat("Missing Before:", before, "\n")
  cat("Missing After:", after, "\n")
}


# ------------------------------------------------------------------------------
# TASK 7: Defensive Programming & Error Handling with tryCatch()
# Goal: Build a safe, production-grade function that validates inputs before cleaning.
# ------------------------------------------------------------------------------
{
  clean_variable <- function(data, variable_name){
    
    tryCatch({
      
      # Validation 1: Check if column exists in the dataset
      if(!(variable_name %in% names(data))){
        stop("Variable does not exist.")
      }
      
      # Validation 2: Ensure column is numeric (median only applies to numbers)
      if(!is.numeric(data[[variable_name]])){
        stop("Variable is not numerical.")
      }
      
      # Validation 3: Ensure column is not 100% empty
      if(all(is.na(data[[variable_name]]))){
        stop("Variable contains only missing values.")
      }
      
      # Compute median
      median_value <- median(data[[variable_name]], na.rm = TRUE)
      
      # Validation 4: Ensure median was computed successfully
      if(is.na(median_value)){
        stop("Median could not be calculated.")
      }
      
      # Replace NA with median
      data[[variable_name]][is.na(data[[variable_name]])] <- median_value
      
      cat(variable_name, "cleaned successfully.\n")
      
      return(data[[variable_name]])
      
    },
    
    # Error block: Catches any stop() message and prints it without terminating the script
    error = function(e){
      cat("Error:", e$message, "\n")
      return(NULL)
    })
  }
}

# --- Trial Test Cases for Task 7 ---
# These 3 tests intentionally verify that our error checks work properly!
{
  # Test 1: Valid numeric variable -> Should succeed
  clean_variable(air_data, "PM2.5")
  
  # Test 2: Non-existent variable -> Should safely catch "Variable does not exist."
  clean_variable(air_data, "XYZ")
  
  # Test 3: Categorical variable -> Should safely catch "Variable is not numerical."
  clean_variable(air_data, "wd")
}


# ------------------------------------------------------------------------------
# TASK 8: Verification & Comparison Table
# Goal: Compare missing values before vs after cleaning and verify completion.
# ------------------------------------------------------------------------------
{
  # Calculate missing count after imputation for all target variables
  after_missing <- sapply(
    air_data[c("PM2.5", "PM10", "SO2", "NO2", "TEMP", "WSPM", "wd")],
    function(x) sum(is.na(x))
  )
  
  # Construct a comparison data frame
  comparison_table <- data.frame(
    Variable = names(before_missing),
    Missing_Before = before_missing,
    Missing_After = after_missing,
    Values_Replaced = before_missing - after_missing
  )
  
  # Print the comparison table
  print(comparison_table)
  
  # Verify if all missing counts are now 0
  if(all(after_missing == 0)){
    cat("Cleaning complete\n")
  } else {
    cat("Cleaning incomplete\n")
  }
}


# ------------------------------------------------------------------------------
# TASK 9: Visualization with Side-by-Side Barplot
# Goal: Graphically illustrate missing values before (red) and after (green = 0).
# ------------------------------------------------------------------------------
{
  # Combine before and after missing vectors into a 2-row matrix
  missing_matrix <- rbind(before_missing, after_missing)
  
  # barplot(): Creates a bar chart in base R
  barplot(
    missing_matrix,
    beside = TRUE,                         # Groups bars side-by-side instead of stacking
    col = c("red", "green"),               # Red = Before cleaning, Green = After cleaning
    names.arg = names(before_missing),     # Labels for the X-axis (variable names)
    main = "Missing Values Before and After Data Cleaning", # Title of chart
    xlab = "Variables",                    # X-axis label
    ylab = "Number of Missing Values",     # Y-axis label
    legend.text = c("Before Cleaning", "After Cleaning")    # Chart legend
  )
}


# ------------------------------------------------------------------------------
# TASK 10: Export Cleaned Dataset & Final Summary
# Goal: Save the clean dataset to disk as a CSV file.
# ------------------------------------------------------------------------------
{
  # write.csv(): Writes the cleaned data frame to a new CSV file
  # row.names = FALSE: Prevents R from writing an extra unneeded column of row numbers (1, 2, 3...)
  write.csv(
    air_data,
    "cleanedTarget.csv",
    row.names = FALSE
  )
  
  cat("\nCleaned data saved as 'cleanedTarget.csv\n")
}

# Display final analytical summary report
print("The Beijing Air Quality dataset mentioned in the assignment was imported into the studio environment. To identify missing and invalid values, we have utilized the data processing ability of R. Different types of missing data (NA, NULL, and NaN) were demonstrated using appropriate R functions. We created a user defined function to generate a summary of missing values for selected variables. Numerical variables (PM2.5, PM10, SO2, NO2, TEMP, and WSPM) were cleaned by replacing missing values with their respective 'median' values, while missing values in the categorical variable (wd) were replaced with the mode. Error handling was implemented using tryCatch() to improve program reliability in case of failure. The comparison table and bar chart confirmed that all selected missing values were successfully handled, resulting in a clean dataset suitable for further processing.")
