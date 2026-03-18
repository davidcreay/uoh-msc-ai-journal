from sklearn.svm import SVC
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report, confusion_matrix, accuracy_score
import pandas as pd

# 1. Prepare the Data
# X_pca is the 2-component data we created earlier
# y is the target (Malignant/Benign)
X_train, X_test, y_train, y_test = train_test_split(X_pca, y, test_size=0.3, random_state=42)

# 2. Define and Train the SVM
# We use the RBF (Radial Basis Function) kernel because our PCA plot 
# showed some non-linear overlap between the classes.
svm_model = SVC(kernel='rbf', C=1.0, gamma='scale')
svm_model.fit(X_train, y_train)

# 3. Make Predictions
y_pred = svm_model.predict(X_test)

# 4. Professional Markdown Output
print("## SVM Classification Performance")
print(f"- **Overall Accuracy:** {accuracy_score(y_test, y_pred):.2%}")

# Convert the classification report to a DataFrame for Markdown printing
report = classification_report(y_test, y_pred, target_names=data.target_names, output_dict=True)
report_df = pd.DataFrame(report).transpose()

print("\n### Detailed Classification Report")
print(report_df.to_markdown())

print("\n### Confusion Matrix")
cm = confusion_matrix(y_test, y_pred)
cm_df = pd.DataFrame(cm, index=['Actual Malignant', 'Actual Benign'], 
                     columns=['Predicted Malignant', 'Predicted Benign'])
print(cm_df.to_markdown())