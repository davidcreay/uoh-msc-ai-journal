# Create the "images" directory if it doesn't already exist
dir.create("images", showWarnings = FALSE)

# ---------------------------------------------------------
# 1. Mean, Variance, and Standard Deviation
# ---------------------------------------------------------
png("images/01_mean_variance.png", width = 600, height = 400)
x <- seq(-4, 4, length = 100)
hx <- dnorm(x)
plot(x, hx, type = "l", lty = 1, lwd = 2, xlab = "Value", ylab = "Density", 
     main = "Mean, Variance, and Standard Deviation")
# Draw mean
abline(v = 0, col = "red", lwd = 2)
text(0.4, 0.35, "Mean (0)", col = "red", pos = 4)
# Draw standard deviation
arrows(0, 0.24, 1, 0.24, col = "blue", code = 3, length = 0.1, lwd = 2)
text(0.5, 0.26, "1 Std Dev", col = "blue")
dev.off()

# ---------------------------------------------------------
# 2. Centering and Scaling
# ---------------------------------------------------------
png("images/02_centering_scaling.png", width = 800, height = 400)
par(mfrow = c(1, 2)) # Put plots side-by-side
set.seed(42)
x_orig <- rnorm(50, mean = 50, sd = 10)
y_orig <- x_orig * 1.5 + rnorm(50, mean = 20, sd = 5)

# Original Plot
plot(x_orig, y_orig, main = "Original Data", xlab = "Feature 1", ylab = "Feature 2", 
     col = "darkgreen", pch = 16)
abline(h = mean(y_orig), v = mean(x_orig), col = "gray", lty = 2)

# Centered & Scaled Plot
plot(scale(x_orig), scale(y_orig), main = "Centered & Scaled Data", 
     xlab = "Scaled Feature 1", ylab = "Scaled Feature 2", col = "purple", pch = 16)
abline(h = 0, v = 0, col = "gray", lty = 2) # Origin is now 0,0
dev.off()

# ---------------------------------------------------------
# 3. Euclidean Distance
# ---------------------------------------------------------
png("images/03_euclidean_distance.png", width = 500, height = 500)
plot(c(1, 4), c(2, 6), type = "n", xlim = c(0, 5), ylim = c(0, 7), 
     xlab = "X Coordinate", ylab = "Y Coordinate", main = "Euclidean Distance")
grid()
points(c(1, 4), c(2, 6), pch = 16, col = "blue", cex = 1.5)
lines(c(1, 4), c(2, 6), col = "red", lwd = 2, lty = 1)
lines(c(1, 4), c(2, 2), col = "gray", lty = 3, lwd = 2)
lines(c(4, 4), c(2, 6), col = "gray", lty = 3, lwd = 2)
text(1, 2.4, "Point A (1,2)")
text(4, 6.4, "Point B (4,6)")
text(2.2, 4.2, "Distance", col = "red", srt = 53)
dev.off()

# ---------------------------------------------------------
# 4. Hierarchical Clustering
# ---------------------------------------------------------
png("images/04_hierarchical_clustering.png", width = 600, height = 500)
# Using a subset of the built-in mtcars dataset for a clean visual
hc <- hclust(dist(mtcars[1:15, ])) 
plot(hc, main = "Hierarchical Clustering Dendrogram", 
     xlab = "Data Points (Cars)", sub = "", ylab = "Distance")
# Highlight clusters
rect.hclust(hc, k = 3, border = "red")
dev.off()

# ---------------------------------------------------------
# 5. Principal Component Analysis (PCA)
# ---------------------------------------------------------
png("images/05_pca.png", width = 600, height = 500)
# Using the built-in iris dataset
pca_result <- prcomp(iris[, 1:4], center = TRUE, scale. = TRUE)
# Create a biplot showing data points and principal component vectors
biplot(pca_result, main = "PCA Biplot (Iris Dataset)", 
       cex = c(0.6, 0.8), col = c("darkgray", "red"))
dev.off()

print("Images successfully generated in the 'images/' folder!")