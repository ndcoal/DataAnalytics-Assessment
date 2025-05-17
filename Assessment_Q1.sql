-- Name: Uzoegbu Ndubisi
-- Email: Uzoegbundubisi@gmail.com
-- Phone: +2348131641466 |+2349055445141

-- Select the working database
USE adashi_staging;

-- Preview the relevant tables to understand the data
SELECT * FROM plans_plan LIMIT 10;
SELECT * FROM savings_savingsaccount LIMIT 10;
SELECT * FROM users_customuser LIMIT 10;

-- Q1 Task
-- Identify high-value customers with at least one
-- funded savings plan and one funded investment plan


-- create a temporary table containing users with at least 
-- one funded savings plan
WITH funded_savings AS (
    SELECT DISTINCT p.owner_id, p.id AS plan_id
    FROM plans_plan p
    JOIN savings_savingsaccount s ON s.plan_id = p.id
    WHERE p.is_regular_savings = 1    -- Only regular savings plans
      AND s.confirmed_amount IS NOT NULL
      AND confirmed_amount > 0        -- Must have received funding
),
-- also create a temporary table containing users with at least 
-- one funded investment plan
funded_investments AS (
    SELECT DISTINCT p.owner_id, p.id AS plan_id
    FROM plans_plan p
    JOIN savings_savingsaccount s ON s.plan_id = p.id
    WHERE p.is_a_fund = 1      -- Only investment/fund-type plans
      AND s.confirmed_amount IS NOT NULL
      AND confirmed_amount > 0
),
-- Join the tables to have users with both funded savings AND investment plans
all_funded AS (
    SELECT s.owner_id,
           COUNT(DISTINCT s.plan_id) AS savings_count,
           COUNT(DISTINCT i.plan_id) AS investment_count
    FROM funded_savings s
    JOIN funded_investments i ON s.owner_id = i.owner_id -- maatch users that exist in both sets
    GROUP BY s.owner_id
),
-- Get the total deposits for each user in naira
total_deposits AS (
    SELECT p.owner_id,
           SUM(s.confirmed_amount) / 100 AS total_deposits -- Convert from kobo to naira
    FROM plans_plan p
    JOIN savings_savingsaccount s ON s.plan_id = p.id
    WHERE s.confirmed_amount IS NOT NULL
    GROUP BY p.owner_id
)
-- Then match the tables to have the final output including customer name,
-- savings/investment count and total deposits restreted to active customers
SELECT
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    f.savings_count,
    f.investment_count,
    ROUND(t.total_deposits, 2) AS total_deposits
FROM all_funded f
JOIN users_customuser u ON u.id = f.owner_id
JOIN total_deposits t ON t.owner_id = f.owner_id
WHERE u.is_account_deleted = 0 AND u.is_active = 1   -- Only include active users
ORDER BY total_deposits DESC;             -- Prioritize high-value customers
