library(magick)

# --- 1. Create the Optimal Learning Rate GIF ---
# List all the PNG files for the optimal learning rate, in order
optimal_files <- list.files(path = "images/vq_animation", pattern = "optimal_lr_.*\\.png", full.names = TRUE)

# Read them into a magick image object and animate them (1 fps)
optimal_gif <- image_animate(image_read(optimal_files), fps = 1)

# Save the GIF
image_write(optimal_gif, "images/optimal_learning_rate.gif")


# --- 2. Create the High Learning Rate GIF ---
# List all the PNG files for the high learning rate
high_files <- list.files(path = "images/vq_animation", pattern = "high_lr_.*\\.png", full.names = TRUE)

# Read and animate
high_gif <- image_animate(image_read(high_files), fps = 1)

# Save the GIF
image_write(high_gif, "images/high_learning_rate.gif")

print("GIFs successfully created!")