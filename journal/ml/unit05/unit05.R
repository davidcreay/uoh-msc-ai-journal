# Create the "images" directory if it doesn't already exist
dir.create("images", showWarnings = FALSE)

# ---------------------------------------------------------
# 11. Maximum Margin Classification (REALIGNED)
# ---------------------------------------------------------
png("images/11_maximum_margin_fixed.png", width = 600, height = 500)
set.seed(42)

# 1. Generate random clusters
x_red <- runif(15, 1, 4); y_red <- runif(15, 5, 8)
x_blue <- runif(15, 5, 8); y_blue <- runif(15, 1, 4)

# 2. DESIGNATE real Support Vectors from the data
# We'll pick one point from each that is closest to the 'gap'
sv_red <- c(max(x_red), min(y_red))    # Bottom-right of red cluster
sv_blue <- c(min(x_blue), max(y_blue)) # Top-left of blue cluster

# 3. Geometric Math for the "90 Degree" Rotation
# Slope of the line connecting the two SVs
m_connect <- (sv_blue[2] - sv_red[2]) / (sv_blue[1] - sv_red[1])

# The Hyperplane slope is the negative reciprocal (Orthogonal/90 degrees)
m_hyper <- -1 / m_connect

# Find the midpoint to center the hyperplane
mid <- (sv_red + sv_blue) / 2
intercept_hyper <- mid[2] - (m_hyper * mid[1])

# 4. Plotting
plot(c(x_red, x_blue), c(y_red, y_blue), 
     col = c(rep("red", 15), rep("blue", 15)), pch = 16, 
     xlim = c(0, 9), ylim = c(0, 9),
     xlab = "Feature 1", ylab = "Feature 2", 
     main = "SVM: Hyperplane Orthogonal to Support Vectors")

# Draw the Optimal Hyperplane (The Decision Boundary)
abline(a = intercept_hyper, b = m_hyper, col = "black", lwd = 3)

# Draw the Margins (These MUST pass through the SVs)
abline(a = sv_red[2] - m_hyper * sv_red[1], b = m_hyper, col = "gray", lty = 2)
abline(a = sv_blue[2] - m_hyper * sv_blue[1], b = m_hyper, col = "gray", lty = 2)

# 5. Highlight the ACTUAL Support Vectors
points(sv_red[1], sv_red[2], col = "darkgreen", cex = 2, lwd = 2)
points(sv_blue[1], sv_blue[2], col = "darkgreen", cex = 2, lwd = 2)
text(sv_red[1], sv_red[2]-0.5, "SV (Active Constraint)", col = "darkgreen", cex = 0.8)
text(sv_blue[1], sv_blue[2]+0.5, "SV (Active Constraint)", col = "darkgreen", cex = 0.8)

dev.off()

# ---------------------------------------------------------
# 12. The Kernel Trick (Non-linear Mapping)
# ---------------------------------------------------------
png("images/12_kernel_trick.png", width = 800, height = 400)
par(mfrow = c(1, 2))
set.seed(123)

# Original 2D Space (Non-linearly separable target pattern)
angles <- runif(30, 0, 2*pi)
inner_r <- runif(30, 0, 1.5)
outer_r <- runif(30, 2.5, 4)

x_inner <- inner_r * cos(angles)
y_inner <- inner_r * sin(angles)
x_outer <- outer_r * cos(angles)
y_outer <- outer_r * sin(angles)

plot(c(x_inner, x_outer), c(y_inner, y_outer), 
     col = c(rep("red", 30), rep("blue", 30)), pch = 16,
     xlab = "X1", ylab = "X2", main = "Original 2D Space\n(Cannot separate with a line)")

# Transformed Space using a "Kernel" (Distance from origin squared)
# Mapping: Z = X1^2 + X2^2
z_inner <- x_inner^2 + y_inner^2
z_outer <- x_outer^2 + y_outer^2

plot(c(x_inner, x_outer), c(z_inner, z_outer), 
     col = c(rep("red", 30), rep("blue", 30)), pch = 16,
     xlab = "Original X1", ylab = "Z (Mapped Feature: X1^2 + X2^2)", 
     main = "Mapped Feature Space\n(Linearly Separable)")

# Now we can draw a linear separating hyperplane in this new dimension
abline(h = 4, col = "black", lwd = 2, lty = 2)
dev.off()

print("Images for Unit 5 successfully generated in the 'images/' folder!")