# PBL 1: Air Quality Data Exploration & Missing Value Treatment

---

## 📌 1. Project at a Glance (Quick Summary)
* **What is this project about?**  
  We took real-world air pollution sensor data from Beijing (`target.csv`), found thousands of missing/broken entries (`NA`), and cleaned them up using smart statistical methods.
* **Main Script:** `Task1.R`
* **Outputs:** 
  1. `cleanedTarget.csv` (100% clean dataset ready for use)
  2. A comparison bar chart showing zero missing values after cleaning.

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

**Q1: What does this project do?**  
> *"Sir/Ma'am, it takes real Beijing air quality sensor data, finds all missing and invalid sensor values, and fills them in using median for numbers and mode for wind direction so the data is ready for analysis."*

**Q2: Why did you use Median instead of Average (Mean)?**  
> *"Because air pollution has sudden extreme spikes (outliers). The average gets easily ruined by spikes, but the median represents the true middle value and doesn't get distorted."*

**Q3: Why did you use Mode for wind direction?**  
> *"Wind direction is text like 'North-East', not numbers. You cannot calculate an average of text, so we used the mode (the most common wind direction)."*

**Q4: What is the difference between `NA` and `NaN`?**  
> *"NA means the sensor didn't record data (missing value). NaN means 'Not a Number', which happens when an impossible calculation occurs like 0 divided by 0."*

**Q5: Why does the graph only show red bars? Where is green?**  
> *"Red shows missing values before cleaning. Green shows missing values after cleaning. Since our code fixed all missing values, the count after cleaning is exactly zero, so the green bars have a height of zero."*

**Q6: Why did you write `0 / 0` in Task 2?**  
> *"Because the original CSV only had NA values. I wrote `0 / 0` to demonstrate to R how a NaN (Not a Number) is created and how `is.nan()` detects it."*

---

## 📁 8. Summary of Files
* **`Task1.R`**: The R code you run.
* **`target.csv`**: The original messy dataset with missing values.
* **`cleanedTarget.csv`**: The final clean dataset produced by our code.
* **`Bar chart...jpg`**: The output graph showing before vs after cleaning.
* **`README.md`**: This guide.
