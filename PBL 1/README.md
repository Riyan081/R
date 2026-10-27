# PBL 1: Air Quality Data Exploration & Missing Value Treatment

---

## 📌 1. Project Overview & Title
* **Project Title:** Air Quality Data Exploration & Missing Value Treatment
* **Course:** R Programming Laboratory (PBL 1)
* **Dataset Used:** Beijing Multi-Site Air-Quality Data (`target.csv` / Aotizhongxin Monitoring Station)
* **Primary Script:** `Task1.R`
* **Output Artifacts:** `cleanedTarget.csv`, `Bar chart of comparison between missing values before and after cleaning.jpg`

---

## 🚨 2. What is the Problem? (Simple Explanation)
In real life, outdoor air quality sensors run 24/7. Because of power cuts, sensor faults, or rain damage, **sensors often fail to record data**. 

This leaves **blanks (missing values)** in the data:
* If you give incomplete data to an AI model or a graph, **it will crash or give wrong answers**.
* If you just delete rows with missing data, you throw away valuable records.
* Therefore, we have to **fill in the missing values smartly** without messing up the real trends. This process is called **Imputation**.

---

## 🎯 3. What are We Trying to Do? (Objectives)
1. **Load the data** into R and check how big it is.
2. **Find all missing values** across pollutants (PM2.5, PM10, etc.) and weather conditions.
3. **Understand R's missing types:** Learn the difference between `NA` (missing), `NULL` (empty object), and `NaN` (math error like 0/0).
4. **Fill numerical data using the Median:** (PM2.5, PM10, SO2, NO2, Temperature, Wind Speed).
5. **Fill text data using the Mode:** (Wind Direction `wd`, using the most common direction).
6. **Protect against crashes:** Use error handling (`tryCatch`) so the program handles bad inputs safely.
7. **Verify & Save:** Prove that 0 missing values remain, draw a comparison graph, and export `cleanedTarget.csv`.

---

## 📊 4. What is inside the Dataset?
The dataset contains **35,064 hourly readings** with 18 columns. The most important ones are:

| Column | What it means | Type |
| :--- | :--- | :--- |
| `PM2.5` | Tiny harmful dust particles | Number |
| `PM10` | Coarse dust particles | Number |
| `SO2` | Sulfur Dioxide gas | Number |
| `NO2` | Nitrogen Dioxide gas | Number |
| `TEMP` | Air temperature in Celsius | Number |
| `WSPM` | Wind speed | Number |
| `wd` | Wind direction (e.g., "NE", "NNW") | Text (Category) |

---

## 🧩 5. The 3 Types of "Nothing" in R (Very Simple!)

* **`NA` (Not Available / Missing):**  
  * Like a question on an exam where you left the answer box empty. The box exists, but the answer is missing.
  * *Example in code:* Sensor was offline at 2 AM, so `PM2.5` is `NA`.
* **`NULL` (Empty Object / Does Not Exist):**  
  * Like an exam paper that doesn't even have that question at all. There is no box, no memory, nothing.
  * *Example in code:* `ex2 <- NULL`
* **`NaN` (Not a Number):**  
  * What your calculator shows when you do an impossible calculation, like dividing 0 by 0.
  * *Example in code:* `ex3 <- 0 / 0`

---

## 🛠️ 6. What We Did: Step-by-Step (Task 1 to Task 10)

### Task 1: Load the File & Explore
* We loaded `target.csv` using `read.csv()`.
* We used `dim()` to see the size: **35,064 rows and 18 columns**.
* We counted total missing cells using `sum(is.na(air_data))`: **7,271 missing values** in total!

### Task 2: Show Examples of NA, NULL, and NaN
* We printed rows where `PM2.5` was `NA`.
* We created a `NULL` variable and verified it with `is.null()`.
* We created a `NaN` using `0 / 0` and verified it with `is.nan()`.

### Task 3: Build a Missing Values Summary Table
* We wrote a custom function `missing_summary()` that loops through columns and calculates:
  * Total rows
  * Number of missing entries
  * Percentage of missing entries
* *Result:* Pollutants had around 2% to 3% missing data (e.g., NO2 had 1,023 missing values).

### Task 4: Calculate Pollution Ratio & Fix Math Errors
* We made a new column: `pollution_ratio = PM2.5 / PM10`.
* If `PM10` was zero, dividing by zero produced `Inf` (Infinity) or `NaN`.
* We safely replaced all `Inf` and `NaN` with standard `NA` so R can handle them normally.

### Task 5: Fill Numerical Columns with the Median
* For columns with numbers (`PM2.5`, `PM10`, `SO2`, `NO2`, `TEMP`, `WSPM`), we replaced every `NA` with the **Median**.
* **Why Median and not Mean (Average)?**  
  Because air pollution has sudden crazy spikes (e.g., Diwali or fire incidents). The Mean gets heavily dragged up by outliers, but the **Median stays stable and realistic**.
* *Values used:*
  * `PM2.5` filled with **58**
  * `PM10` filled with **87**
  * `SO2` filled with **9**
  * `NO2` filled with **53**
  * `TEMP` filled with **14.5**
  * `WSPM` filled with **1.4**

### Task 6: Fill Wind Direction with the Mode
* Wind direction (`wd`) is text (like "NE", "NW"), so you **cannot** calculate a median or mean for words!
* Instead, we found the **Mode** (the most frequently occurring direction).
* The most common direction was **`NE`** (North-East). We filled all 81 missing entries with `"NE"`.

### Task 7: Safe Function with Error Handling (`tryCatch`)
* We created a function `clean_variable()` to clean any column safely.
* Before cleaning, it checks:
  1. Does the column name actually exist? (Throws error if fake name like `"XYZ"`)
  2. Is it numeric? (Throws error if someone tries to clean text like `"wd"` with median)
  3. Is it completely blank?
* We intentionally tested bad inputs to prove the program doesn't crash.

### Task 8: Check Before vs After Table
* We built a comparison table to check our work:

| Variable | Missing Before | Missing After | Values Replaced |
| :--- | :---: | :---: | :---: |
| `PM2.5` | 925 | **0** | 925 |
| `PM10` | 718 | **0** | 718 |
| `SO2` | 935 | **0** | 935 |
| `NO2` | 1023 | **0** | 1023 |
| `TEMP` | 20 | **0** | 20 |
| `WSPM` | 14 | **0** | 14 |
| `wd` | 81 | **0** | 81 |

* It checked `all(after_missing == 0)` and printed **`Cleaning complete`**.

### Task 9: The Bar Chart
* We drew a side-by-side bar chart:
  * **Red Bars = Missing Before Cleaning** (tall bars showing ~1000 missing values).
  * **Green Bars = Missing After Cleaning** (height is **0**).
* *Why can't we see green bars?* Because the count of missing values after cleaning is **zero**, so the green bars are flat on the ground. This proves 100% of missing values were fixed!

### Task 10: Export to File
* We saved the clean dataset as **`cleanedTarget.csv`** using `write.csv()`.
* We set `row.names = FALSE` so R doesn't add an unnecessary extra column of row numbers (1, 2, 3...).

---

## 🗣️ 7. What to Say to Your Teacher (Simple Viva Cheat-Sheet)

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

## 📁 8. Summary of Files
* **`Task1.R`**: The R code you run.
* **`target.csv`**: The original messy dataset with missing values.
* **`cleanedTarget.csv`**: The final clean dataset produced by our code.
* **`Bar chart...jpg`**: The output graph showing before vs after cleaning.
* **`README.md`**: This guide.
