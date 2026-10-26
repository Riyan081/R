invisible(lapply(c("tidyverse", "factoextra", "cluster", "caret", "randomForest",
                   "e1071", "plotly", "pROC", "readxl"),
                 library, character.only = TRUE))

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

df <- read_excel("Online Retail.xlsx",
                 col_types = c("text", "text", "text", "numeric", "date",
                               "numeric", "numeric", "text"))

cat("Raw rows:", nrow(df), "\n")
cat("Missing CustomerID:", sum(is.na(df$CustomerID)), "\n")
cat("Cancellation rows (InvoiceNo starts with 'C'):", sum(grepl("^C", df$InvoiceNo)), "-> excluded\n")

clean_tx <- df %>%
  filter(!is.na(CustomerID), !grepl("^C", InvoiceNo), UnitPrice > 0) %>%
  mutate(InvoiceDate = as.Date(InvoiceDate),
         Spend = Quantity * UnitPrice)

cat("Clean rows:", nrow(clean_tx), " Customers:", n_distinct(clean_tx$CustomerID), "\n")
cat("Date range:", format(min(clean_tx$InvoiceDate)), "to", format(max(clean_tx$InvoiceDate)), "\n")

cutoff_date <- max(clean_tx$InvoiceDate) + 1

cust_metrics <- clean_tx %>%
  group_by(CustomerID) %>%
  summarise(
    Recency             = as.numeric(difftime(cutoff_date, max(InvoiceDate), units = "days")),
    Frequency           = n_distinct(InvoiceNo),
    Monetary            = sum(Spend),
    AvgTransactionValue = mean(Spend),
    TotalQuantity       = sum(Quantity),
    PurchaseFreq        = n_distinct(InvoiceNo) / n_distinct(format(InvoiceDate, "%Y-%m")),
    .groups = "drop"
  )

feat_cols <- c("Recency", "Frequency", "Monetary", "AvgTransactionValue",
               "TotalQuantity", "PurchaseFreq")

cap_outliers <- function(v) {
  q <- quantile(v, c(0.25, 0.75), na.rm = TRUE)
  pmin(v, q[2] + 1.5 * diff(q))
}

cust_features <- cust_metrics %>% mutate(across(all_of(feat_cols), cap_outliers))

cat("\nFeature correlation matrix:\n")
print(round(cor(cust_features[, feat_cols]), 2))

norm_features <- scale(cust_features[, feat_cols])

p_elbow <- fviz_nbclust(norm_features, kmeans, method = "wss", k.max = 8) +
  theme_classic() +
  labs(title = "Elbow Method: Within-Cluster Sum of Squares",
       x = "Clusters (k)", y = "Total Within SS")
ggsave("01_elbow_method.png", p_elbow, width = 8, height = 6, dpi = 300)

p_sil_k <- fviz_nbclust(norm_features, kmeans, method = "silhouette", k.max = 8) +
  theme_classic() + labs(title = "Average Silhouette Width by k")
ggsave("01b_silhouette_by_k.png", p_sil_k, width = 8, height = 6, dpi = 300)

K <- 3

set.seed(47)
km_res <- kmeans(norm_features, centers = K, nstart = 30)
cust_features$Cluster <- factor(km_res$cluster)

dist_euclid <- dist(norm_features, method = "euclidean")

hc_fit <- hclust(dist_euclid, method = "ward.D2")
png("02_hierarchical_dendrogram.png", width = 1800, height = 1200, res = 200)
par(mar = c(3, 4, 3, 1))
plot(hc_fit, labels = FALSE, hang = -1,
     main = "Agglomerative Hierarchical Dendrogram (Ward.D2)",
     xlab = "Customer Observations", ylab = "Linkage Distance")
rect.hclust(hc_fit, k = K, border = "#2c7bb6")
dev.off()

hc_cl <- cutree(hc_fit, k = K)

sil_km <- silhouette(km_res$cluster, dist_euclid)
sil_hc <- silhouette(hc_cl, dist_euclid)

cat("\n--- Clustering comparison (k =", K, ") ---\n")
cat("K-Means mean silhouette:     ", round(mean(sil_km[, "sil_width"]), 4), "\n")
cat("Hierarchical mean silhouette:", round(mean(sil_hc[, "sil_width"]), 4), "\n")
cat("Adjusted Rand Index (K-Means vs Hierarchical):",
    round(mclust::adjustedRandIndex(km_res$cluster, hc_cl), 4), "\n")
cat("Cross-tabulation (rows = K-Means, cols = Hierarchical):\n")
print(table(KMeans = km_res$cluster, Hierarchical = hc_cl))

p_sil <- fviz_silhouette(sil_km, print.summary = TRUE) +
  labs(title = "Silhouette Plot: K-Means")
ggsave("03_silhouette_analysis.png", p_sil, width = 8, height = 6, dpi = 300)

pca_fit <- prcomp(norm_features, center = FALSE, scale. = FALSE)
cat("\nPCA variance explained (%):\n")
print(round(summary(pca_fit)$importance[2, 1:3] * 100, 2))
cat("\nPCA loadings (PC1-PC3):\n")
print(round(pca_fit$rotation[, 1:3], 2))

p_pca2d <- fviz_pca_ind(pca_fit, geom = "point",
                        habillage = cust_features$Cluster,
                        palette = "Set2", addEllipses = TRUE, ellipse.type = "convex",
                        legend.title = "Cluster",
                        title = "2D PCA Projection: Customer Segments")
ggsave("04_pca_2d_clusters.png", p_pca2d, width = 9, height = 6.5, dpi = 300)

pca_coords <- data.frame(pca_fit$x[, 1:3], Cluster = cust_features$Cluster)

p_3d <- plot_ly(pca_coords, x = ~PC1, y = ~PC2, z = ~PC3, color = ~Cluster,
                colors = c("#66C2A5", "#FC8D62", "#8DA0CB"),
                type = "scatter3d", mode = "markers",
                marker = list(size = 3.5, opacity = 0.85)) %>%
  layout(title = "Interactive 3D PCA Customer Clusters",
         scene = list(xaxis = list(title = "PC1"),
                      yaxis = list(title = "PC2"),
                      zaxis = list(title = "PC3")))

htmlwidgets::saveWidget(p_3d, "05_pca_3d_clusters.html", selfcontained = TRUE)
p_3d

cluster_summary <- cust_features %>%
  group_by(Cluster) %>%
  summarise(CustomerCount = n(),
            Avg_Recency   = mean(Recency),
            Avg_Frequency = mean(Frequency),
            Avg_Monetary  = mean(Monetary),
            Avg_Basket    = mean(AvgTransactionValue),
            Avg_Quantity  = mean(TotalQuantity),
            Avg_PurchFreq = mean(PurchaseFreq),
            .groups = "drop")

high_tier <- cluster_summary %>% slice_max(Avg_Monetary, n = 1) %>% pull(Cluster)
rest      <- cluster_summary %>% filter(Cluster != high_tier)
risk_tier <- rest %>% slice_max(Avg_Recency, n = 1) %>% pull(Cluster)

cluster_summary <- cluster_summary %>%
  mutate(Segment = case_when(
    Cluster == high_tier ~ "VIP / High-Value",
    Cluster == risk_tier ~ "At-Risk / Lapsed",
    TRUE                 ~ "Emerging / Occasional"))

cat("\n--- Cluster profiles ---\n")
print(as.data.frame(cluster_summary), digits = 4)

cust_features <- cust_features %>%
  mutate(IsHighValue = factor(if_else(Cluster == high_tier, "Yes", "No"), levels = c("No", "Yes")))
cat("\nClass balance:\n"); print(table(cust_features$IsHighValue))

scenarios <- list(
  Full    = feat_cols,
  Reduced = setdiff(feat_cols, c("Monetary", "TotalQuantity"))
)

run_models <- function(predictors, tag) {
  dat <- cust_features[, c(predictors, "IsHighValue")]
  set.seed(47)
  idx   <- createDataPartition(dat$IsHighValue, p = 0.80, list = FALSE)
  train <- dat[idx, ]; test <- dat[-idx, ]
  
  set.seed(47)
  rf  <- randomForest(IsHighValue ~ ., data = train, ntree = 300,
                      mtry = max(1, floor(sqrt(length(predictors)))), importance = TRUE)
  set.seed(47)
  svm_m <- svm(IsHighValue ~ ., data = train, kernel = "radial", probability = TRUE)
  
  rf_pred  <- predict(rf, test)
  svm_pred <- predict(svm_m, test)
  rf_prob  <- predict(rf, test, type = "prob")[, "Yes"]
  svm_prob <- attr(predict(svm_m, test, probability = TRUE), "probabilities")[, "Yes"]
  
  cat("\n=========", tag, "features:", paste(predictors, collapse = ", "), "=========\n")
  cat("\nRandom Forest:\n")
  print(confusionMatrix(rf_pred, test$IsHighValue, positive = "Yes", mode = "everything"))
  cat("\nSVM:\n")
  print(confusionMatrix(svm_pred, test$IsHighValue, positive = "Yes", mode = "everything"))
  
  roc_rf  <- roc(test$IsHighValue, rf_prob,  levels = c("No", "Yes"), direction = "<", quiet = TRUE)
  roc_svm <- roc(test$IsHighValue, svm_prob, levels = c("No", "Yes"), direction = "<", quiet = TRUE)
  cat("\nAUC  RF:", round(auc(roc_rf), 4), "  SVM:", round(auc(roc_svm), 4), "\n")
  
  png(paste0("06_roc_", tag, ".png"), width = 1600, height = 1400, res = 200)
  par(mar = c(4, 4, 3, 1))
  plot(roc_rf, col = "#1f78b4", lwd = 2.5, asp = NA,
       main = paste("ROC Curves:", tag, "features"))
  lines(roc_svm, col = "#e31a1c", lwd = 2.5, lty = 2)
  legend("bottomright", bty = "n", lwd = 2.5, lty = c(1, 2),
         col = c("#1f78b4", "#e31a1c"),
         legend = c(paste0("Random Forest (AUC = ", round(auc(roc_rf), 4), ")"),
                    paste0("SVM (AUC = ", round(auc(roc_svm), 4), ")")))
  dev.off()
  
  png(paste0("07_rf_importance_", tag, ".png"), width = 1600, height = 1200, res = 200)
  varImpPlot(rf, main = paste("Random Forest Feature Importance:", tag), pch = 19, col = "#1f78b4")
  dev.off()
  
  invisible(NULL)
}

for (nm in names(scenarios)) run_models(scenarios[[nm]], nm)

strategies <- c(
  "VIP / High-Value"      = "Exclusive early access, loyalty tiers, dedicated support, referral rewards.",
  "At-Risk / Lapsed"      = "Win-back discounts, personalised reactivation emails, 'we miss you' campaigns.",
  "Emerging / Occasional" = "Cross-sell, bundle offers, basket-size incentives, free-shipping thresholds."
)
marketing_recommendations <- cluster_summary %>%
  mutate(Strategy = strategies[Segment]) %>%
  select(Cluster, Segment, CustomerCount, Avg_Recency, Avg_Frequency, Avg_Monetary, Strategy)
print(as.data.frame(marketing_recommendations))



interpretation <- c(
  "1. Segments: K-Means where k = 3, splits 4,338 customers into VIP (22%, 8 orders, GBP 3,010 spend, last purchase 29 days ago, about 57% of total spend), Emerging (54%, 2.5 orders, GBP 741) and At-Risk (24%, 245 days inactive, 1.4 orders, GBP 397).",
  "2. Quality: the elbow and silhouette-by-k favour k = 2; k = 3 was kept to separate lapsed customers from active low spenders. The mean silhouette of 0.31 means moderate structure, with Emerging and At-Risk overlapping in the PCA plots.",
  "3. Hierarchical check: silhouette 0.24 vs 0.31 for K-Means and adjusted Rand index 0.51; both methods agree on VIP (96%) and At-Risk (92%) and differ only on boundary customers in Emerging, so K-Means is preferred.",
  "4. PCA: the first three components explain 86.4% of the variance (56.6%, 17.5%, 12.3%), and VIP is clearly separated along PC1, which acts as an overall activity-and-spend axis.",
  "5. Prediction: with all features Random Forest and SVM reach 98.5% and 99.5% accuracy (AUC >= 0.999), but this is circular because the label comes from the same features; without Monetary and TotalQuantity, AUC falls to 0.955 (RF) and 0.931 (SVM) and Frequency is the top predictor.",
  "6. Marketing: reward and retain VIPs, grow order frequency and basket size of Emerging customers with bundles and free-shipping thresholds, and run a low-cost win-back campaign for At-Risk customers, dropping non-responders."
)

cat("\n--- Interpretation ---\n")
writeLines(strwrap(interpretation, width = 100, exdent = 3))