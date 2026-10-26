install.packages("palmerpenguins") # built-in dataset
install.packages("e1071")
install.packages("car")
install.packages("ggplot2")
install.packages("dplyr")

library(e1071)
library(car)
library(ggplot2)
library(dplyr)
library(palmerpenguins)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# load data
data(penguins)
penguins <- as.data.frame(penguins)

# check if loaded
str(penguins)
head(penguins)
summary(penguins)

# missing values cleanup
penguins <- penguins[complete.cases(penguins[, c("species", "sex",
                                                   "body_mass_g",
                                                   "flipper_length_mm")]), ]

cat("Number of penguins after removing NAs:", nrow(penguins), "\n")











# T1: Statistics



desc_stats <- function(x) {
  c(
    Mean     = mean(x),
    Median   = median(x),
    Min      = min(x),
    Max      = max(x),
    Variance = var(x),
    SD       = sd(x),
    Q1       = quantile(x, 0.25),
    Q3       = quantile(x, 0.75),
    IQR      = IQR(x),
    Skewness = skewness(x),
    Kurtosis = kurtosis(x)
  )
}

overall_desc <- desc_stats(penguins$body_mass_g)
print(round(overall_desc, 2))

species_desc <- penguins %>%
  group_by(species) %>%
  summarise(
    Mean     = mean(body_mass_g),
    Median   = median(body_mass_g),
    Min      = min(body_mass_g),
    Max      = max(body_mass_g),
    Variance = var(body_mass_g),
    SD       = sd(body_mass_g),
    Q1       = quantile(body_mass_g, 0.25),
    Q3       = quantile(body_mass_g, 0.75),
    IQR      = IQR(body_mass_g),
    Skewness = skewness(body_mass_g),
    Kurtosis = kurtosis(body_mass_g)
  )

print(species_desc)

# visualizations

# histogram of body mass
p1 <- ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 200, fill = "steelblue", color = "black") +
  labs(title = "Histogram of Penguin Body Mass",
       x = "Body Mass (g)", y = "Frequency") +
  theme_minimal()
print(p1)
ggsave("plot1_histogram_bodymass.png", plot = p1, width = 7, height = 5, dpi = 300)

# boxplot of body mass by species
p2 <- ggplot(penguins, aes(x = species, y = body_mass_g, fill = species)) +
  geom_boxplot() +
  labs(title = "Body Mass by Species",
       x = "Species", y = "Body Mass (g)") +
  theme_minimal()
print(p2)
ggsave("plot2_boxplot_species.png", plot = p2, width = 7, height = 5, dpi = 300)

# density plot of body mass by species
p3 <- ggplot(penguins, aes(x = body_mass_g, fill = species)) +
  geom_density(alpha = 0.5) +
  labs(title = "Density Plot of Body Mass by Species",
       x = "Body Mass (g)", y = "Density") +
  theme_minimal()
print(p3)
ggsave("plot3_density_species.png", plot = p3, width = 7, height = 5, dpi = 300)










# T2: Hypothesis 


# H0: mean body mass of male is equivalent to mean body mass of female
# H1: mean body mass of male is not equivalent to mean body mass of female

male_mass   <- penguins$body_mass_g[penguins$sex == "male"]
female_mass <- penguins$body_mass_g[penguins$sex == "female"]

# Shapiro-Wilk test
shapiro_male   <- shapiro.test(male_mass)
shapiro_female <- shapiro.test(female_mass)

cat("Shapiro-Wilk test (Male):\n");   print(shapiro_male)
cat("Shapiro-Wilk test (Female):\n"); print(shapiro_female)

# QQ-plots
png("plot_qq_sex.png", width = 900, height = 500)
par(mfrow = c(1, 2))
qqnorm(male_mass, main = "QQ Plot - Male Body Mass"); qqline(male_mass, col = "red")
qqnorm(female_mass, main = "QQ Plot - Female Body Mass"); qqline(female_mass, col = "red")
par(mfrow = c(1, 1))
dev.off()

# Independent two-sample t-test
# Welch's t-test
t_test_result <- t.test(body_mass_g ~ sex, data = penguins)
print(t_test_result)

# 95% Confidence Interval
cat("95% CI for difference in mean body mass:\n")
print(t_test_result$conf.int)

# Cohen's d (effect size)
cohen_d <- function(x, y) {
  nx <- length(x); ny <- length(y)
  pooled_sd <- sqrt(((nx - 1) * var(x) + (ny - 1) * var(y)) / (nx + ny - 2))
  (mean(x) - mean(y)) / pooled_sd
}

d_value <- cohen_d(male_mass, female_mass)
cat("Cohen's d:", round(d_value, 3), "\n")

# Interpretation 
cat("\nInterpretation:\n")
cat("p-value =", format.pval(t_test_result$p.value, digits = 4),
    "-> ", ifelse(t_test_result$p.value < 0.05,
                   "Reject H0: significant difference in mean body mass between sexes.",
                   "Fail to reject H0: no significant difference."), "\n")
cat("Cohen's d =", round(d_value, 3),
    "-> magnitude:",
    ifelse(abs(d_value) < 0.2, "negligible",
    ifelse(abs(d_value) < 0.5, "small",
    ifelse(abs(d_value) < 0.8, "medium", "large"))), "\n")












# T3: One way anova test

# Normality check per species
for (sp in unique(penguins$species)) {
  cat("\nShapiro-Wilk test for", sp, ":\n")
  print(shapiro.test(penguins$body_mass_g[penguins$species == sp]))
}

# QQ-plots per species
png("plot_qq_species_bodymass.png", width = 1200, height = 500)
par(mfrow = c(1, 3))
for (sp in unique(penguins$species)) {
  data_sp <- penguins$body_mass_g[penguins$species == sp]
  qqnorm(data_sp, main = paste("QQ Plot -", sp))
  qqline(data_sp, col = "red")
}
par(mfrow = c(1, 1))
dev.off()

# Homogeneity of variance: Levene's test
levene_result <- leveneTest(body_mass_g ~ species, data = penguins)
print(levene_result)

# One-way ANOVA
anova_model <- aov(body_mass_g ~ species, data = penguins)
anova_summary <- summary(anova_model)
print(anova_summary)

# Tukey HSD post-hoc test (if ANOVA significant)
p_value_anova <- anova_summary[[1]][["Pr(>F)"]][1]

if (p_value_anova < 0.05) {
  cat("\nANOVA is significant -> Running Tukey HSD post-hoc test\n")
  tukey_result <- TukeyHSD(anova_model)
  print(tukey_result)
  png("plot_tukey_hsd.png", width = 700, height = 500)
  plot(tukey_result, las = 1)
  dev.off()
} else {
  cat("\nANOVA not significant -> Tukey HSD not required\n")
}












# T4: Non parametric analysis


kruskal_result <- kruskal.test(body_mass_g ~ species, data = penguins)
print(kruskal_result)

cat("\nComparison of ANOVA vs Kruskal-Wallis:\n")
cat("ANOVA p-value:", format.pval(p_value_anova, digits = 4), "\n")
cat("Kruskal-Wallis p-value:", format.pval(kruskal_result$p.value, digits = 4), "\n")
cat("Conclusion: Both tests", 
    ifelse((p_value_anova < 0.05) == (kruskal_result$p.value < 0.05),
           "lead to the SAME conclusion regarding species differences.",
           "lead to DIFFERENT conclusions - investigate assumption violations."), "\n")










# T5: Two way anova 

two_way_model <- aov(body_mass_g ~ species * sex, data = penguins)
two_way_summary <- summary(two_way_model)
print(two_way_summary)

cat("\nInterpretation guide:\n")
cat("- Check p-value for 'species'      -> main effect of species\n")
cat("- Check p-value for 'sex'          -> main effect of sex\n")
cat("- Check p-value for 'species:sex'  -> interaction effect\n")

# Interaction plot
png("plot_interaction_species_sex.png", width = 800, height = 500)
interaction.plot(penguins$species, penguins$sex, penguins$body_mass_g,
                 col = c("blue", "red"), lwd = 2,
                 xlab = "Species", ylab = "Mean Body Mass (g)",
                 trace.label = "Sex",
                 main = "Interaction Plot: Species x Sex on Body Mass")
dev.off()










# T6: Flipper length analysis

# Descriptive stats by species
flipper_desc <- penguins %>%
  group_by(species) %>%
  summarise(
    Mean = mean(flipper_length_mm),
    SD   = sd(flipper_length_mm),
    Min  = min(flipper_length_mm),
    Max  = max(flipper_length_mm)
  )
print(flipper_desc)

# Normality check
for (sp in unique(penguins$species)) {
  cat("\nShapiro-Wilk (flipper length) for", sp, ":\n")
  print(shapiro.test(penguins$flipper_length_mm[penguins$species == sp]))
}

# Levene's test
print(leveneTest(flipper_length_mm ~ species, data = penguins))

# One-way ANOVA for flipper length
flipper_anova <- aov(flipper_length_mm ~ species, data = penguins)
flipper_anova_summary <- summary(flipper_anova)
print(flipper_anova_summary)

flipper_p <- flipper_anova_summary[[1]][["Pr(>F)"]][1]

if (flipper_p < 0.05) {
  cat("\nFlipper length ANOVA significant -> Tukey HSD:\n")
  print(TukeyHSD(flipper_anova))
} 

# Kruskal-Wallis for flipper length (robustness check)
print(kruskal.test(flipper_length_mm ~ species, data = penguins))

cat("\nConsistency check: Compare flipper length findings with body mass findings",
    "to see if both physical traits differentiate species similarly.\n")

# QQ-plots for flipper length per species
png("plot_qq_species_flipper.png", width = 1200, height = 500)
par(mfrow = c(1, 3))
for (sp in unique(penguins$species)) {
  data_sp <- penguins$flipper_length_mm[penguins$species == sp]
  qqnorm(data_sp, main = paste("QQ Plot (Flipper) -", sp))
  qqline(data_sp, col = "red")
}
par(mfrow = c(1, 1))
dev.off()










# T7: Additional Visualisations
# Histogram of body mass
p4 <- ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 200, fill = "darkorange", color = "black") +
  labs(title = "Histogram of Body Mass", x = "Body Mass (g)", y = "Frequency") +
  theme_minimal()
print(p4)
ggsave("plot4_histogram_bodymass.png", plot = p4, width = 7, height = 5, dpi = 300)

# Species-wise boxplot of body mass
p5 <- ggplot(penguins, aes(x = species, y = body_mass_g, fill = species)) +
  geom_boxplot() +
  labs(title = "Species-wise Boxplot of Body Mass", x = "Species", y = "Body Mass (g)") +
  theme_minimal()
print(p5)
ggsave("plot5_boxplot_species.png", plot = p5, width = 7, height = 5, dpi = 300)

# Sex-wise boxplot of body mass
p6 <- ggplot(penguins, aes(x = sex, y = body_mass_g, fill = sex)) +
  geom_boxplot() +
  labs(title = "Sex-wise Boxplot of Body Mass", x = "Sex", y = "Body Mass (g)") +
  theme_minimal()
print(p6)
ggsave("plot6_boxplot_sex.png", plot = p6, width = 7, height = 5, dpi = 300)

# Species-wise flipper length comparison
p7 <- ggplot(penguins, aes(x = species, y = flipper_length_mm, fill = species)) +
  geom_boxplot() +
  labs(title = "Species-wise Flipper Length Comparison",
       x = "Species", y = "Flipper Length (mm)") +
  theme_minimal()
print(p7)
ggsave("plot7_boxplot_flipper_species.png", plot = p7, width = 7, height = 5, dpi = 300)

# Group comparison plot with mean points overlaid (species vs body mass, annotated with ANOVA p-value)
p8 <- ggplot(penguins, aes(x = species, y = body_mass_g, fill = species)) +
  geom_boxplot(alpha = 0.7) +
  stat_summary(fun = mean, geom = "point", shape = 18, size = 4, color = "black") +
  labs(title = "Body Mass Comparison Across Species (ANOVA / Tukey Result)",
       subtitle = paste("One-way ANOVA p-value:", format.pval(p_value_anova, digits = 3)),
       x = "Species", y = "Body Mass (g)") +
  theme_minimal()
print(p8)
ggsave("plot8_group_comparison.png", plot = p8, width = 7, height = 5, dpi = 300)

