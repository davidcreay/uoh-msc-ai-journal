# ==============================================================================
# Self-Organizing Map (SOM) Demonstration with GIF output
# Prerequisites: install.packages("magick")
# ==============================================================================
library(magick)
set.seed(42) # Consistent seed for data generation and initialization

# --- 1. Generate Synthetic Data (4 Clusters) ---
n_points_per_blob <- 125
std_dev <- 0.5

blob1 <- matrix(rnorm(n_points_per_blob * 2, mean = 2, sd = std_dev), ncol = 2) # Top-Left
blob2 <- matrix(rnorm(n_points_per_blob * 2, mean = 6, sd = 0.6), ncol = 2)     # Top-Right
blob3 <- matrix(rnorm(n_points_per_blob * 2, mean = c(2, 6), sd = 0.5), ncol = 2)# Bottom-Left
blob4 <- matrix(rnorm(n_points_per_blob * 2, mean = c(6, 2), sd = 0.6), ncol = 2)# Bottom-Right

# Combine into one dataset
dataset <- rbind(blob1, blob2, blob3, blob4)
N <- nrow(dataset)

# --- 2. SOM Grid Setup and Initialization ---
# Grid Dimensions (6x6 lattice = 36 neurons)
grid_dim_x <- 6
grid_dim_y <- 6
N_p <- grid_dim_x * grid_dim_y

# Create the 2D Grid coordinates matrix (Crucial for neighbor calculation!)
# This is NOT the location in data space, but the location on the map.
# Example: Neuron 1 is at (1,1), Neuron 2 is at (2,1), etc.
grid_coords <- as.matrix(expand.grid(x = 1:grid_dim_x, y = 1:grid_dim_y))

# Create the actual weight vectors (prototypes) in data space.
# We map from 2D data (Feature X, Feature Y) to the grid.
# Initialize weights randomly within the input data range.
x_range <- range(dataset[,1])
y_range <- range(dataset[,2])
prototypes <- cbind(runif(N_p, x_range[1], x_range[2]),
                    runif(N_p, y_range[1], y_range[2]))

# Add grid info to prototypes matrix (for easier plotting/indexing)
proto_with_grid <- cbind(grid_coords, prototypes)
# Col 1: GridX, Col 2: GridY, Col 3: DataX, Col 4: DataY

# Color palette for the grid connections (makes it easier to trace flow)
proto_colors <- colorRampPalette(c("cyan", "royalblue4"))(grid_dim_y)

# --- 3. SOM ANNEALING PARAMETERS (Exponential Decay) ---
total_epochs <- 50

# 1. Learning Rate (eps): How much neurons move
eps_start <- 0.5
eps_end <- 0.01

# 2. Neighborhood Size (sigma): How many grid neighbors move (Sigma on the GRID)
# It should start large (covering half the grid) and decay to < 1.
sigma_start <- max(grid_dim_x, grid_dim_y) / 2
sigma_end <- 0.1

# --- 4. Training Loop and Visualization Setup ---
# Setup graphics device for image capture (W/H integers, fps factor of 100)
img_frames <- image_graph(width = 800, height = 600, res = 96)

# Function to plot the SOM grid *connections* (the mesh)
plot_som_grid <- function(proto_matrix, col_base, ...){
  # 1. Plot horizontal lines (connect points in same Grid row)
  for (y_val in 1:grid_dim_y) {
    indices <- which(proto_matrix[,2] == y_val)
    # Sort by GridX for correct connection order
    sorted_idx <- indices[order(proto_matrix[indices,1])]
    lines(proto_matrix[sorted_idx, 3:4], col=col_base[y_val], lwd=2, ...)
  }
  # 2. Plot vertical lines (connect points in same Grid column)
  for (x_val in 1:grid_dim_x) {
    indices <- which(proto_matrix[,1] == x_val)
    # Sort by GridY
    sorted_idx <- indices[order(proto_matrix[indices,2])]
    lines(proto_matrix[sorted_idx, 3:4], col="gray40", lwd=2, lty=3, ...)
  }
}

# Base plotting function
plot_base <- function(main_title, current_eps, current_sigma) {
  subtitle_text <- paste0("Epsilon (LR): ", round(current_eps, 3), 
                         " | Sigma (Grid Spread): ", round(current_sigma, 3))
  
  plot(dataset, pch=19, col=rgb(0.7, 0.7, 0.7, 0.2), cex=0.8,
       xlim=c(0, 8), ylim=c(0, 8), xlab="Feature X", ylab="Feature Y",
       main = main_title)
  mtext(subtitle_text, side = 3, line = 0.5, cex = 0.85, col = "darkgray")
  grid()
  
  # A. Plot SOM Grid Mesh
  plot_som_grid(proto_with_grid, proto_colors)
  
  # B. Plot neurons as big dots with color gradient
  points(proto_with_grid[,3:4], pch=21, bg=proto_colors[proto_with_grid[,2]], col="black", cex=2.2, lwd=2.5)
}

# Add Initial State frame
# (Grid is randomized and crumpled up in the data range)
plot_base("SOM: Initialization (Random Lattice)", eps_start, sigma_start)

message("Training SOM and capturing frames...")

for (epoch in 1:total_epochs) {
  
  # --- Step A: Decay (Anneal) Parameters ---
  frac <- epoch / total_epochs
  # Calculate current parameters based on exponential decay formula
  current_eps <- eps_start * (eps_end / eps_start)^frac
  current_sigma <- sigma_start * (sigma_end / sigma_start)^frac
  
  # --- Step B: Shuffle data ---
  sample_indices <- sample(1:N)
  shuffled_data <- dataset[sample_indices, ]
  
  # --- Step C: Loop through data points ---
  for (i in 1:N) {
    input_vector <- shuffled_data[i, ]
    
    # 1. Competition: Find Best Matching Unit (BMU)
    # Calculate Euclidean distance to all prototypes IN DATA SPACE
    # (Use columns 3 and 4 of proto_with_grid)
    distances <- apply(proto_with_grid[,3:4], 1, function(p) sum((input_vector - p)^2)) # Squared distance
    bmu_idx <- which.min(distances)
    
    # 2. Get BMU grid coordinates
    bmu_grid_pos <- grid_coords[bmu_idx, ]
    
    # 3. Learning Step (BMU and neighbors update!)
    # Loop over ALL prototypes
    for (proto_idx in 1:N_p) {
        # Current prototype's grid location
        proto_grid_pos <- grid_coords[proto_idx, ]
        
        # A. Calculate distance ON THE GRID (NOT data space!)
        d_grid_sq <- sum((bmu_grid_pos - proto_grid_pos)^2) # Squared Euclidean on grid lattice
        
        # B. Gaussian Neighborhood Function: h_j,i
        # Defines how strongly this neighbor is updated based on grid distance.
        h_j_i <- exp(-d_grid_sq / (2 * current_sigma^2))
        
        # C. Update Rule (Self-Organizing Step)
        delta_w <- current_eps * h_j_i * (input_vector - proto_with_grid[proto_idx, 3:4])
        proto_with_grid[proto_idx, 3:4] <- proto_with_grid[proto_idx, 3:4] + delta_w
    }
    
    # --- Step D: Sparse Frame Capture ---
    # Capture sporadic snapshots during the FIRST epoch to show "unfolding" flow
    if (epoch %in% c(1, 2) && i %% floor(N/4) == 0) {
       plot_base(paste0("SOM Learning: Epoch ", epoch, ", Point ", i, "/", N), 
                 current_eps, current_sigma)
       # Visual indicator connecting data to BMU
       points(input_vector[1], input_vector[2], col="black", pch=19, cex=1)
       lines(rbind(input_vector, proto_with_grid[bmu_idx, 3:4]), col="black", lty=2)
    }
  }
  
  # Post-epoch: Capture frame showing state after processing all data
  title_epoch <- paste0("SOM: End of Epoch ", epoch)
  plot_base(title_epoch, current_eps, current_sigma)
}

# Final result frame
plot_base("SOM: Final State (Topological Map Unfolded)", eps_end, sigma_end)

# Close graphics device
dev.off()

# --- 4. Generate and Save GIF ---
message("Compiling GIF...")
# Use 10 fps (must be factor of 100!)
animation <- image_animate(img_frames, fps = 10) 
image_write(animation, "som_learning.gif")
message("Successfully created 'som_learning.gif'")