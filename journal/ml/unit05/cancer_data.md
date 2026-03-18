# Full Machine Learning Dataset Audit: Breast Cancer Wisconsin

## 1. Metadata
- **Total Observations (n):** 569
- **Total Dimensionality (d):** 30 features + 1 target
- **Memory Usage:** 137.93 KB

## 2. Feature Integrity & Types
|                         | Data Type   |   Null Values |   Unique Values |
|:------------------------|:------------|--------------:|----------------:|
| mean radius             | float64     |             0 |             456 |
| mean texture            | float64     |             0 |             479 |
| mean perimeter          | float64     |             0 |             522 |
| mean area               | float64     |             0 |             539 |
| mean smoothness         | float64     |             0 |             474 |
| mean compactness        | float64     |             0 |             537 |
| mean concavity          | float64     |             0 |             537 |
| mean concave points     | float64     |             0 |             542 |
| mean symmetry           | float64     |             0 |             432 |
| mean fractal dimension  | float64     |             0 |             499 |
| radius error            | float64     |             0 |             540 |
| texture error           | float64     |             0 |             519 |
| perimeter error         | float64     |             0 |             533 |
| area error              | float64     |             0 |             528 |
| smoothness error        | float64     |             0 |             547 |
| compactness error       | float64     |             0 |             541 |
| concavity error         | float64     |             0 |             533 |
| concave points error    | float64     |             0 |             507 |
| symmetry error          | float64     |             0 |             498 |
| fractal dimension error | float64     |             0 |             545 |
| worst radius            | float64     |             0 |             457 |
| worst texture           | float64     |             0 |             511 |
| worst perimeter         | float64     |             0 |             514 |
| worst area              | float64     |             0 |             544 |
| worst smoothness        | float64     |             0 |             411 |
| worst compactness       | float64     |             0 |             529 |
| worst concavity         | float64     |             0 |             539 |
| worst concave points    | float64     |             0 |             492 |
| worst symmetry          | float64     |             0 |             500 |
| worst fractal dimension | float64     |             0 |             535 |
| target                  | int64       |             0 |               2 |

## 3. Full Statistical Distribution (All 30 Features)
|                         |         mean |          std |         min |        50% |        max |
|:------------------------|-------------:|-------------:|------------:|-----------:|-----------:|
| mean radius             |  14.1273     |   3.52405    |   6.981     |  13.37     |   28.11    |
| mean texture            |  19.2896     |   4.30104    |   9.71      |  18.84     |   39.28    |
| mean perimeter          |  91.969      |  24.299      |  43.79      |  86.24     |  188.5     |
| mean area               | 654.889      | 351.914      | 143.5       | 551.1      | 2501       |
| mean smoothness         |   0.0963603  |   0.0140641  |   0.05263   |   0.09587  |    0.1634  |
| mean compactness        |   0.104341   |   0.0528128  |   0.01938   |   0.09263  |    0.3454  |
| mean concavity          |   0.0887993  |   0.0797198  |   0         |   0.06154  |    0.4268  |
| mean concave points     |   0.0489191  |   0.0388028  |   0         |   0.0335   |    0.2012  |
| mean symmetry           |   0.181162   |   0.0274143  |   0.106     |   0.1792   |    0.304   |
| mean fractal dimension  |   0.0627976  |   0.00706036 |   0.04996   |   0.06154  |    0.09744 |
| radius error            |   0.405172   |   0.277313   |   0.1115    |   0.3242   |    2.873   |
| texture error           |   1.21685    |   0.551648   |   0.3602    |   1.108    |    4.885   |
| perimeter error         |   2.86606    |   2.02185    |   0.757     |   2.287    |   21.98    |
| area error              |  40.3371     |  45.491      |   6.802     |  24.53     |  542.2     |
| smoothness error        |   0.00704098 |   0.00300252 |   0.001713  |   0.00638  |    0.03113 |
| compactness error       |   0.0254781  |   0.0179082  |   0.002252  |   0.02045  |    0.1354  |
| concavity error         |   0.0318937  |   0.0301861  |   0         |   0.02589  |    0.396   |
| concave points error    |   0.0117961  |   0.00617029 |   0         |   0.01093  |    0.05279 |
| symmetry error          |   0.0205423  |   0.00826637 |   0.007882  |   0.01873  |    0.07895 |
| fractal dimension error |   0.0037949  |   0.00264607 |   0.0008948 |   0.003187 |    0.02984 |
| worst radius            |  16.2692     |   4.83324    |   7.93      |  14.97     |   36.04    |
| worst texture           |  25.6772     |   6.14626    |  12.02      |  25.41     |   49.54    |
| worst perimeter         | 107.261      |  33.6025     |  50.41      |  97.66     |  251.2     |
| worst area              | 880.583      | 569.357      | 185.2       | 686.5      | 4254       |
| worst smoothness        |   0.132369   |   0.0228324  |   0.07117   |   0.1313   |    0.2226  |
| worst compactness       |   0.254265   |   0.157336   |   0.02729   |   0.2119   |    1.058   |
| worst concavity         |   0.272188   |   0.208624   |   0         |   0.2267   |    1.252   |
| worst concave points    |   0.114606   |   0.0657323  |   0         |   0.09993  |    0.291   |
| worst symmetry          |   0.290076   |   0.0618675  |   0.1565    |   0.2822   |    0.6638  |
| worst fractal dimension |   0.0839458  |   0.0180613  |   0.05504   |   0.08004  |    0.2075  |
| target                  |   0.627417   |   0.483918   |   0         |   1        |    1       |

## 4. Class Label Mapping
|   Encoded Value | Label     |   Count | Percentage   |
|----------------:|:----------|--------:|:-------------|
|               0 | malignant |     212 | 37.26%       |
|               1 | benign    |     357 | 62.74%       |
