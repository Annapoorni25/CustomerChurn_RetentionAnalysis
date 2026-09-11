# CustomerChurn_RetentionAnalysis

# 📊 Churn Prediction & Retention Analysis

An end-to-end **Customer Churn Prediction and Retention Analysis** project that combines **Python, Statistical Analysis, Machine Learning, SQL, and Power BI** to identify customers at risk of churn, understand the key drivers behind customer attrition, quantify revenue exposure, and translate analytical findings into actionable retention strategies.

---

## 🎯 Business Problem

Customer churn directly impacts recurring revenue and long-term customer value.

The objective of this project is to answer four key business questions:

1. **How significant is customer churn?**
2. **Which customer segments are most likely to churn?**
3. **What factors are associated with customer churn?**
4. **Which customers and segments should the business prioritize for retention?**

The project goes beyond simply predicting churn by connecting machine learning results with **business-oriented retention analysis**.

---

# 🏗️ Project Workflow

```text
Raw Customer Data
       ↓
Data Cleaning & Preparation
       ↓
Exploratory Data Analysis
       ↓
Statistical Analysis
       ↓
Customer Segmentation
       ↓
Machine Learning
       ↓
SQL Business Analysis
       ↓
Power BI Dashboard
       ↓
Retention Insights & Recommendations
```

---

# 🗂️ Dataset

The project uses a telecom/customer subscription dataset containing customer demographics, tenure, services, contract information, payment methods, monthly charges, total charges, and churn status.

### Key Features

| Category             | Features                                                                                                                         |
| -------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| Customer Information | Customer ID, Gender, Senior Citizen, Partner, Dependents                                                                         |
| Tenure               | Tenure                                                                                                                           |
| Services             | Phone Service, Internet Service, Online Security, Online Backup, Device Protection, Tech Support, Streaming TV, Streaming Movies |
| Contract             | Contract Type                                                                                                                    |
| Payment              | Payment Method                                                                                                                   |
| Financial            | Monthly Charges, Total Charges                                                                                                   |
| Target               | Churn                                                                                                                            |

### Dataset Size

* **7,043 customers**
* **19 input features after preprocessing**
* Binary target variable: `Churn`

---

# 🧹 Data Preparation

The data was cleaned and prepared before analysis and modeling.

Key preprocessing steps included:

* Handling missing values
* Converting `TotalCharges` to numeric format
* Validating customer records
* Encoding categorical variables
* Creating meaningful analytical features
* Separating predictor variables from the target variable
* Preparing training and testing datasets

A key data-quality issue identified was missing `TotalCharges` values for customers with zero tenure. These were handled appropriately during preprocessing.

---

# 📈 Exploratory Data Analysis

Exploratory analysis was performed to understand customer behavior and identify potential churn patterns.

The analysis focused on:

* Overall churn distribution
* Customer tenure
* Monthly and total charges
* Contract type
* Payment method
* Internet service
* Customer support and service features
* High-value customer segments
* Revenue associated with churn

### Key observations

* **Month-to-month customers show substantially higher churn** than customers on longer-term contracts.
* **Newer customers are more vulnerable to churn**, making the early customer lifecycle an important retention window.
* Certain service and payment segments show different levels of churn and require targeted investigation.
* High-value churned customers represent an important **revenue-retention opportunity**.

---

# 📊 Statistical Analysis

Statistical testing was used to determine whether observed differences between customer groups were statistically meaningful rather than relying only on visual patterns.

### Techniques Used

* Independent sample testing
* Proportion testing
* Chi-square tests
* Cramér's V
* Mann–Whitney U test
* Segmentation analysis
* Stratified analysis

These analyses helped identify relationships between customer characteristics and churn and provided statistical support for the business insights used later in the project.

---

# 🤖 Machine Learning — Churn Prediction

Multiple machine learning approaches were evaluated to predict customer churn.

### Models Evaluated

* Logistic Regression
* Gradient Boosting

The dataset was divided into training and testing sets, with appropriate preprocessing incorporated into the modeling pipeline.

### Dataset Split

```text
Training: 7,043 × 19 before train/test separation
Testing: 1,409 customers
```

### Model Performance

| Model               | Accuracy |    ROC-AUC |
| ------------------- | -------: | ---------: |
| Logistic Regression |     ~81% | **0.8420** |
| Gradient Boosting   |   ~80.3% | **0.8432** |

Gradient Boosting achieved the highest ROC-AUC among the evaluated models.

### Why ROC-AUC?

Accuracy alone can be misleading in churn prediction because the business is particularly interested in correctly identifying customers who are likely to churn.

ROC-AUC provides a broader measure of how well the model distinguishes between churned and retained customers across different classification thresholds.

---

# 🎯 Churn Risk & Threshold Analysis

The project also explored prediction thresholds rather than relying only on the default 0.50 classification threshold.

A lower threshold of **0.30** was evaluated to identify more potential churners.

This reflects an important business consideration:

> In retention campaigns, missing a customer who is likely to churn may be more costly than contacting some additional customers who ultimately would not churn.

Therefore, the optimal threshold should ultimately depend on the **business cost of false positives versus false negatives**.

---

# 🔎 Model Interpretation

Feature coefficients and model behavior were analyzed to understand which customer characteristics were most strongly associated with churn.

Important patterns included:

* **Two-year contracts** were strongly associated with lower churn risk.
* **Longer customer tenure** was associated with lower churn risk.
* **Fiber optic customers** showed elevated churn risk in the model and require further business investigation.

These findings were not treated as causal relationships. They were interpreted as **associations identified by the model and supporting analysis**.

---

# 🗄️ SQL Business Analysis

SQL Server was used to convert the analytical findings into business-focused metrics.

The SQL analysis included:

* Customer churn counts
* Churn rate
* Revenue associated with churn
* Monthly revenue exposure
* Contract-level churn analysis
* High-value churned customer identification
* Customer tenure analysis
* Revenue segmentation

### Key Business Metrics

From the customer dataset:

* **Total Customers:** 7,043
* **Churned Customers:** 1,869
* **Retained Customers:** 5,174
* **Overall Churn Rate:** ~26.5%

The analysis also quantified the revenue associated with churn and identified high-value customers who could represent meaningful retention opportunities.

---

# 📊 Power BI Dashboard

The final Power BI report transforms the analytical results into a stakeholder-friendly **three-page dashboard**.

## Page 1 — Churn Overview

### Purpose

Provide an executive-level view of the current churn situation.

### Key visuals

* Total Customers
* Churned Customers
* Churn Rate
* Revenue metrics
* Churn distribution
* Churn by contract
* Monthly Charges vs Tenure risk analysis

### Business question answered

> **What is happening with customer churn?**

---

## Page 2 — Churn Drivers & Risk

### Purpose

Identify the customer characteristics and segments associated with higher churn.

### Key analysis

* Churn by tenure
* Churn by contract
* Churn by payment method
* Service-level churn analysis
* Customer risk segmentation

### Business question answered

> **Why are customers churning, and which segments are more vulnerable?**

---

## Page 3 — Retention Strategy

### Purpose

Translate analytical findings into actionable retention priorities.

### Key elements

* Retention priority customers
* Priority customer percentage
* Churn rate by contract
* Churn rate by tenure
* Revenue exposure
* Recommended retention actions

### Business question answered

> **Where should the business focus its retention efforts?**

---

# 🚨 Retention Priority Segmentation

A business-focused retention segment was created to identify customers who deserve additional attention.

A customer is classified as a **Retention Priority** when:

```text
Churn = Yes
AND
Monthly Charges >= 100
AND
Tenure >= 24 months
```

This segment is intentionally different from the machine learning prediction.

### Important distinction

**ML prediction** estimates churn probability.

**Retention Priority** is a business rule used to prioritize customers based on churn status, customer value, and tenure.

This distinction prevents the dashboard from incorrectly presenting a business-defined segment as an ML prediction.

---

# 💡 Key Business Insights

### 1. Month-to-month contracts are a major retention opportunity

Customers on month-to-month contracts exhibit significantly higher churn compared with customers on longer-term contracts.

**Potential action:**

> Encourage migration toward annual or longer-term contracts through targeted incentives and value-based offers.

---

### 2. Early-tenure customers require additional attention

Customers in the early stages of their relationship with the company show higher churn risk.

**Potential action:**

> Strengthen onboarding, early engagement, and proactive support during the first year.

---

### 3. High-value churn represents significant revenue exposure

Customers with higher monthly charges who churn can have a disproportionately large impact on revenue.

**Potential action:**

> Prioritize high-value customers for targeted retention campaigns rather than treating every customer equally.

---

### 4. Customer service and product experience matter

Differences in churn across service-related segments indicate that customer experience should be investigated alongside pricing and contract structure.

**Potential action:**

> Identify customers experiencing service friction and provide proactive support before dissatisfaction results in churn.

---

# 🎯 Recommended Retention Strategy

Based on the combined SQL, statistical, machine learning, and Power BI analysis:

### Priority 1 — Protect new customers

Improve onboarding and engagement during the early customer lifecycle.

### Priority 2 — Convert month-to-month customers

Provide incentives that encourage customers to move toward longer-term contracts.

### Priority 3 — Protect high-value customers

Use customer value and churn risk together to prioritize retention campaigns.

### Priority 4 — Improve customer experience

Investigate service and support factors associated with higher churn and address recurring customer pain points.

---

# 🛠️ Tools & Technologies

| Area             | Tools                        |
| ---------------- | ---------------------------- |
| Programming      | Python                       |
| Data Analysis    | Pandas, NumPy                |
| Statistics       | SciPy                        |
| Machine Learning | Scikit-learn                 |
| Database         | Microsoft SQL Server         |
| SQL Analysis     | SQL Server Management Studio |
| Visualization    | Power BI                     |
| Development      | Jupyter Notebook / VS Code   |
| Version Control  | Git & GitHub                 |

---

# 📁 Project Structure

```text
CustomerChurn_RetentionAnalysis/
│
├── data/
│   └── customer_churn.csv
│
├── notebooks/
│   ├── 01_Data_Cleaning_EDA.ipynb
│   ├── 02_Statistical_Analysis.ipynb
│   └── 03_Churn_Prediction.ipynb
│
├── sql/
│   └── churn_analysis.sql
│
├── powerbi/
│   └── Churn_Retention_Analysis.pbix
│
├── reports/
│   └── dashboard_screenshots/
│
├── requirements.txt
└── README.md
```

---

# 🚀 How to Run the Project

### 1. Clone the repository

```bash
git clone <your-repository-url>
cd CustomerChurn_RetentionAnalysis
```

### 2. Install Python dependencies

```bash
pip install -r requirements.txt
```

### 3. Run the notebooks

Open the notebooks using Jupyter Notebook or VS Code and execute them in order:

```text
01_Data_Cleaning_EDA
        ↓
02_Statistical_Analysis
        ↓
03_Churn_Prediction
```

### 4. SQL Analysis

Import the cleaned customer dataset into SQL Server and execute the SQL scripts in the `sql/` directory.

### 5. Power BI

Open the `.pbix` file and refresh the data sources if required.

---

# 📌 Project Outcome

This project demonstrates an end-to-end analytical workflow:

```text
Data
 ↓
Cleaning
 ↓
Exploration
 ↓
Statistical Validation
 ↓
Machine Learning
 ↓
SQL Business Analysis
 ↓
Power BI
 ↓
Business Recommendations
```

Rather than stopping at a churn prediction model, the project connects **customer behavior, statistical evidence, predictive modeling, revenue impact, and retention strategy** to support business decision-making.

---

# 👩‍💻 Skills Demonstrated

* Data Cleaning & Transformation
* Exploratory Data Analysis
* Statistical Hypothesis Testing
* Customer Segmentation
* Feature Engineering
* Classification Modeling
* Model Evaluation
* Threshold Optimization
* SQL Business Analysis
* Data Visualization
* Power BI Dashboard Development
* Business Insight Generation
* Retention Strategy
* Stakeholder Communication

---

## 👤 Author

**Annapoorni Muthukumar**

Computer Science Engineering | Data Analytics & AI/ML

Interested in building data-driven solutions that connect **analytics, business problems, and actionable insights**.

---

⭐ If you found this project useful, feel free to explore the notebooks, SQL analysis, and Power BI dashboard included in the repository.
