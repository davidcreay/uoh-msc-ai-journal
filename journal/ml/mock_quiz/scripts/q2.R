# Create a dedicated directory for the animation frames
dir.create("images/vq_animation", recursive = TRUE, showWarnings = FALSE)

# Generate a synthetic "cluster" of data points
set.seed(42)
data_points <- matrix(rnorm(100, mean = 5, sd = 1), ncol = 2)

# Function to simulate Vector Quantization and save frames
simulate_vq <- function(learning_rate, prefix, frames = 20) {
  # Start the codevector far away from the data
  codevector <- c(0, 0)
  
  # Ensure the same random sequence of target points for fair comparison
  set.seed(99) 
  
  for (i in 1:frames) {
    # Create a padded filename (e.g., high_lr_001.png)
    filename <- sprintf("images/vq_animation/%s_%03d.png", prefix, i)
    png(filename, width = 600, height = 600)
    
    # 1. Plot the background data points
    plot(data_points, col = "lightgray", pch = 16, xlim = c(-2, 10), ylim = c(-2, 10),
         xlab = "Feature 1", ylab = "Feature 2", 
         main = sprintf("Vector Quantization (Learning Rate = %.1f)\nStep %d", learning_rate, i))
    
    # 2. Draw the codevector's current (old) position
    points(codevector[1], codevector[2], col = "red", pch = 4, cex = 2, lwd = 2)
    
    # 3. Pick a random data point as the "target" for this step
    target_idx <- sample(1:nrow(data_points), 1)
    target <- data_points[target_idx, ]
    points(target[1], target[2], col = "blue", pch = 16, cex = 1.8)
    
    # 4. Calculate the new position based on the learning rate equation:
    # w_new = w_old + learning_rate * (x - w_old)
    new_codevector <- codevector + learning_rate * (target - codevector)
    
    # 5. Draw an arrow showing the movement
    arrows(codevector[1], codevector[2], new_codevector[1], new_codevector[2], 
           col = "red", lwd = 2, length = 0.1)
    
    # 6. Draw the codevector's new position
    points(new_codevector[1], new_codevector[2], col = "darkred", pch = 19, cex = 2)
    
    # Add a legend
    legend("topleft", legend = c("Data Cluster", "Random Target Point", "Codevector", "Movement Vector"),
           col = c("lightgray", "blue", "darkred", "red"), 
           pch = c(16, 16, 19, NA), lty = c(NA, NA, NA, 1), lwd = 2)
    
    dev.off()
    
    # Update the codevector for the next loop iteration
    codevector <- new_codevector
  }
}

# Run the simulation for an optimal learning rate (smooth convergence)
simulate_vq(learning_rate = 0.1, prefix = "optimal_lr")

# Run the simulation for a high learning rate (overshooting/oscillation)
simulate_vq(learning_rate = 1.2, prefix = "high_lr")

print("Animation frames successfully generated in 'images/vq_animation/'!")