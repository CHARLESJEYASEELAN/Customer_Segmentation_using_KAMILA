library(tidyverse)

df <- read.csv("cleaned_credit.csv")
head(df)

colnames(df)

dim(df)

# KAMILA CLUSTERING
#install.packages("kamila")

library(kamila)

str(df)

#convert SEX, EDUCATION and MARRIAGE from int(encoded) to factor
df$SEX <- as.factor(df$SEX)
df$EDUCATION <- as.factor(df$EDUCATION)
df$MARRIAGE <- as.factor(df$MARRIAGE)

#clusters
num_clusters <- 2

# except the above convert everything to numeric
df$LIMIT_BAL <- as.numeric(df$LIMIT_BAL)
df$AGE <- as.numeric(df$AGE)
df$Avg_Payment_History <- as.numeric(df$Avg_Payment_History)
df$Avg_Bill_Statement <- as.numeric(df$Avg_Bill_Statement)
df$Avg_Previous_Payment <- as.numeric(df$Avg_Previous_Payment)

# Plot a Correlation Map between numerical variables

library(corrplot)

# Select only numerical variables
numerical_vars <- df %>% select_if(is.numeric)

# Compute the correlation matrix
correlation_matrix <- cor(numerical_vars, use = "complete.obs")

# Plot the correlation map
corrplot(correlation_matrix, method = "color", type = "upper",
         tl.col = "black", tl.srt = 45,
         addCoef.col = "black", # Add correlation values in black
         number.cex = 0.7,      # Adjust the size of the numbers
         title = "Correlation Map with Values",
         mar = c(0, 0, 1, 0))

str(df)

continuous_vars <- df %>% select_if(is.numeric)
categorical_vars <- df %>% select_if(is.factor)

kamila_result <- kamila(
  continuous_vars,
  categorical_vars,
  num_clusters,
  numInit = 10
)

str(kamila_result)

df$cluster <- as.factor(kamila_result$finalMemb)

#save the

#write_csv(df, "KAMILA_Clustered.csv")





library(ggplot2)

ggplot(df, aes(x = factor(cluster), fill = factor(cluster))) +
  geom_bar(alpha = 0.8, color = "black") +
  scale_fill_manual(values = c("#0073C2", "#EFC000", "#868686", "#CD534C", "#7AA6DC")) +
  labs(
    title = "KAMILA Clustering Results",
    subtitle = "Distribution of Data Points Across Clusters",
    x = "Cluster",
    y = "Count",
    fill = "Cluster"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 18, color = "#333333"),
    plot.subtitle = element_text(size = 14, color = "#666666"),
    axis.title.x = element_text(face = "bold", size = 14),
    axis.title.y = element_text(face = "bold", size = 14),
    axis.text = element_text(size = 12, color = "#444444"),
    legend.position = "top",
    legend.background = element_rect(fill = "gray95", color = NA),
    panel.grid.major = element_line(color = "gray80", linetype = "dashed"),
    panel.grid.minor = element_blank()
  )


dim(df)

head(df)

# Summary statistics for each cluster
df %>%
  group_by(cluster) %>%
  summarise(across(where(is.numeric), mean), .groups = "drop")


# Visualization Method 1: using PCA for Continuous Variables
#install.packages("FactoMineR")
#install.packages("factoextra")

library(ggplot2)
library(FactoMineR)
library(factoextra)

# Perform PCA on continuous variables
pca_res <- PCA(continuous_vars, graph = FALSE)

# Visualize PCA clusters
fviz_pca_ind(pca_res,
             geom = "point",
             col.ind = df$cluster,
             palette = c("red", "blue"),
             addEllipses = TRUE)

# Beautified PCA plot
fviz_pca_ind(pca_res,
             geom = "point",
             col.ind = df$cluster,                     # Color points by cluster
             palette = c("#0000FF","#FFA500")   ,      # Soft red and blue
             addEllipses = TRUE,                       # Add confidence ellipses
             ellipse.level = 1,             # 95% confidence ellipses
             pointshape = 21,                          # Circle with border
             pointsize = 3,                            # Bigger, clearer points
             label = "none"                            # No text labels for points
) +
  ggtitle("Clusters K = 2: KAMILA") +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16),
    legend.title = element_blank(),
    legend.position = "right"
  )

# Visualization 2 - For Categorical Varaibles
library(ggplot2)

# Count of categorical variables in each cluster
ggplot(df, aes(x = cluster, fill = SEX)) +
  geom_bar(position = "dodge") +
  ggtitle("Distribution of SEX in Clusters")

ggplot(df, aes(x = cluster, fill = EDUCATION)) +
  geom_bar(position = "dodge") +
  ggtitle("Distribution of EDUCATION in Clusters")

ggplot(df, aes(x = cluster, fill = MARRIAGE)) +
  geom_bar(position = "dodge") +
  ggtitle("Distribution of MARRIAGE in Clusters")


# Evaluating Clusters : 1. Continous Variables
library(cluster)

sil <- silhouette(kamila_result$finalMemb, dist(continuous_vars))
sil

# Plot silhouette
plot(sil, col = 1:2, border = NA)


# STYLISH =====================

# Convert silhouette object to a data frame
sil_df <- data.frame(
  cluster = factor(sil[, 1]),
  silhouette_width = sil[, 3]
)

# 2. Categorical Variables with Entropy Measures

entropy_per_cluster <- df %>%
  group_by(cluster) %>%
  summarise(
    SEX_entropy = -sum(prop.table(table(SEX)) * log(prop.table(table(SEX)))),
    EDUCATION_entropy = -sum(prop.table(table(EDUCATION)) * log(prop.table(table(EDUCATION)))),
    MARRIAGE_entropy = -sum(prop.table(table(MARRIAGE)) * log(prop.table(table(MARRIAGE)))),
    .groups = "drop"
  )

entropy_per_cluster

df %>%
  group_by(cluster) %>%
  summarise(across(where(is.numeric), mean), .groups = "drop")


avg_sil <- summary(sil)$avg.width
print(paste("Average Silhouette Score for k = 2:", avg_sil))














# ========= VISULIZATON =========================


# Install necessary package if not installed
install.packages("plotrix")
# Load necessary library
library(plotrix)

# Data for the clusters
cluster_labels <- c("Cluster 1", "Cluster 2")
cluster_count <- c(20798, 9202)

# Define gradient colors (using vibrant and modern shades)
colors <- c("#0073C2FF", "#EFC000FF")  # Deep Blue & Golden Yellow for contrast

# Create labels with count information
labels_with_count <- paste(cluster_labels, "\n(", cluster_count, ")", sep="")

# Set the background color to gray and enable grid lines
par(bg = "gray90", mar = c(2, 2, 2, 2), family = "serif")  # Background & Font

# Create grid lines in the background
plot.new()
grid(col = "white", lty = "dotted", lwd = 1)  # Stylish white dotted grid

# 3D Pie Chart with enhanced aesthetics
pie3D(cluster_count,
      labels = labels_with_count,
      labelcex = 1.5,   # Increased label size for better readability
      explode = 0.15,   # More explosion for better visibility
      col = colors,     # Modern gradient colors
      main = "Cluster Distribution - 3D Visualization",  # Title
      border = "black",  # Black border for better contrast
      shade = 0.9,       # Enhanced shading for a more realistic 3D effect
      theta = 0.85)      # Adjusted viewing angle for better depth

# Add a legend with a more stylish design
legend("topright", legend = cluster_labels, fill = colors, cex = 1.5, bty = "o",
       box.col = "black", text.font = 2)  # Bold text in the legend





