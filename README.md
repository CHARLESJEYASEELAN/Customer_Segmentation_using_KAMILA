# 🧩 Customer Segmentation using KAMILA and K-Prototypes

This project focuses on performing customer segmentation in a financial context using clustering algorithms that can handle **mixed data types (categorical + numerical)** — specifically **KAMILA** and **K-Prototypes**. The objective is to identify distinct customer groups based on their financial and demographic attributes, aiding in better credit risk assessment and marketing strategies.

---

![Feature_Eng_Map.jpeg](Feature Engineering Map)

## 📊 Dataset Overview

The dataset includes customer-level data with the following feature types:

- **Continuous Features**: Limit Balance, Age, Average Bill Amount, Average Previous Payment
- **Categorical Features**: Gender, Education, Marital Status
- **Engineered Features**:
  - AVERAGE History of Past Payment
  - AVERAGE Amount of Bill Statement
  - AVERAGE Amount of Previous Payment

---

## ⚙️ Feature Engineering Highlights

Feature engineering was performed to convert raw time-series variables into meaningful single-value indicators by averaging:

- Reduced dimensionality and improved interpretability
- Captured long-term behavior of customers
- Removed noise and outliers
- Ensured compatibility with clustering algorithms

---

## 🔍 Algorithms Used

### 1. **KAMILA (KAy-means for MIxed LArge data)**
- Designed specifically for mixed-type data.
- Uses likelihood-based clustering (Gaussian for continuous, Multinomial for categorical).
- Achieved a **Silhouette Score of 0.54**, indicating strong separation.

### 2. **K-Prototypes**
- Extension of K-Means to handle mixed data.
- Combines Euclidean distance (for numerical) and category matching (for categorical).
- λ parameter used to balance numerical and categorical contributions.

---

## 🎯 Business Objective

The aim was to segment customers into meaningful groups such as:
- **Low-risk vs. High-risk**
- **Profitable vs. Less profitable**

This directly supports:
- Credit approval decisions
- Personalized marketing strategies
- Targeted risk control policies

---

## 📈 Results

| Algorithm     | Silhouette Score | Clusters Identified |
|---------------|------------------|---------------------|
| KAMILA        | 0.54             | 2                   |
| K-Prototypes  | N/A (used entropy for categorical) | 2 |

- Both models produced two highly distinguishable customer segments.
- **K = 2** was chosen based on observed business needs and interpretable clustering patterns.

---

## 🧠 Evaluation Metrics

- **Silhouette Score**: Evaluates clustering quality for continuous data.
- **Entropy Score**: Measures homogeneity for categorical features within clusters.

---

## 🚧 Challenges Faced

- Balancing clustering quality for both categorical and continuous attributes.
- Handling cluster imbalance (some clusters were much smaller).
- Interpreting clusters in a business-relevant way.
- Choosing appropriate evaluation metrics for mixed-type clustering.

---

## 📚 Tools & Technologies

- Python 3.x
- `kmodes` for K-Prototypes
- `kamila` (R or Python-based implementation)
- Pandas, NumPy, Scikit-learn, Matplotlib, Seaborn
- KNIME - Feature Engineering.

---

## 📌 Key Takeaways

- Mixed-type clustering provides **more realistic segmentation** in domains like banking.
- Feature engineering plays a **critical role** in transforming time-series attributes into actionable insights.
- KAMILA and K-Prototypes serve as **strong alternatives** to traditional clustering methods when working with categorical + numerical features.


