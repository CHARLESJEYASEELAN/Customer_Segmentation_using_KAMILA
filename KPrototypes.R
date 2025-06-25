library(tidyverse)

df <- read.csv("cleaned_credit.csv")

head(df)

colnames(df)

dim(df)

# KAMILA CLUSTERING
#install.packages("kamila")

#library(kamila)

#head(df)

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

str(df)

continuous_vars <- df %>% select_if(is.numeric)
categorical_vars <- df %>% select_if(is.factor)

# Install if not already installed
#install.packages("clustMixType")

# Load the package
library(clustMixType)

set.seed(123)

kproto <- kproto(
  df,
  k = 2
)

summary(kproto)

df$clusterLabel <- kproto$cluster

head(df)

table(df$clusterLabel)

library(ggplot2)

# Install if not already installed
#install.packages("clustMixType")

# Load the package
library(clustMixType)

ggplot(df, aes(x = as.factor(clusterLabel), fill = as.factor(clusterLabel))) +
  geom_bar() +
  labs(title = "Cluster Distribution by K-Prototypes", x = "Cluster", y = "Count") +
  scale_fill_brewer(palette = "Set2") +
  theme_minimal()

library(cluster)

# Continuous variables only
continuous_vars <- df %>% select_if(is.numeric)

# Compute Euclidean distance matrix
dist_matrix <- dist(continuous_vars)

# Calculate silhouette values
sil <- silhouette(df$clusterLabel, dist_matrix)

# Summary of silhouette
summary(sil)

# Average silhouette width
mean(sil[, 3])

custom_colors <- c("#0073C2", "#EFC000")

#Optional: Plot silhouette
plot(sil,
     main = "Silhouette Plot for Continuous Variables",
     col = rainbow(2),
     border = NA,
)

# Load library for tidy operations
library(dplyr)

# Function to calculate entropy for a factor variable
calculate_entropy <- function(x) {
  prop <- prop.table(table(x))
  -sum(prop * log(prop))
}

# Calculate entropy per cluster
entropy_per_cluster <- df %>%
  group_by(clusterLabel) %>%
  summarise(
    SEX_entropy = calculate_entropy(SEX),
    EDUCATION_entropy = calculate_entropy(EDUCATION),
    MARRIAGE_entropy = calculate_entropy(MARRIAGE),
    .groups = "drop"
  )

print(entropy_per_cluster)

library(FactoMineR)
library(factoextra)

pca_res <- PCA(continuous_vars, graph = FALSE)

str(df)

df$clusterLabel <- as.factor(df$clusterLabel)

# Visualize PCA clusters
fviz_pca_ind(pca_res,
             geom = "point",
             col.ind = df$clusterLabel,            # color by cluster
             palette = c("#E74C3C", "#3498DB"),    # soft red and blue
             addEllipses = TRUE,                   # add confidence ellipses
             ellipse.type = "confidence",          # more precise ellipses
             ellipse.level = 1,                 # 95% confidence
             pointshape = 21,                      # rounded shape with border
             pointsize = 2.5,                      # adjust point size
             label = "none"                        # hide individual labels
) +
  ggtitle("Clusters K = 2: K-Prototypes") +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    legend.title = element_blank(),
    legend.position = "right"
  )


# Melt data for plotting
library(reshape2)

entropy_melt <- melt(entropy_per_cluster, id.vars = "clusterLabel")

# Plot
ggplot(entropy_melt, aes(x = as.factor(clusterLabel), y = value, fill = variable)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Entropy of Categorical Variables per Cluster",
       x = "Cluster",
       y = "Entropy",
       fill = "Categorical Variable") +
  theme_minimal()
