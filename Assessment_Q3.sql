-- Name: Uzoegbu Ndubisi
-- Email: Uzoegbundubisi@gmail.com
-- Phone: +2348131641466 | +2349055445141

-- Select the working database
USE adashi_staging;

-- Preview relevant tables
SELECT * FROM savings_savingsaccount LIMIT 10;
SELECT * FROM plans_plan LIMIT 10;
SELECT * FROM withdrawals_withdrawal LIMIT 10;

-- Q3 Task:
-- Find all active accounts (savings or investments) with no transactions 
-- (inflows or withdrawals) in the last 1 year (365 days)

-- Determine last transaction date from inflows
WITH last_inflows AS (
    SELECT
        plan_id,
        MAX(transaction_date) AS inflow_date
    FROM savings_savingsaccount
    WHERE confirmed_amount IS NOT NULL AND confirmed_amount > 0
    GROUP BY plan_id
),
-- Determine last transaction date from withdrawals
last_withdrawals AS (
    SELECT
        plan_id,
        MAX(transaction_date) AS withdrawal_date
    FROM withdrawals_withdrawal
    WHERE amount_withdrawn IS NOT NULL AND amount_withdrawn > 0 -- Only consider completed withdrawals
    GROUP BY plan_id
),
-- Combine inflow and withdrawal dates to get latest transaction date
combined_activity AS (
    SELECT
        i.plan_id,
        i.inflow_date,
        w.withdrawal_date
    FROM last_inflows i
    LEFT JOIN last_withdrawals w ON i.plan_id = w.plan_id
    UNION
    SELECT
        w.plan_id,
        i.inflow_date,
        w.withdrawal_date
    FROM last_withdrawals w
    LEFT JOIN last_inflows i ON i.plan_id = w.plan_id
),

last_activity AS (
    SELECT
        plan_id,
        GREATEST(
            IFNULL(inflow_date, '1900-01-01'),
            IFNULL(withdrawal_date, '1900-01-01')
        ) AS last_transaction_date
    FROM combined_activity
),
-- Filter for active plans that have been inactive for more than 365 days
qualified_plans AS (
    SELECT
        p.id AS plan_id,
        p.owner_id,
        CASE
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_a_fund = 1 THEN 'Investment'
            ELSE NULL
        END AS type,
        la.last_transaction_date,
        DATEDIFF(CURRENT_DATE, la.last_transaction_date) AS inactivity_days
    FROM plans_plan p
    LEFT JOIN last_activity la ON la.plan_id = p.id
    WHERE
        (p.is_regular_savings = 1 OR p.is_a_fund = 1)
        AND p.is_deleted = 0
        AND p.is_archived = 0
        AND la.last_transaction_date IS NOT NULL
        AND DATEDIFF(CURRENT_DATE, la.last_transaction_date) > 365
)
-- Return inactive plans with details
SELECT
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    inactivity_days
FROM qualified_plans
ORDER BY inactivity_days DESC;
