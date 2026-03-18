# Install required packages if you don't have them:
# install.packages(c("ggplot2", "gganimate", "dplyr", "transformr", "gifski"))

library(ggplot2)
library(gganimate)
library(dplyr)

# Create the images subdirectory
dir.create("images", showWarnings = FALSE)

# ---------------------------------------------------------
# 1. Perceptron Animation: Finding a linear decision boundary
# ---------------------------------------------------------
# Generate some linearly separable dummy data
set.seed(42)
data_class1 <- data.frame(x = rnorm(20, 2, 0.5), y = rnorm(20, 2, 0.5), class = "A")
data_class2 <- data.frame(x = rnorm(20, 4, 0.5), y = rnorm(20, 4, 0.5), class = "B")
perceptron_data <- rbind(data_class1, data_class2)

# Create a dataframe for the moving decision boundary (learning over epochs)
boundary_data <- data.frame(
  epoch = 1:10,
  intercept = seq(6, 0, length.out = 10),
  slope = seq(0, -1, length.out = 10)
)

p1 <- ggplot(perceptron_data, aes(x = x, y = y, color = class)) +
  geom_point(size = 3) +
  geom_abline(data = boundary_data, aes(intercept = intercept, slope = slope), color = "black", linewidth = 1) +
  theme_minimal() +
  labs(title = "Perceptron Learning: Epoch {frame_time}",
       x = "Input 1", y = "Input 2") +
  transition_time(epoch) +
  ease_aes('linear')

# Save the animation
anim_save("images/perceptron.gif", animation = p1, width = 600, height = 400)


# ---------------------------------------------------------
# 2. Hebbian Learning Animation: Strengthening a connection
# ---------------------------------------------------------
# Simulating two neurons firing together and their connection thickening
hebbian_data <- data.frame(
  time = 1:20,
  weight = seq(0.1, 3, length.out = 20),
  neuron1_fire = rep(c("On", "Off"), 10),
  neuron2_fire = rep(c("On", "Off"), 10)
)

p2 <- ggplot(hebbian_data) +
  # Draw a line between two points (neurons) that gets thicker over time
  geom_segment(aes(x = 1, y = 1, xend = 3, yend = 1, linewidth = weight), color = "blue", alpha = 0.6) +
  # Neuron 1
  geom_point(aes(x = 1, y = 1, size = ifelse(neuron1_fire == "On", 10, 5)), color = "orange") +
  # Neuron 2
  geom_point(aes(x = 3, y = 1, size = ifelse(neuron2_fire == "On", 10, 5)), color = "orange") +
  scale_size_identity() +
  theme_void() +
  labs(title = 'Hebbian Learning: "Fire together, wire together"',
       subtitle = 'Connection Weight Increasing over time: {frame_time}') +
  theme(plot.title = element_text(hjust = 0.5, size = 16),
        plot.subtitle = element_text(hjust = 0.5, size = 12)) +
  transition_time(time)

# Save the animation
anim_save("images/hebbian.gif", animation = p2, width = 600, height = 400)

print("Animations generated successfully in the 'images' folder.")