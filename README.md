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

**Assumptions:**  
- Confirmed savings (`confirmed_amount > 0`) indicates funding.
- All monetary values are in kobo.
- Customers must be active (i.e., not deleted).

---

### Assessment_Q2.sql - Transaction Frequency Analysis


---

**Author:**  
Uzoegbu Ndubisi
Uzoegbundubisi@gmail.com
+2348131641466 |+2349055445141
