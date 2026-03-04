# ==============================================================================
# Neural Gas Demonstration with GIF output
# Prerequisites: install.packages("magick")
# ==============================================================================
library(magick)
set.seed(42) # Different seed for different starting clusters

# --- 1. Generate Synthetic Data (4 Clusters) ---
# More complex dataset to show Neural Gas advantages.
n_points_per_blob <- 150
std_dev <- 0.5

blob1 <- matrix(rnorm(n_points_per_blob * 2, mean = 2, sd = std_dev), ncol = 2) # Top-Left
blob2 <- matrix(rnorm(n_points_per_blob * 2, mean = 6, sd = 0.6), ncol = 2)     # Top-Right
blob3 <- matrix(rnorm(n_points_per_blob * 2, mean = c(2, 6), sd = 0.5), ncol = 2)# Bottom-Left
blob4 <- matrix(rnorm(n_points_per_blob * 2, mean = 6, sd = 0.6), ncol = 2)    # Bottom-Right
blob4[,1] <- blob4[,1] - 4 # Adjust x mean for bottom-right

# Combine into one dataset
dataset <- rbind(blob1, blob2, blob3, blob4)
N <- nrow(dataset)

# --- 2. Neural Gas Parameters and Initialization ---
# Number of competitive units (prototypes) - use plenty
N_p <- 15 

# Initialize prototype vectors (weights) randomly within the data range
x_range <- range(dataset[,1])
y_range <- range(dataset[,2])
prototypes <- cbind(runif(N_p, x_range[1], x_range[2]),
                    runif(N_p, y_range[1], y_range[2]))

# Color palette for prototypes (gradient based on ID)
proto_colors <- colorRampPalette(c("cyan", "darkblue"))(N_p)

# Total training epochs
total_epochs <- 50

# --- NG ANNEALING PARAMETERS (Key to Neural Gas) ---
# These parameters must decrease over time.

# 1. Learning Rate (eps): How much prototypes move towards input.
eps_start <- 0.5
eps_end <- 0.01

# 2. Neighborhood Factor (lambda): How many prototypes move besides the winner.
# It should start near the total number of prototypes.
lambda_start <- N_p / 2
lambda_end <- 0.01

# --- 3. Training Loop and Visualization Setup ---
# Setup image capturing graphics device
# Remember: widths/heights must be integers, fps must be factor of 100
img_frames <- image_graph(width = 800, height = 600, res = 96)

# Base plotting function
plot_base <- function(main_title, current_eps, current_lambda) {
  subtitle_text <- paste0("Epsilon: ", round(current_eps, 3), 
                         " (Learning Rate), Lambda: ", round(current_lambda, 3), " (Neighborhood)")
  
  plot(dataset, pch=19, col=rgb(0.7, 0.7, 0.7, 0.2), cex=0.8,
       xlim=c(0, 8), ylim=c(0, 8), xlab="Feature X", ylab="Feature Y",
       main = main_title)
  mtext(subtitle_text, side = 3, line = 0.5, cex = 0.85, col = "darkgray")
  grid()
  # Plot prototypes as big 'X's with color gradient
  points(prototypes, pch=4, col=proto_colors, lwd=6, cex=3)
}

# Add Initial State frame
# Using _start parameters for visualization
plot_base("Neural Gas: Initialization (Random Layout)", eps_start, lambda_start)

message("Training Neural Gas and capturing frames...")

for (epoch in 1:total_epochs) {
  
  # --- Step A: Anneal (Decay) Parameters ---
  # These decay exponentially over the total training period.
  # Fraction of progress
  frac <- epoch / total_epochs
  
  # Calculate current parameters based on exponential decay formula
  current_eps <- eps_start * (eps_end / eps_start)^frac
  current_lambda <- lambda_start * (lambda_end / lambda_start)^frac
  
  # Shuffle data points
  sample_indices <- sample(1:N)
  shuffled_data <- dataset[sample_indices, ]
  
  # Process each data point
  for (i in 1:N) {
    input_vector <- shuffled_data[i, ]
    
    # --- Step B: Distance Calculation ---
    # Calculate Euclidean distance to ALL prototypes
    # apply function along rows (1)
    distances <- apply(prototypes, 1, function(p) sum((input_vector - p)^2)) # Squared distance is faster
    
    # --- Step C: Ranking (Key NG Step) ---
    # Find the rank of each prototype by distance. 
    # rank() returns indices sorted. winner has rank 1.
    # NG often uses 0-based indexing for the rank itself, so we subtract 1.
    # The variable k represents the rank: 0 is winner, 1 is second closest, etc.
    k_ranks <- rank(distances, ties.method = "random") - 1
    
    # --- Step D: Soft Learning Step (All prototypes update!) ---
    # Loop over all prototypes
    for (proto_idx in 1:N_p) {
       rank_k <- k_ranks[proto_idx]
       
       # Calculate neighborhood function h_k (exponential decay by rank)
       # Winner (rank 0) gets exp(0) = 1.
       h_k <- exp(-rank_k / current_lambda)
       
       # Update rule for *this* prototype: move closer based on its rank
       delta_w <- current_eps * h_k * (input_vector - prototypes[proto_idx, ])
       prototypes[proto_idx, ] <- prototypes[proto_idx, ] + delta_w
    }
    
    # --- Step E: Sparse Frame Capture ---
    # (Capturing inside the inner loop is extremely heavy!)
    # Capture early on (epoch 1) and sporadically to show internal flow.
    if (epoch %in% c(1, 2) && i %% floor(N/4) == 0) {
       plot_base(paste0("Neural Gas Learning: Epoch ", epoch, ", Point ", i, "/", N), 
                 current_eps, current_lambda)
       # Visual connector to winner
       winner_idx <- which.min(distances)
       points(input_vector[1], input_vector[2], col="black", pch=19, cex=1)
       lines(rbind(input_vector, prototypes[winner_idx,]), col="black", lty=2)
    }
  }
  
  # Post-epoch: Capture frame showing state after processing all data
  title_epoch <- paste0("Neural Gas: End of Epoch ", epoch)
  plot_base(title_epoch, current_eps, current_lambda)
}

# Final result frame
# Use end parameters for final visualization
plot_base("Neural Gas: Final State (Covering Data Density)", eps_end, lambda_end)

# Close the graphics device
dev.off()

# --- 4. Generate and Save GIF ---
message("Compiling GIF...")
# Use 'img_frames' (which captured all the plots)
animation <- image_animate(img_frames, fps = 10) 
image_write(animation, "neural_gas_learning.gif")