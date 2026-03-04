# ==============================================================================
# Simple Competitive Learning (SCL) Demonstration with GIF output
# Prerequisites: install.packages("magick")
# ==============================================================================
library(magick)
set.seed(123) # For reproducibility

# --- 1. Generate Synthetic Data (3 Blobs) ---
# SCL is used for clustering. Let's make three distinct clusters in 2D.
n_points_per_blob <- 150

# Cluster 1: Top-Left
blob1 <- matrix(rnorm(n_points_per_blob * 2, mean = 2, sd = 0.5), ncol = 2)
# Cluster 2: Bottom-Right
blob2 <- matrix(rnorm(n_points_per_blob * 2, mean = 6, sd = 0.7), ncol = 2)
# Cluster 3: Top-Right
blob3 <- matrix(rnorm(n_points_per_blob * 2, mean = c(6, 2), sd = 0.6), ncol = 2)

# Combine into one dataset
dataset <- rbind(blob1, blob2, blob3)
N <- nrow(dataset)

# --- 2. SCL Parameters and Initialization ---
# Number of competitive units (prototypes)
K <- 3 

# Initialize prototype vectors (weights) randomly within the data range
x_range <- range(dataset[,1])
y_range <- range(dataset[,2])
prototypes <- cbind(runif(K, x_range[1], x_range[2]),
                    runif(K, y_range[1], y_range[2]))

# Initial Learning Rate (controls how fast prototypes move)
alpha_init <- 0.2
# Total training epochs
total_epochs <- 30

# Colors for the prototypes to track them easily
proto_colors <- rainbow(K)

# --- 3. Training Loop and Visualization Setup ---
# Use magick to record plots directly
img_frames <- image_graph(width = 800, height = 600, res = 96)

# Base plotting function to keep frames consistent
plot_base <- function(main_title) {
  plot(dataset, pch=19, col=rgb(0.7, 0.7, 0.7, 0.2), cex=0.8,
       xlim=c(0, 9), ylim=c(0, 9), xlab="Feature X", ylab="Feature Y",
       main = main_title)
  grid()
  # Plot initial prototypes as big 'X's
  points(prototypes, pch=4, col=proto_colors, lwd=6, cex=3)
}

# Add Initial State frame
plot_base("SCL: Initialization (Random Prototype Centers)")

message("Training SCL and capturing frames...")

# SCL TRAINING LOOP
current_alpha <- alpha_init

for (epoch in 1:total_epochs) {
  
  # Shuffle data points at the start of each epoch
  sample_indices <- sample(1:N)
  shuffled_data <- dataset[sample_indices, ]
  
  # Process each data point
  for (i in 1:N) {
    input_vector <- shuffled_data[i, ]
    
    # --- A. Competition Step ---
    # Find the winner: Calculate Euclidean distance to all prototypes
    distances <- apply(prototypes, 1, function(p) sum((input_vector - p)^2)) # Squared distance is faster
    winner_idx <- which.min(distances)
    
    # --- B. Learning Step (Winner-Takes-All) ---
    # Update ONLY the winning prototype, moving it closer to the input
    delta_w <- current_alpha * (input_vector - prototypes[winner_idx, ])
    prototypes[winner_idx, ] <- prototypes[winner_idx, ] + delta_w
    
    # --- C. Frame Capture ---
    # Capturing every update is too heavy. Capture at key moments.
    
    # Early learning: capture frequently
    if (epoch == 1 && i %% 15 == 0) {
       title <- paste0("SCL Learning: Epoch 1, Point ", i, "/", N)
       plot_base(title)
       # Visual cue connecting data point to the winner
       lines(rbind(input_vector, prototypes[winner_idx,]), col=proto_colors[winner_idx], lty=2)
       points(input_vector[1], input_vector[2], col="black", pch=19, cex=1)
    }
  }
  
  # Post-epoch: Capture frame showing state after processing all data
  title_epoch <- paste0("SCL: End of Epoch ", epoch, " (Learning Rate: ", round(current_alpha, 3), ")")
  plot_base(title_epoch)
  
  # Decay Learning Rate (annealing) - learning should slow down over time
  current_alpha <- alpha_init * (1 - (epoch / total_epochs))
  # Don't let alpha hit exact 0 immediately
  if (current_alpha < 0.01) current_alpha <- 0.01 
}

# Final result frame
plot_base("SCL: Final State (Prototypes as Cluster Centers)")

# Close the graphics device
dev.off()

# --- 4. Generate and Save GIF ---
message("Compiling GIF...")
# Use 'img_frames' (which captured all the plots), not the output of dev.off()
animation <- image_animate(img_frames, fps = 10) 
image_write(animation, "scl_learning.gif")