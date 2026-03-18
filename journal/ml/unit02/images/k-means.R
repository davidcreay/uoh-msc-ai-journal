library(ggplot2)
library(magick)

# 1. Generate dummy data with IDs
set.seed(42)
data_points <- data.frame(
  id = 1:150, # Added IDs to track points during compression
  x = c(rnorm(50, 2, 1), rnorm(50, 8, 1), rnorm(50, 5, 1)),
  y = c(rnorm(50, 2, 1), rnorm(50, 8, 1), rnorm(50, 2, 1)),
  cluster = factor(NA, levels = 1:3) # Initialize empty cluster column
)

# 2. Setup K-Means parameters
k <- 3
centroids <- data_points[sample(1:nrow(data_points), k), c("x", "y")]
centroids$cluster <- factor(1:k)

# 3. Setup Convergence Tracking
converged <- FALSE
iteration <- 1
max_safe_iterations <- 20 # Safety net to prevent infinite loops

# 4. The K-Means Convergence Loop
while (!converged && iteration <= max_safe_iterations) {
  
  # Store the old cluster assignments to check for changes later
  old_clusters <- data_points$cluster
  
  # --- STEP A: ASSIGNMENT ---
  dists <- as.matrix(dist(rbind(centroids[, c("x", "y")], data_points[, c("x", "y")])))[1:k, (k+1):(k+nrow(data_points))]
  data_points$cluster <- factor(apply(dists, 2, which.min), levels = 1:k)
  
  p_assign <- ggplot(data_points, aes(x = x, y = y, color = cluster)) + 
    geom_point(alpha = 0.6, size = 3) +
    geom_point(data = centroids, aes(x = x, y = y, fill = cluster), 
               size = 6, shape = 21, color = "black", stroke = 1.5) +
    ggtitle(sprintf("Iteration %d: Assign Points to Nearest Centroid", iteration)) +
    theme_minimal() + theme(legend.position = "none")
  
  ggsave(sprintf("frame_%03d_A.png", iteration), plot = p_assign, width = 6, height = 5, bg = "white")
  
  # --- CONVERGENCE CHECK ---
  # If the assignments haven't changed from the last loop, we have converged!
  if (identical(as.character(old_clusters), as.character(data_points$cluster))) {
    converged <- TRUE
    break # Exit the while loop immediately
  }
  
  # --- STEP B: UPDATE CENTROIDS ---
  new_centroids <- aggregate(data_points[, c("x", "y")], by = list(cluster = data_points$cluster), FUN = mean)
  centroids[, c("x", "y")] <- new_centroids[, c("x", "y")]
  
  p_update <- ggplot(data_points, aes(x = x, y = y, color = cluster)) + 
    geom_point(alpha = 0.6, size = 3) +
    geom_point(data = centroids, aes(x = x, y = y, fill = cluster), 
               size = 6, shape = 21, color = "black", stroke = 1.5) +
    ggtitle(sprintf("Iteration %d: Update Centroid Positions", iteration)) +
    theme_minimal() + theme(legend.position = "none")
  
  ggsave(sprintf("frame_%03d_B.png", iteration), plot = p_update, width = 6, height = 5, bg = "white")
  
  iteration <- iteration + 1
}

# --- STEP C: COMPRESSION (Vector Quantization) ---
# Replace original x, y coordinates with the centroid's x, y coordinates
compressed_points <- merge(data_points[, c("id", "cluster")], centroids, by="cluster")

p_compress <- ggplot(compressed_points, aes(x = x, y = y, color = cluster)) + 
  # We use jitter here so you can visually see all the points stacked on top of each other
  geom_jitter(width = 0.15, height = 0.15, alpha = 0.5, size = 3) + 
  geom_point(data = centroids, aes(x = x, y = y, fill = cluster), 
             size = 6, shape = 21, color = "black", stroke = 1.5) +
  ggtitle("Data Compression: Points Replaced by Centroids") +
  theme_minimal() + theme(legend.position = "none")

# Save 4 identical frames of the final state so the GIF pauses on the compression step
for(j in 1:4) {
  ggsave(sprintf("frame_%03d_C%d.png", iteration, j), plot = p_compress, width = 6, height = 5, bg = "white")
}

# 5. Compile the GIF
# Using sort() ensures the frames are stitched in the exact alphabetical/numerical order
png_files <- sort(list.files(pattern = "^frame_.*\\.png$"))

img_list <- lapply(png_files, image_read)
img_joined <- image_join(img_list)
img_animated <- image_animate(img_joined, fps = 2)

image_write(img_animated, "kmeans_compression.gif")

print(sprintf("GIF complete! The algorithm converged in %d iterations.", iteration))