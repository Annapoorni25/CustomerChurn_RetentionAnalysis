CREATE TABLE Customers (
    customerID VARCHAR(50),
    gender VARCHAR(20),
    SeniorCitizen INT,
    Partner VARCHAR(10),
    Dependents VARCHAR(10),
    tenure INT,
    PhoneService VARCHAR(10),
    MultipleLines VARCHAR(100),
    InternetService VARCHAR(30),
    OnlineSecurity VARCHAR(100),
    OnlineBackup VARCHAR(100),
    DeviceProtection VARCHAR(100),
    TechSupport VARCHAR(100),
    StreamingTV VARCHAR(100),
    StreamingMovies VARCHAR(100),
    Contract VARCHAR(30),
    PaperlessBilling VARCHAR(10),
    PaymentMethod VARCHAR(50),
    MonthlyCharges DECIMAL(10,2),
    TotalCharges DECIMAL(10,2),
    Churn VARCHAR(10)
);

SELECT * FROM Customers

BULK INSERT customers
FROM 'C:\Users\haree\Downloads\CustomerChurn_RetentionAnalysis\WA_Fn-UseC_-Telco-Customer-Churn.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    TABLOCK
);

--duplicate customers
SELECT
    customerID,
    COUNT(*) AS RecordCount
FROM customers
GROUP BY customerID
HAVING COUNT(*) > 1;

--Null values
SELECT
    COUNT(*) AS TotalRows,
    SUM(CASE WHEN customerID IS NULL THEN 1 ELSE 0 END) AS NullCustomerID,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS NullGender,
    SUM(CASE WHEN tenure IS NULL THEN 1 ELSE 0 END) AS NullTenure,
    SUM(CASE WHEN MonthlyCharges IS NULL THEN 1 ELSE 0 END) AS NullMonthlyCharges,
    SUM(CASE WHEN TotalCharges IS NULL THEN 1 ELSE 0 END) AS NullTotalCharges,
    SUM(CASE WHEN Churn IS NULL THEN 1 ELSE 0 END) AS NullChurn
FROM customers;

--numeric values
SELECT
    MIN(tenure) AS MinTenure,
    MAX(tenure) AS MaxTenure,
    MIN(MonthlyCharges) AS MinMonthlyCharges,
    MAX(MonthlyCharges) AS MaxMonthlyCharges
FROM customers;

--target variable
SELECT
    Churn,
    COUNT(*) AS CustomerCount
FROM customers
GROUP BY Churn;

--Which customers have missing total charges, and what do their records look like?
SELECT
    customerID,
    tenure,
    MonthlyCharges,
    TotalCharges,
    Contract,
    Churn
FROM customers
WHERE TotalCharges IS NULL
   OR LTRIM(RTRIM(TotalCharges)) = '';

--new data table
SELECT *
INTO customer_analysis
FROM customers;

--fix totalchargescolumn
UPDATE customer_analysis
SET TotalCharges = '0'
WHERE TotalCharges IS NULL
   OR LTRIM(RTRIM(TotalCharges)) = '';

--convert totalcharges to numeric
ALTER TABLE customer_analysis
ALTER COLUMN TotalCharges DECIMAL(10,2);

--verify
SELECT
    COUNT(*) AS TotalRows,
    SUM(CASE WHEN TotalCharges IS NULL THEN 1 ELSE 0 END) AS NullTotalCharges
FROM customer_analysis;


SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'customer_analysis'
  AND COLUMN_NAME = 'TotalCharges';




--How much monthly revenue is currently exposed to churn?
SELECT
    SUM(MonthlyCharges) AS MonthlyRevenueFromChurnedCustomers
FROM customer_analysis
WHERE Churn = 'Yes';


--what portion of the total monthly revenue this represents
SELECT
    SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END) AS ChurnedRevenue,
    SUM(MonthlyCharges) AS TotalMonthlyRevenue,
    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END)
        * 100.0 / SUM(MonthlyCharges),
        2
    ) AS RevenueExposurePercentage
FROM customer_analysis;


--Which contract type is responsible for the largest amount of lost monthly recurring revenue?
SELECT
    Contract,
    COUNT(*) AS ChurnedCustomers,
    SUM(MonthlyCharges) AS ChurnedMonthlyRevenue
FROM customer_analysis
WHERE Churn = 'Yes'
GROUP BY Contract
ORDER BY ChurnedMonthlyRevenue DESC;



--Who are the highest-value customers we've already lost?
SELECT TOP 10
    customerID,
    Contract,
    tenure,
    MonthlyCharges,
    TotalCharges,
    InternetService,
    Churn
FROM customer_analysis
WHERE Churn = 'Yes'
ORDER BY MonthlyCharges DESC;



--How much monthly revenue is exposed among high-value churned customers?
SELECT
    COUNT(*) AS HighValueChurnedCustomers,
    SUM(MonthlyCharges) AS HighValueChurnedRevenue
FROM customer_analysis
WHERE Churn = 'Yes'
  AND MonthlyCharges >= 100;



--Which churned customers should be considered the highest-priority retention targets based 
--on both revenue value and customer tenure?
WITH PriorityCustomers AS
(
    SELECT
        customerID,
        Contract,
        tenure,
        MonthlyCharges,
        TotalCharges,
        InternetService,
        Churn
    FROM customer_analysis
    WHERE Churn = 'Yes'
      AND MonthlyCharges >= 100
      AND tenure >= 24
)

SELECT *
FROM PriorityCustomers
ORDER BY MonthlyCharges DESC;



--How many priority customers are there, and how much monthly revenue did this segment represent before they churned?
WITH PriorityCustomers AS
(
    SELECT
        customerID,
        MonthlyCharges,
        tenure
    FROM customer_analysis
    WHERE Churn = 'Yes'
      AND MonthlyCharges >= 100
      AND tenure >= 24
)

SELECT
    COUNT(*) AS PriorityCustomers,
    SUM(MonthlyCharges) AS MonthlyRevenueAtRisk,
    AVG(MonthlyCharges) AS AverageMonthlyCharge,
    AVG(tenure) AS AverageTenure
FROM PriorityCustomers;




--Rank churned customers by revenue value
SELECT
    customerID,
    Contract,
    tenure,
    MonthlyCharges,
    TotalCharges,
    RANK() OVER (
        ORDER BY MonthlyCharges DESC
    ) AS RevenueRank
FROM customer_analysis
WHERE Churn = 'Yes'
ORDER BY RevenueRank;


SELECT
    customerID,
    MonthlyCharges,

    RANK() OVER (
        ORDER BY MonthlyCharges DESC
    ) AS RankValue,

    DENSE_RANK() OVER (
        ORDER BY MonthlyCharges DESC
    ) AS DenseRankValue,

    ROW_NUMBER() OVER (
        ORDER BY MonthlyCharges DESC
    ) AS RowNumberValue

FROM customer_analysis
WHERE Churn = 'Yes'
ORDER BY MonthlyCharges DESC;



WITH RankedCustomers AS
(
    SELECT
        customerID,
        Contract,
        tenure,
        MonthlyCharges,
        TotalCharges,
        InternetService,
        ROW_NUMBER() OVER (
            ORDER BY MonthlyCharges DESC
        ) AS RevenueRank
    FROM customer_analysis
    WHERE Churn = 'Yes'
)

SELECT
    customerID,
    Contract,
    tenure,
    MonthlyCharges,
    TotalCharges,
    InternetService,
    RevenueRank
FROM RankedCustomers
WHERE RevenueRank <= 10
ORDER BY RevenueRank;