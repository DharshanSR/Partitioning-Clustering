# White Wine Quality Clustering

## Project Overview

This project aims to analyze the chemical properties and sensory quality assessments of white wine varieties produced in a specific region of Portugal. The objective is to explore the relationship between these properties and to identify clusters of similar wines using partitioning clustering techniques. This analysis will help in understanding how chemical properties influence wine quality and can contribute to more objective wine certification and quality assurance processes.

## Dataset

The dataset used in this project (`whitewine_v6.xls`) consists of 2700 white wine samples. Each sample has been tested for 12 attributes, including 11 physicochemical properties and 1 sensory quality rating. The physicochemical properties are continuous variables, while the quality rating is an ordinal variable ranging from 1 (worst) to 10 (best).

### Attributes

1. **fixed acidity**: Non-volatile acids in wine.
2. **volatile acidity**: Acetic acid content, high levels lead to vinegar taste.
3. **citric acid**: Adds freshness and flavor to wines.
4. **residual sugar**: Sugar remaining after fermentation.
5. **chlorides**: Salt content in the wine.
6. **free sulfur dioxide**: Prevents microbial growth and oxidation.
7. **total sulfur dioxide**: Total SO2 content.
8. **density**: Wine density, influenced by alcohol and sugar content.
9. **pH**: Acidity/basicity scale (0-14).
10. **sulphates**: Contributes to SO2 levels.
11. **alcohol**: Alcohol content percentage.
12. **quality**: Sensory quality score (1-10).

## Project Structure

The project is divided into two main subtasks:

### Clustering with All Attributes

#### Objectives

1. **Pre-processing**: 
    - Scaling the data.
    - Outlier detection and removal.
2. **Determine the Number of Clusters**: 
    - Using four automated tools: NBclust, Elbow, Gap statistics, and silhouette methods.
3. **K-means Clustering**: 
    - Perform k-means analysis with the chosen number of clusters.
    - Evaluate clustering using BSS/TSS ratio, BSS, and WSS indices.
4. **Silhouette Analysis**: 
    - Provide silhouette plot and average silhouette width score.

### Clustering with PCA-Reduced Attributes

#### Objectives

1. **Principal Component Analysis (PCA)**: 
    - Reduce dimensionality of the dataset.
    - Select principal components with cumulative variance > 85%.
2. **Determine the Number of Clusters for PCA Data**: 
    - Using the same four automated tools.
3. **K-means Clustering on PCA Data**: 
    - Perform k-means analysis with the chosen number of clusters.
    - Evaluate clustering using BSS/TSS ratio, BSS, and WSS indices.
4. **Silhouette Analysis for PCA Data**: 
    - Provide silhouette plot and average silhouette width score.
5. **Calinski-Harabasz Index**: 
    - Evaluate clustering quality using this index.

## Usage

### Prerequisites

Ensure you have the following R packages installed:

```r
install.packages(c( "cluster", "factoextra", "NBclust", "corrplot"))
