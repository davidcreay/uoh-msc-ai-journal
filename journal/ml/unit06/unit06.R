# Create the "images" directory if it doesn't already exist
dir.create("images", showWarnings = FALSE)

# ---------------------------------------------------------
# 13. Gaussian Process Concept (Prediction with Uncertainty)
# ---------------------------------------------------------
png("images/13_gaussian_process.png", width = 700, height = 400)
set.seed(42)
x_val <- seq(-5, 5, length.out = 100)
y_mean <- sin(x_val)
# Simulate increasing uncertainty away from a "known" central point
uncertainty <- 0.1 + 0.1 * (x_val^2) 

plot(x_val, y_mean, type = "n", ylim = c(-3, 3), 
     main = "Gaussian Process: Prediction & Uncertainty",
     xlab = "Input Feature", ylab = "Predicted Value")

# Draw the confidence interval (uncertainty)
polygon(c(x_val, rev(x_val)), 
        c(y_mean + uncertainty, rev(y_mean - uncertainty)), 
        col = rgb(0.6, 0.8, 1, 0.5), border = NA)

# Draw the mean prediction line
lines(x_val, y_mean, col = "blue", lwd = 2)

# Draw "observed" data points with zero uncertainty
points(c(-2, 0, 2), sin(c(-2, 0, 2)), pch = 16, col = "black", cex = 1.5)
legend("topleft", legend = c("Mean Prediction", "Uncertainty (95% CI)", "Observed Data"),
       col = c("blue", rgb(0.6, 0.8, 1, 0.5), "black"), 
       lwd = c(2, 10, NA), pch = c(NA, NA, 16))
dev.off()

# ---------------------------------------------------------
# 14. Confusion Matrix (Precision/Recall visual)
# ---------------------------------------------------------
png("images/14_confusion_matrix.png", width = 500, height = 500)
plot(c(0, 2), c(0, 2), type = "n", axes = FALSE, xlab = "Predicted Class", ylab = "Actual Class",
     main = "Confusion Matrix Layout")
axis(1, at = c(0.5, 1.5), labels = c("Predicted Positive", "Predicted Negative"), tick = FALSE)
axis(2, at = c(1.5, 0.5), labels = c("Actual Positive", "Actual Negative"), tick = FALSE, las = 0)

# Draw matrix boxes
rect(0, 1, 1, 2, col = "lightgreen", border = "black")
rect(1, 1, 2, 2, col = "salmon", border = "black")
rect(0, 0, 1, 1, col = "salmon", border = "black")
rect(1, 0, 2, 2, col = "lightgray", border = "black") # Fixed coordinate overlap visually
rect(1, 0, 2, 1, col = "lightgreen", border = "black")

# Add text
text(0.5, 1.5, "True Positive (TP)", font = 2, cex = 1.2)
text(1.5, 1.5, "False Negative (FN)", font = 2, cex = 1.2)
text(0.5, 0.5, "False Positive (FP)", font = 2, cex = 1.2)
text(1.5, 0.5, "True Negative (TN)", font = 2, cex = 1.2)
dev.off()

# ---------------------------------------------------------
# 15. ROC Curve
# ---------------------------------------------------------
png("images/15_roc_curve.png", width = 500, height = 500)
# Simulate ROC curve coordinates
fpr <- seq(0, 1, length.out = 100)
tpr <- 1 - (1 - fpr)^3 # Create a nice bowing curve

plot(fpr, tpr, type = "l", col = "blue", lwd = 3,
     xlab = "False Positive Rate (1 - Specificity)", 
     ylab = "True Positive Rate (Sensitivity / Recall)",
     main = "ROC Curve")

# Shade the Area Under the Curve (AUC)
polygon(c(fpr, 1, 0), c(tpr, 0, 0), col = rgb(0.2, 0.5, 1, 0.2), border = NA)

# Draw the random guess line
abline(a = 0, b = 1, col = "red", lty = 2, lwd = 2)
text(0.6, 0.4, "Random Guessing", col = "red", srt = 45)
text(0.3, 0.8, "Area Under Curve\n(AUC)", col = "darkblue", font = 2)
dev.off()

# ---------------------------------------------------------
# 16. One-Hot Encoding Visual
# ---------------------------------------------------------
png("images/16_one_hot_encoding.png", width = 700, height = 300)
plot(c(0, 10), c(0, 5), type = "n", axes = FALSE, xlab = "", ylab = "", 
     main = "Concept of One-Hot Encoding")

# Before text
text(2, 4, "Original Feature", font = 2)
text(2, 3, "Color: Red")
text(2, 2, "Color: Green")
text(2, 1, "Color: Blue")

# Arrow
arrows(4, 2.5, 6, 2.5, lwd = 3, col = "black")

# After text
text(8, 4, "One-Hot Encoded Features", font = 2)
text(8, 3, "[1, 0, 0]  (Red, Green, Blue)")
text(8, 2, "[0, 1, 0]  (Red, Green, Blue)")
text(8, 1, "[0, 0, 1]  (Red, Green, Blue)")
dev.off()

print("Images for Unit 6 successfully generated in the 'images/' folder!")