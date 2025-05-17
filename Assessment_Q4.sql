-- Name: Uzoegbu Ndubisi
-- Email: Uzoegbundubisi@gmail.com
-- Phone: +2348131641466 | +2349055445141

-- Select the working database
USE adashi_staging;

-- Q4. For each customer, assuming the profit_per_transaction
-- is 0.1% of the transaction value, calculate 

SELECT 
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    -- Tenure in months since signup
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
    -- Total number of confirmed deposit transactions
    COUNT(s.id) AS total_transactions,
    -- CLV = (total_txns / tenure) * 12 * (0.001 * avg_txn_value)
    ROUND( 
        (COUNT(s.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 0)) 
        * 12 
        * (0.001 * ((SUM(s.confirmed_amount)/100) / NULLIF(COUNT(s.id), 0))) -- average profit/ transaction in Naira
        , 2
    ) AS estimated_clv
FROM 
    users_customuser u
-- Join to savings table: include only confirmed deposits
LEFT JOIN savings_savingsaccount s 
    ON u.id = s.owner_id AND s.confirmed_amount > 0
WHERE u.is_account_deleted = 0
GROUP BY u.id, u.name, u.date_joined
ORDER BY estimated_clv DESC; -- Sort customers from highest to lowest estimated CLV


