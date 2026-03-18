import pandas as pd
from sklearn import datasets

# 1. Load the full dataset
data = datasets.load_breast_cancer()
df = pd.DataFrame(data.data, columns=data.feature_names)
df['target'] = data.target

# 2. Data Integrity Check (Nulls and Types)
integrity_df = pd.DataFrame({
    'Data Type': df.dtypes,
    'Null Values': df.isnull().sum(),
    'Unique Values': df.nunique()
})

# 3. Full Statistical Description
# We'll include Mean, Std Dev, Min, Max, and the Median (50%)
full_stats = df.describe().T[['mean', 'std', 'min', '50%', 'max']]

# --- PRINTING THE FULL MARKDOWN REPORT ---

print("# Full Machine Learning Dataset Audit: Breast Cancer Wisconsin")
print("\n## 1. Metadata")
print(f"- **Total Observations (n):** {df.shape[0]}")
print(f"- **Total Dimensionality (d):** {df.shape[1] - 1} features + 1 target")
print(f"- **Memory Usage:** {df.memory_usage(deep=True).sum() / 1024:.2f} KB")

print("\n## 2. Feature Integrity & Types")
print(integrity_df.to_markdown())

print("\n## 3. Full Statistical Distribution (All 30 Features)")
print(full_stats.to_markdown())

print("\n## 4. Class Label Mapping")
mapping = pd.DataFrame({
    'Encoded Value': [0, 1],
    'Label': data.target_names,
    'Count': [sum(df['target'] == 0), sum(df['target'] == 1)],
    'Percentage': [f"{(sum(df['target'] == 0)/len(df)*100):.2f}%", 
                   f"{(sum(df['target'] == 1)/len(df)*100):.2f}%"]
})
print(mapping.to_markdown(index=False))