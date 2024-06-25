# library to read excel sheet
library(readxl)
library(NbClust)
library(factoextra)
library(cluster)
library(fpc)

#sub Task 1

#Read the Excel File
wine <- read_excel("C:/Users/Dharshan/OneDrive/Desktop/Machine Learning Coursework/Sub Task 1/Whitewine_v6.xlsx")
wine <-as.data.frame(wine)
head(wine)

#display the names of the columns
colnames(wine)

#Calculate colum means
colum_means <- colMeans(wine, na.rm = TRUE)

#Checking if there are any null values in dataset
colSums(is.na(wine))

anyNA(wine)

# Function to replace NA values in a column with its mean
replace_na_with_mean <- function(column) {
  mean_value <- mean(column, na.rm = TRUE)
  column[is.na(column)] <- mean_value
  return(column)
}

# Apply the function to each column
for (column in colnames(wine)) {
  wine[[column]] <- replace_na_with_mean(wine[[column]])
}

duplicates <- duplicated(wine)
duplicated(colnames(wine))

wine <- subset(wine, !duplicates)

#boxplot before scaling and outline removal
boxplot(wine)

head(wine)
dim(wine)

# Function to detect outliers
outlier <- function(x){
  q1 <- quantile(x, probs = 0.25)
  q3 <- quantile(x, probs = 0.75)
  iqr <- q3 - q1
  lower_bound <- q1 - 1.5 * iqr
  upper_bound <- q3 + 1.5 * iqr
  x < lower_bound | x > upper_bound
}

# Function to remove outliers
remove_outlier <- function(wine){
  outliers <- apply(wine, 2, outlier)
  filtered_wine <- wine[!rowSums(outliers),]
  return(filtered_wine)
}

# Remove outliers from the dataset
filtered_wine <- remove_outlier(wine)

boxplot(filtered_wine)

# Scale the dataset
scaled_wine <- scale(filtered_wine[,1:11])
colnames(scaled_wine)


# Determining k using NbClust
nb <- NbClust(scaled_wine, distance = "euclidean", min.nc = 2, max.nc = 10, method = "kmeans", index = "all")

# Visualize the elbow method
elbow_method <- fviz_nbclust(scaled_wine, kmeans, method = "wss")
print(elbow_method)

# Visualize the gap statistic
gap_stat <- fviz_nbclust(scaled_wine, kmeans, method = "gap_stat")
print(gap_stat)

# Visualize the silhouette method
silhouette_method <- fviz_nbclust(scaled_wine, kmeans, method = "silhouette")
silhouette_method

#k = 2
kmeans_clusters <- kmeans(scaled_wine, centers = 2)

# Extract cluster centers
centers <- kmeans_clusters$centers
print(centers)

# Extract cluster assignments for each data point
cluster_assignments <- kmeans_clusters$cluster
print(cluster_assignments)

# Calculate between-cluster sum of squares (BSS)
BSS <- kmeans_clusters$betweenss
print(BSS)

# Calculate within-cluster sum of squares (WSS)
WSS <- kmeans_clusters$tot.withinss
print(WSS)

# Calculate total sum of squares (TSS)
TSS <- BSS + WSS
print(TSS)

#calculate the BSS over TSS
BSS_over_TSS <- (BSS / TSS) * 100
print(paste(round(BSS_over_TSS, 2), "%"))


#cluster plot print
fviz_cluster(list(data = scaled_wine, cluster = kmeans_clusters$cluster), geom = "point")

# Calculate silhouette widths
sil <- silhouette(kmeans_clusters$cluster, dist(scaled_wine))
fviz_silhouette(sil)

# Calculate average silhouette width score
avg_sil_width <- mean(sil[,"sil_width"])
avg_sil_width

#sub task 2
#PCA
pca_result <- prcomp(scaled_wine)
head(pca_result$rotation)

summary(pca_result)

pca_result$rotation <- -pca_result$rotation
eigen_vectors <- pca_result$rotation 
eigen_vectors

eigen_value <- (pca_result$sdev^2)
eigen_value

pca_result$scale

prop_variance_pca <- (eigen_value/sum(eigen_value))
prop_variance_pca

cum_prop_variance_pca <- cumsum(prop_variance_pca)
cum_prop_variance_pca

num_components <- sum(cum_prop_variance_pca < 0.85) + 1
num_components

# Choose the principal components
chosen_components <- predict(pca_result, newdata = scaled_wine) [,1:num_components]

# Create a new dataset with chosen principal components
transformed_data <- as.data.frame(chosen_components)

# Determining k using NbClust after transforming
nb <- NbClust(transformed_data, distance = "euclidean", min.nc = 2, max.nc = 10, method = "kmeans", index = "all")

# Elbow Method
elbow_method <- fviz_nbclust(transformed_data, kmeans, method = "wss")
elbow_method

# Gap Statistics
gapstat_method <- fviz_nbclust(transformed_data, kmeans, method = "gap_stat")
gapstat_method

# Silhouette Method
silhouette_method <- fviz_nbclust(transformed_data, kmeans, method = "silhouette")
silhouette_method

#k = 2
kmeans_clusters <- kmeans(transformed_data, centers = 2)
kmeans_clusters

# Extract cluster centers
centers <- kmeans_clusters$centers
print(centers)

# Extract cluster assignments for each data point
cluster_assignments <- kmeans_clusters$cluster
print(cluster_assignments)

# Calculate between-cluster sum of squares (BSS)
BSS <- kmeans_clusters$betweenss
print(BSS)

# Calculate within-cluster sum of squares (WSS)
WSS <- kmeans_clusters$tot.withinss
print(WSS)

# Calculate total sum of squares (TSS)
TSS <- BSS + WSS
print(TSS)

# Calculate the ratio of BSS to TSS
BSS_over_TSS <- BSS / TSS
print(BSS_over_TSS)

#cluster plot print
fviz_cluster(list(data = transformed_data, cluster = kmeans_clusters$cluster), geom = "point")

# Calculate silhouette widths
sil <- silhouette(kmeans_clusters$cluster, dist(transformed_data))
fviz_silhouette(sil)

# Calculate average silhouette width score
avg_sil_width <- mean(sil[,"sil_width"])
avg_sil_width

# Calculate the Calinski-Harabasz Index for evaluating the quality of clusters formed by k-means clustering on the PCA-transformed dataset
CH_index <- calinhara(transformed_data, kmeans_clusters$cluster)
CH_index