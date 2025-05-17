# DataAnalytics-Assessment
This repositorty is for SQL assessment for Data Analytics Job role at Cowrywise. It contains optimized SQL solutions for analyzing customer behavior, transaction frequency, account activity, and customer lifetime value using relational database queries across multiple interconnected tables.

---

## Repository Structure

```
DataAnalytics-Assessment/
│
├── Assessment_Q1.sql
├── Assessment_Q2.sql
├── Assessment_Q3.sql
├── Assessment_Q4.sql
│
└── README.md
```

---

## Question Explanations

---

### Assessment_Q1.sql - High-Value Customers with Multiple Products

**Goal:**  
Identify customers who have both a funded **savings plan** (`is_regular_savings = 1`) and a funded **investment plan** (`is_a_fund = 1`), and rank them by total deposits.

**Approach:** 

- An initial table was created to identify funded savings plans by joining plans_plan and savings_savingsaccount, filtering for regular savings (is_regular_savings = 1) with confirmed amounts greater than zero.
- Then, a second table was created for funded investment plans (is_a_fund = 1) with similar conditions.
- Next, both tables were joined on owner_id to find users with at least one of each plan type.
- A separate table summed all confirmed deposits for each user (converted from kobo to naira).
- Finally, active users (is_account_deleted = 0) were selected, and results were ordered by total deposits.

---

### Assessment_Q2.sql - Transaction Frequency Analysis

**Goal:**  
Segment customers based on how frequently they transact per month.

**Approach:**  
- An initial table was created from savings_savingsaccount to count the total number of transactions per user by grouping on owner_id.
- Then, the number of months each user had been transacting was estimated using the difference between the earliest and latest transaction dates.
- The average number of transactions per month was calculated by dividing total transactions by active months.
- Each user was then categorized as:
  - High Frequency (≥ 10/month)
  - Medium Frequency (3–9/month)
  - Low Frequency (≤ 2/month)
- Finally, the number of users and average transactions per month were aggregated per category.

---

### Assessment_Q3.sql - Account Inactivity Alert

**Goal:**  
Identify active savings or investment plans with no deposits in the last 365 days.

**Approach:**  
- An initial table was created by joining plans_plan and savings_savingsaccount to get the latest transaction date for each plan.
- Then, the number of days since the last transaction was calculated using the current date.
- Plans with no transactions in the last 365 days were filtered.
- Each plan was labeled as either "Savings" (is_regular_savings = 1) or "Investment" (is_a_fund = 1).
- Only active plans belonging to active users were included in the final result.

---

### Assessment_Q4.sql - Customer Lifetime Value (CLV) Estimation

**Goal:**  
Estimate each customer's CLV based on transaction volume and tenure.

**Approach:**  
- An initial table was created by joining `users_customuser` with `savings_savingsaccount` to aggregate transaction data by user.  
- Account tenure was calculated as the number of months since the user's `date_joined`.  
- Total transactions were summed using `confirmed_amount`.  
- Profit per transaction was set at 0.1%, and CLV was estimated using the formula:  
**CLV = (total_transactions / tenure) * 12 * average_profit_per_transaction**.  
- Results were ordered by estimated CLV in descending order to highlight the most valuable customers.

---

### Challenges

One of the main challenges was ensuring accuracy in filtering only active, valid transactions, particularly distinguishing confirmed deposits and valid user accounts, requiring me to creat multiple temporary table before joining them. Handling cases like users with zero-month tenure or missing transaction dates also required attention to avoid division errors or misleading calculations. However, overall, the process went smoothly, and writing the queries was relatively easy given the helpful hints provided regarding confirmed_amount, amount_withdrawn, savings_plan, and investment_plan.

---

### Summary

This assessment showcased my ability to reason through business logic, translate it into SQL queries, and ensure performance and correctness. Each SQL file is structured, readable, and commented where needed. With this, i look forward to be part of the selected individual to to contribute to Cowrywise.

Thank you.

---

**Author:**  
Uzoegbu Ndubisi
Uzoegbundubisi@gmail.com
+2348131641466 |+2349055445141
