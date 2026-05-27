-- ============================================================
-- Day 01 | Phase 1 – Foundation | SELECT, WHERE & Filtering
-- Database: phase1_analyst
-- Difficulty: Beginner
-- Topics: SELECT, WHERE, AND, OR, BETWEEN, Comparison Operators
-- ============================================================

USE phase1_analyst;

-- ============================================================
-- Case Study 1: Find All Completed High-Value Order
-- ============================================================
-- Business context: The e-commerce team wants to identify all
-- completed orders above ₹10,000 to shortlist customers for
-- a premium loyalty rewards program.
-- Table: fact_orders JOIN dim_customer

SELECT
    o.order_id,
    c.first_name,
    c.last_name,
    c.customer_type,
    o.total_amount,
    o.payment_method,
    o.status
FROM fact_orders o
JOIN dim_customer c ON o.customer_id = c.customer_id
WHERE o.total_amount > 10000
  AND o.status = 'completed'
ORDER BY o.total_amount DESC;

-- Insight: These are your premium buyers. Filtering only
-- 'completed' orders removes cancelled/refunded noise from
-- the loyalty list — always clean your data before decisions.

-- ────────────────────────────────────────────────────────────
-- Case Study 2: Find Active Employees in Engineering Dept
-- ────────────────────────────────────────────────────────────
-- Business context: HR is conducting a performance review for
-- all active Engineering employees. They need a list with
-- names, job titles, salaries, and hire dates.
-- Table: dim_employee JOIN dim_location

SELECT
    e.emp_id,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    e.job_title,
    e.salary,
    e.hire_date,
    l.city
FROM dim_employee e
JOIN dim_location l ON e.location_id = l.location_id
WHERE e.department = 'Engineering'
  AND e.status = 'active'
ORDER BY e.hire_date ASC;

-- Insight: Sorting by hire_date ASC puts the most senior
-- engineers first — useful for seniority-based appraisals.
-- CONCAT creates a clean full_name column for reporting.

-- ────────────────────────────────────────────────────────────
-- Case Study 3: Food Orders Between ₹300 and ₹1000
-- ────────────────────────────────────────────────────────────
-- Business context: The marketing team wants to find all
-- delivered food orders between ₹300–₹1000 to target
-- mid-range customers with a cashback coupon campaign.
-- Table: fact_deliveries JOIN dim_customer

SELECT
    d.delivery_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    d.order_amount,
    d.delivery_fee,
    d.delivery_time_mins,
    d.rating
FROM fact_deliveries d
JOIN dim_customer c ON d.customer_id = c.customer_id
WHERE d.order_amount BETWEEN 300 AND 1000
  AND d.delivery_status = 'Delivered'
ORDER BY d.order_amount DESC;

-- Insight: BETWEEN is cleaner than writing amount >= 300 AND
-- amount <= 1000. Mid-range customers are often the largest
-- segment and most responsive to cashback offers.

-- ────────────────────────────────────────────────────────────
-- Case Study 4: Find Churned SaaS Subscribers
-- ────────────────────────────────────────────────────────────
-- Business context: The SaaS growth team wants a list of all
-- inactive subscribers whose plan has expired so the sales
-- team can run a targeted win-back email campaign.
-- Table: fact_subscriptions JOIN dim_customer

SELECT
    s.sub_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    s.plan,
    s.monthly_price,
    s.end_date
FROM fact_subscriptions s
JOIN dim_customer c ON s.customer_id = c.customer_id
WHERE s.is_active = 0
  AND s.end_date < CURDATE()
ORDER BY s.end_date DESC;

-- Insight: is_active = 0 AND end_date < today are BOTH needed.
-- A subscription can be inactive but not yet expired (cancelled
-- early). This query finds truly churned users only.

-- ────────────────────────────────────────────────────────────
-- Case Study 5: Products Low on Stock Needing Reorder
-- ────────────────────────────────────────────────────────────
-- Business context: The procurement team needs to identify all
-- products where current stock is below the reorder level so
-- they can raise purchase orders before items go out of stock.
-- Table: dim_product

SELECT
    product_id,
    product_name,
    category,
    brand,
    stock_qty,
    reorder_level,
    unit_price,
    (reorder_level - stock_qty) AS units_to_reorder
FROM dim_product
WHERE stock_qty < reorder_level
  AND stock_qty >= 0
ORDER BY stock_qty ASC;

-- Insight: (reorder_level - stock_qty) AS units_to_reorder
-- gives procurement the exact quantity to order per product.
-- Sorting ASC puts most critical (near zero) items first.

-- ============================================================
-- Daily Summary
-- Topics practiced : SELECT, WHERE, AND, BETWEEN, CURDATE(),
--                    CONCAT, ORDER BY, JOIN, aliases (AS)
-- Hardest part     :
-- Key takeaway     :
-- GitHub commit    : Day 01 | SELECT WHERE Filtering | 5/5 case studies solved
-- LinkedIn post    : Yes / No
-- ============================================================