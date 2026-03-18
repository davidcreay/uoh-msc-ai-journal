import pandas as pd
from sklearn import datasets

# 1. Load the raw data
raw_data = datasets.load_breast_cancer()

# 2. Convert to a Pandas DataFrame for better formatting
df = pd.DataFrame(raw_data.data, columns=raw_data.feature_names)
df['target'] = raw_data.target

# --- KEY INSPECTION COMMANDS ---

print("--- 1. SHAPE (Size of the Dataset) ---")
print(f"Rows: {df.shape[0]}, Columns: {df.shape[1]}")
print("\n")

print("--- 2. INFO (Data Types and Missing Values) ---")
print(df.info()) 
print("\n")

print("--- 3. HEAD (First 5 Rows) ---")
print(df.head())
print("\n")

print("--- 4. STATISTICAL SUMMARY ---")
# This shows mean, standard deviation, min, max, and quartiles
print(df.describe().T) # .T transposes it for easier reading of 30 features
print("\n")

print("--- 5. CLASS BALANCE ---")
# Critical for SVM: Are there roughly equal numbers of Malignant vs Benign?
class_counts = df['target'].value_counts()
print(f"Benign (1): {class_counts[1]}")
print(f"Malignant (0): {class_counts[0]}")