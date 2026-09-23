-- Reporting Queries
-- Multi-Tenant E-Commerce Order Management System

-- =========================================================
-- 1. TOTAL SALES BY ORGANIZATION
-- =========================================================

SELECT
t.id AS tenant_id,
t.name AS organization,
COALESCE(SUM(o.total_amount), 0) AS total_sales
FROM tenants t
LEFT JOIN orders o
ON o.tenant_id = t.id
AND o.status <> 'cancelled'
GROUP BY t.id, t.name
ORDER BY total_sales DESC;

-- =========================================================
-- 2. MONTHLY SALES TRENDS
-- =========================================================

SELECT
o.tenant_id,
DATE_TRUNC('month', o.created_at) AS sales_month,
SUM(o.total_amount) AS monthly_sales
FROM orders o
WHERE o.status <> 'cancelled'
GROUP BY o.tenant_id, DATE_TRUNC('month', o.created_at)
ORDER BY sales_month;

-- =========================================================
-- 3. TOP-SELLING PRODUCTS
-- =========================================================

SELECT
p.id AS product_id,
p.sku,
p.name AS product,
SUM(oi.quantity) AS units_sold,
SUM(oi.quantity * oi.unit_price) AS revenue
FROM order_items oi
JOIN orders o
ON o.id = oi.order_id
JOIN products p
ON p.id = oi.product_id
WHERE o.status <> 'cancelled'
GROUP BY p.id, p.sku, p.name
ORDER BY units_sold DESC, revenue DESC;

-- =========================================================
-- 4. ORDERS GROUPED BY STATUS
-- =========================================================

SELECT
tenant_id,
status,
COUNT(*) AS order_count,
COALESCE(SUM(total_amount), 0) AS total_value
FROM orders
GROUP BY tenant_id, status
ORDER BY tenant_id, status;

-- =========================================================
-- 5. CURRENT INVENTORY LEVELS
-- =========================================================

SELECT
p.tenant_id,
p.sku,
p.name AS product,
i.quantity_on_hand,
i.reorder_level,
CASE
WHEN i.quantity_on_hand <= i.reorder_level
THEN 'REORDER'
ELSE 'OK'
END AS stock_status
FROM inventory i
JOIN products p
ON p.id = i.product_id
ORDER BY p.tenant_id, p.name;

-- =========================================================
-- 6. CUSTOMER PURCHASE HISTORY
-- =========================================================

SELECT
c.tenant_id,
c.id AS customer_id,
c.first_name,
c.last_name,
o.id AS order_id,
o.created_at,
o.status,
o.total_amount
FROM customers c
JOIN orders o
ON o.customer_id = c.id
ORDER BY c.tenant_id, c.id, o.created_at DESC;

-- =========================================================
-- 7. REVENUE BY PRODUCT CATEGORY
-- =========================================================

SELECT
p.tenant_id,
c.id AS category_id,
c.name AS category,
SUM(oi.quantity * oi.unit_price) AS revenue
FROM order_items oi
JOIN orders o
ON o.id = oi.order_id
JOIN products p
ON p.id = oi.product_id
JOIN categories c
ON c.id = p.category_id
WHERE o.status <> 'cancelled'
GROUP BY p.tenant_id, c.id, c.name
ORDER BY p.tenant_id, revenue DESC;
