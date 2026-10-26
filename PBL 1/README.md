# PBL 1: Air Quality Data Exploration & Missing Value Treatment

---

## 📌 1. Project Overview & Title
* **Project Title:** Air Quality Data Exploration & Missing Value Treatment
* **Course:** R Programming Laboratory (PBL 1)
* **Dataset Used:** Beijing Multi-Site Air-Quality Data (`target.csv` / Aotizhongxin Monitoring Station)
* **Primary Script:** `Task1.R`
* **Output Artifacts:** `cleanedTarget.csv`, `Bar chart of comparison between missing values before and after cleaning.jpg`

---

## 🚨 2. Problem Statement & Real-World Context
In environmental monitoring, air quality stations collect continuous real-time data using physical sensors and wireless telemetry. In real-world sensor networks, data collection is prone to:
1. **Sensor Malfunctions & Power Cuts:** Missing observations (`NA`).
2. **Transmission & Calculation Errors:** Undefined values like division-by-zero (`NaN`, `Inf`).
3. **Data Gaps:** Missing weather recordings such as wind direction and ambient temperature.

Raw data with missing and invalid entries cannot be directly fed into machine learning pipelines or statistical algorithms without causing distortions, biased estimations, or program crashes. Therefore, a structured data exploration and missing-value imputation pipeline is required to clean the data without altering its underlying distribution.

---

## 🎯 3. Project Objectives
1. **Ingest & Explore:** Load real-world time-series air quality data and analyze its dimensions, structure, and missing value volume.
2. **Demonstrate R Missingness Types:** Illustrate how R handles and distinguishes between `NA` (missing), `NULL` (empty object), and `NaN` (mathematical error).
3. **Automate Quality Audits:** Develop a user-defined function to calculate missing counts and percentages per variable, alerting when missingness exceeds threshold limits (>20%).
4. **Sanitize Derived Features:** Calculate a secondary pollution index (`PM2.5 / PM10`) and sanitize edge cases (`0/0` producing `NaN`, `x/0` producing `Inf`).
5. **Implement Statistical Imputation:**
   * Apply **Median Imputation** on continuous numerical pollutants and temperature to protect against extreme outlier spikes.
   * Apply **Mode Imputation** on categorical wind direction (`wd`).
6. **Defensive Programming:** Encapsulate cleaning logic inside an error-handled function using `tryCatch()` to validate inputs before processing.
7. **Validate & Export:** Graphically verify zero post-cleaning missingness via comparative bar charts and export a sanitized production dataset (`cleanedTarget.csv`).

---

## 📊 4. Dataset Description & Key Attributes

The dataset comprises **35,064 hourly records** across **18 attributes**:

| Attribute | Data Type | Description |
| :--- | :--- | :--- |
| `No` | Integer | Row index / record counter |
| `year`, `month`, `day`, `hour` | Integer | Temporal timestamps (2013 - 2017) |
| `PM2.5` | Numeric | Fine particulate matter ($\mu g/m^3$) — high health hazard |
| `PM10` | Numeric | Inhalable coarse particles ($\mu g/m^3$) |
| `SO2` | Numeric | Sulfur dioxide concentration |
| `NO2` | Numeric | Nitrogen dioxide concentration |
| `CO`, `O3` | Numeric/Int | Carbon monoxide & Ozone levels |
| `TEMP` | Numeric | Ambient temperature in Celsius |
| `PRES`, `DEWP`, `RAIN` | Numeric | Pressure, Dew point, and Precipitation |
| `wd` | Character | 16-compass wind direction (e.g., "NNW", "ENE", "NE") |
| `WSPM` | Numeric | Wind speed in meters per second ($m/s$) |
| `station` | Character | Monitoring site name ("Aotizhongxin") |

---

## 🛠️ 5. Step-by-Step Task Breakdown (`Task1.R`)

### Task 1: Data Ingestion & Structural Inspection
* **Goal:** Safely load `target.csv` into an R data frame and get an overview of dimensions and missing values.
* **Key Functions:**
  * `read.csv("target.csv")`: Parses the CSV file into an R data frame.
  * `head(air_data)`: Inspects first 6 rows.
  * `str(air_data)`: Reveals internal structure, column data types, and sizes.
  * `dim(air_data)`: Returns `[35064, 18]` (rows and columns).
  * `sum(is.na(air_data))`: Sums all boolean `TRUE` (1) flags for missing entries across all columns (**Total: 7,271 missing values**).
  * `tryCatch()`: Wraps file reading to prevent execution halts if paths are misconfigured.

---

### Task 2: Demonstration of Missing and Invalid Types (`NA`, `NULL`, `NaN`)
* **`NA` (Not Available):** Represents unobserved/missing data in a vector.
  ```r
  ex1 <- air_data[is.na(air_data$PM2.5), c("year", "month", "day", "hour", "PM2.5")]
  is.na(head(ex1$PM2.5)) # Evaluates to TRUE
  ```
* **`NULL` (Non-Existence):** Represents an empty object with no memory or length.
  ```r
  ex2 <- NULL
  is.null(ex2)          # Evaluates to TRUE
  ```
* **`NaN` (Not a Number):** Represents mathematically undefined calculations.
  ```r
  ex3 <- 0 / 0          # Division by zero
  is.nan(ex3)           # Evaluates to TRUE
  ```

---

### Task 3: Automated Missing Value Summary Function
* **Goal:** Write a reusable function `missing_summary(data)` to analyze selected variables (`PM2.5`, `PM10`, `SO2`, `NO2`, `TEMP`, `WSPM`, `wd`).
* **Implementation:**
  * Calculates `total <- nrow(data)`.
  * Computes missing counts: `missing <- sum(is.na(data[[var]]))`.
  * Computes percentage: `percent <- round((missing / total) * 100, 2)`.
  * Accumulates results in `summary_df` using `rbind()`.
  * Flags variables with `warning()` if missingness exceeds **20%**.
* **Observed Missingness in Dataset:**
  * `NO2`: 1,023 missing (2.92%)
  * `SO2`: 935 missing (2.67%)
  * `PM2.5`: 925 missing (2.64%)
  * `PM10`: 718 missing (2.05%)
  * `wd`: 81 missing (0.23%)
  * `TEMP`: 20 missing (0.06%)
  * `WSPM`: 14 missing (0.04%)

---

### Task 4: Feature Calculation & Handling Invalid Math
* **Goal:** Create a derived metric `pollution_ratio` ($\frac{\text{PM2.5}}{\text{PM10}}$) to measure the proportion of fine to coarse particles.
* **Edge Case Handling:**
  * If $\text{PM10} = 0$, division yields `Inf` or `-Inf`.
  * If $\text{PM2.5} = 0$ and $\text{PM10} = 0$, division yields `NaN`.
* **Sanitization:** Converts all `NaN` and `infinite` entries to standard `NA` using:
  ```r
  air_data$pollution_ratio[is.nan(air_data$pollution_ratio) | is.infinite(air_data$pollution_ratio)] <- NA
  ```
* **Benefit:** Unifies all invalid calculations under standard R `NA`, enabling downstream tools to treat them consistently.

---

### Task 5: Numerical Imputation (Median)
* **Target Columns:** `PM2.5`, `PM10`, `SO2`, `NO2`, `TEMP`, `WSPM`
* **Method:** Replaced missing values with the **Median**:
  ```r
  median_value <- median(air_data[[var]], na.rm = TRUE)
  air_data[[var]][is.na(air_data[[var]])] <- median_value
  ```
* **Why Median over Mean?**
  Air pollutant distributions are heavily right-skewed with extreme pollution spikes (outliers). The arithmetic mean is sensitive to outliers and would artificially inflate the imputed values. The median represents the true 50th percentile and remains robust.

| Variable | Missing Before | Median Imputed | Missing After |
| :--- | :---: | :---: | :---: |
| `PM2.5` | 925 | **58.0** | **0** |
| `PM10` | 718 | **87.0** | **0** |
| `SO2` | 935 | **9.0** | **0** |
| `NO2` | 1,023 | **53.0** | **0** |
| `TEMP` | 20 | **14.5** | **0** |
| `WSPM` | 14 | **1.4** | **0** |

---

### Task 6: Categorical Imputation (Mode)
* **Target Column:** `wd` (Wind Direction)
* **Method:** Since wind direction contains strings ("NNW", "ENE", etc.), mathematical mean/median cannot be calculated. Mode imputation (most frequent category) is applied.
* **Custom Function:**
  ```r
  calculate_mode <- function(x){
    x <- x[!is.na(x)]
    unique_values <- unique(x)
    unique_values[which.max(tabulate(match(x, unique_values)))]
  }
  ```
* **Result:** The computed mode is **`NE`** (North-East). All 81 missing directions were replaced with `"NE"`. Missing after: **`0`**.

---

### Task 7: Defensive Programming with `tryCatch()`
* **Function:** `clean_variable(data, variable_name)`
* **Guard Clauses & Input Validations:**
  1. `!(variable_name %in% names(data))` $\rightarrow$ throws error: *"Variable does not exist."*
  2. `!is.numeric(data[[variable_name]])` $\rightarrow$ throws error: *"Variable is not numerical."*
  3. `all(is.na(data[[variable_name]]))` $\rightarrow$ throws error: *"Variable contains only missing values."*
  4. `is.na(median_value)` $\rightarrow$ throws error: *"Median could not be calculated."*
* **Trial Tests Run in Code:**
  * `clean_variable(air_data, "PM2.5")` $\rightarrow$ Output: `PM2.5 cleaned successfully.`
  * `clean_variable(air_data, "XYZ")` $\rightarrow$ Safely caught: `Error: Variable does not exist.`
  * `clean_variable(air_data, "wd")` $\rightarrow$ Safely caught: `Error: Variable is not numerical.`
* **Outcome:** Validates that production pipelines fail gracefully without crashing the runtime.

---

### Task 8: Verification & Comparison Table
Constructs a validation matrix comparing missing values across all target columns:

```text
      Variable Missing_Before Missing_After Values_Replaced
PM2.5    PM2.5            925             0             925
PM10      PM10            718             0             718
SO2        SO2            935             0             935
NO2        NO2           1023             0            1023
TEMP      TEMP             20             0              20
WSPM      WSPM             14             0              14
wd          wd             81             0              81
```
* **Verification condition:** `if(all(after_missing == 0))` evaluated to **TRUE**, outputting `"Cleaning complete"`.

---

### Task 9: Visualization (`barplot`)
* **Chart:** Grouped Bar Chart (`barplot(..., beside = TRUE)`)
  * **Red Bars:** Missing values before cleaning.
  * **Green Bars:** Missing values after cleaning (height = 0).
* **Interpretation:** The presence of red bars and the absence of green bars visually confirms that 100% of missing data in the selected attributes was resolved.

---

### Task 10: Export Clean Data
* **Command:** `write.csv(air_data, "cleanedTarget.csv", row.names = FALSE)`
* **Result:** Saved cleaned dataframe into `cleanedTarget.csv` without extraneous row index columns.

---

## 🎓 6. Teacher / Viva Defense FAQ (Top 10 Questions & Answers)

### Q1: What is the main objective of this lab/project?
> **Answer:** "To ingest the real-world Beijing Air Quality dataset, identify and categorize different types of missing values (`NA`, `NULL`, `NaN`), and build a clean data preparation pipeline using median imputation for continuous variables and mode imputation for categorical variables."

### Q2: Why did you use Median instead of Mean for numerical columns?
> **Answer:** "Air pollution data has extreme spikes during pollution events (outliers), making the distribution skewed. The mean is strongly pulled by outliers, which would artificially distort the data. The median represents the middle 50th percentile and is robust against extreme values."

### Q3: Why couldn't you use Mean or Median for wind direction (`wd`)?
> **Answer:** "Wind direction is a qualitative/categorical variable containing string labels like 'NNW' or 'ENE'. You cannot perform arithmetic calculations on text labels, so we used the mode (the most frequently observed wind direction), which was found to be 'NE'."

### Q4: What is the difference between `NA`, `NULL`, and `NaN` in R?
> **Answer:** 
> * **`NA` (Not Available):** A missing data indicator in a vector; space is reserved, but the measurement is absent.
> * **`NULL`:** Represents the complete absence of an object or an empty data structure with zero length.
> * **`NaN` (Not a Number):** A numeric result of an undefined mathematical operation, such as `0 / 0`.

### Q5: Why did you write `ex3 <- 0 / 0` in Task 2?
> **Answer:** "Because the raw CSV file only contains unrecorded values (`NA`), but the assignment required us to demonstrate all three types of missingness. `0 / 0` is the standard way in R to generate and detect a `NaN` using `is.nan()`."

### Q6: What did you do with division-by-zero errors in the pollution ratio in Task 4?
> **Answer:** "When computing `PM2.5 / PM10`, cases where PM10 was zero produced `Inf` or `NaN`. We used conditional indexing to replace all `NaN` and infinite values with standard `NA` to maintain consistent missingness handling across R."

### Q7: Why are there 'Error:' messages printed in Task 7? Did the script crash?
> **Answer:** "No, the script did not crash. Those errors were intentional test cases to verify defensive programming using `tryCatch()`. We tested a non-existent column ('XYZ') and a categorical column ('wd') to demonstrate that our custom cleaning function catches invalid inputs gracefully without halting the application."

### Q8: Why does the bar chart in Task 9 only show red bars? Where are the green bars?
> **Answer:** "Red represents missing values before cleaning, and Green represents missing values after cleaning. Because every single missing value was successfully replaced, the post-cleaning count is exactly 0. A bar of height 0 sits flat on the axis, proving that 100% of missing values were cleaned."

### Q9: Why did you use `row.names = FALSE` in `write.csv()`?
> **Answer:** "By default, R writes a numeric row index (1, 2, 3...) as the first unnamed column in the exported CSV. Setting `row.names = FALSE` prevents creating redundant index columns."

### Q10: What is the purpose of `na.rm = TRUE` inside `median()`?
> **Answer:** "In R, if you compute `median(x)` on a vector containing even a single `NA`, R returns `NA` by default. Setting `na.rm = TRUE` instructs R to ignore missing values while calculating the median of the available data."

---

## 📁 7. File Structure
```
PBL 1/
├── README.md                                                          # Project Documentation
├── Task1.R                                                            # Main executable R script
├── target.csv                                                         # Raw Beijing Air Quality dataset
├── cleanedTarget.csv                                                  # Processed clean dataset
└── Bar chart of comparison between missing values before and after cleaning.jpg # Output plot
```
