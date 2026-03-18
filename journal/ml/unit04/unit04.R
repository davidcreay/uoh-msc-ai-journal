# Create the "images" directory if it doesn't already exist
dir.create("images", showWarnings = FALSE)

# ---------------------------------------------------------
# 6. Classification vs Regression
# ---------------------------------------------------------
png("images/06_classification_vs_regression.png", width = 800, height = 400)
par(mfrow = c(1, 2)) # Side-by-side plots
set.seed(123)

# Classification Plot
x_class1 <- rnorm(20, mean = 2, sd = 1)
y_class1 <- rnorm(20, mean = 2, sd = 1)
x_class2 <- rnorm(20, mean = 6, sd = 1)
y_class2 <- rnorm(20, mean = 6, sd = 1)
plot(c(x_class1, x_class2), c(y_class1, y_class2), 
     col = c(rep("red", 20), rep("blue", 20)), pch = 16,
     main = "Classification (Discrete Classes)", xlab = "Feature 1", ylab = "Feature 2")
abline(a = 8, b = -1, lty = 2, col = "gray", lwd = 2) # Separation boundary

# Regression Plot
x_reg <- runif(40, 1, 10)
y_reg <- 2 * x_reg + rnorm(40, mean = 0, sd = 2)
plot(x_reg, y_reg, col = "darkgreen", pch = 16, 
     main = "Regression (Continuous Prediction)", xlab = "Feature (X)", ylab = "Target (Y)")
abline(lm(y_reg ~ x_reg), col = "black", lwd = 2) # Line of best fit
dev.off()

# ---------------------------------------------------------
# 7. Linear Regression
# ---------------------------------------------------------
png("images/07_linear_regression.png", width = 600, height = 400)
set.seed(42)
x <- 1:20
y <- 3 + 1.5 * x + rnorm(20, sd = 4)
fit <- lm(y ~ x)
plot(x, y, pch = 16, col = "blue", main = "Linear Regression with Residuals", 
     xlab = "Input Feature", ylab = "Predicted Value")
abline(fit, col = "red", lwd = 2)
# Draw residuals (errors)
segments(x, y, x, fitted(fit), col = "gray", lty = 2)
dev.off()

# ---------------------------------------------------------
# 8. K-Nearest Neighbours Concept
# ---------------------------------------------------------
png("images/08_knn_concept.png", width = 500, height = 500)
set.seed(7)
plot(c(x_class1, x_class2), c(y_class1, y_class2), 
     col = c(rep("red", 20), rep("blue", 20)), pch = 16, xlim = c(0, 8), ylim = c(0, 8),
     main = "K-Nearest Neighbours (K=3)", xlab = "Feature 1", ylab = "Feature 2")
# New unknown point
new_x <- 4; new_y <- 4
points(new_x, new_y, pch = 4, col = "black", cex = 2, lwd = 3)
text(new_x, new_y - 0.4, "New Data Point")
# Draw a circle around the 3 nearest neighbors
symbols(new_x, new_y, circles = 1.6, inches = FALSE, add = TRUE, fg = "darkgreen", lwd = 2, lty = 2)
dev.off()

# ---------------------------------------------------------
# 9. Generalisation vs Overfitting
# ---------------------------------------------------------
png("images/09_overfitting_generalisation.png", width = 800, height = 300)
par(mfrow = c(1, 3))
set.seed(99)
x <- seq(0, 10, length.out = 15)
y <- sin(x) + rnorm(15, sd = 0.3)
x_smooth <- seq(0, 10, length.out = 100)

# Underfitting (Straight line)
plot(x, y, pch = 16, main = "Underfitting (Too Simple)")
lines(x_smooth, predict(lm(y ~ x), data.frame(x = x_smooth)), col = "blue", lwd = 2)

# Optimal / Generalisation
plot(x, y, pch = 16, main = "Good Generalisation")
lines(x_smooth, predict(lm(y ~ poly(x, 4)), data.frame(x = x_smooth)), col = "green", lwd = 2)

# Overfitting (Connecting every dot)
plot(x, y, pch = 16, main = "Overfitting (Too Complex)")
lines(x_smooth, predict(lm(y ~ poly(x, 14)), data.frame(x = x_smooth)), col = "red", lwd = 2)
dev.off()

# ---------------------------------------------------------
# 10. Train / Validation / Test Split
# ---------------------------------------------------------
png("images/10_train_val_test.png", width = 600, height = 200)
par(mar = c(1, 1, 3, 1))
plot(c(0, 100), c(0, 1), type = "n", axes = FALSE, xlab = "", ylab = "", 
     main = "Dataset Split for Model Evaluation")
# Draw blocks representing the data proportions
rect(0, 0, 60, 1, col = "lightblue", border = "black", lwd = 2)
text(30, 0.5, "Training Set (60%)\nUsed to train model", cex = 1.2)

rect(60, 0, 80, 1, col = "lightgreen", border = "black", lwd = 2)
text(70, 0.5, "Validation Set (20%)\nTune hyperparameters", cex = 0.9)

rect(80, 0, 100, 1, col = "salmon", border = "black", lwd = 2)
text(90, 0.5, "Testing Set (20%)\nFinal evaluation", cex = 0.9)
dev.off()

print("Images for Unit 4 successfully generated in the 'images/' folder!")