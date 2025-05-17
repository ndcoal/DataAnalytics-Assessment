-- Name: Uzoegbu Ndubisi
-- Email: Uzoegbundubisi@gmail.com
-- Phone: +2348131641466 |+2349055445141

-- Select the working database
USE adashi_staging;

-- Preview the relevant tables to understand the data
SELECT * FROM savings_savingsaccount LIMIT 10;
SELECT * FROM users_customuser LIMIT 10;

-- Q2. Task
-- Calculate the average number of transactions per customer per 
-- month and categorize them

-- Make a temporary table to calculate total number of inflow 
-- transactions and account tenure in months
WITH inflow_transactions AS (
    SELECT
        s.owner_id,
        COUNT(*) AS total_transactions,  -- Total number of inflow transactions per user
        DATEDIFF(MAX(s.created_on), MIN(s.created_on)) / 30.0 AS tenure_months  -- Approximate tenure
    FROM savings_savingsaccount s
    JOIN users_customuser u ON u.id = s.owner_id
    WHERE s.confirmed_amount IS NOT NULL           -- Only count confirmed inflows
      AND u.is_account_deleted = 0                 -- Include only non-deleted accounts
      AND u.is_active = 1                          -- Include only active users
    GROUP BY s.owner_id
),
-- Then use the above table to calculate average number of transactions per month
user_avg_txn AS (
    SELECT
        owner_id,
        total_transactions,
        ROUND(total_transactions / CASE WHEN tenure_months < 1 THEN 1 ELSE tenure_months END, 2) AS avg_txns_per_month
        -- In other to avoid division by zero for recent users i approximate the zeros to 1
    FROM inflow_transactions
),
-- Categorize users based on average monthly transaction frequency
categorized AS (
    SELECT
        CASE
            WHEN avg_txns_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txns_per_month BETWEEN 3 AND 9.99 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_txns_per_month
    FROM user_avg_txn
)
-- Final compute count of customers and average transactions per month by category
SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txns_per_month), 1) AS avg_transactions_per_month
FROM categorized
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');  -- Re-order
