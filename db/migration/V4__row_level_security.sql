-- V4__row_level_security.sql
-- Row-Level Security for tenant data isolation

-- =========================================================
-- ENABLE RLS
-- =========================================================

ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE addresses ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;

-- Force RLS even for table owners
ALTER TABLE customers FORCE ROW LEVEL SECURITY;
ALTER TABLE addresses FORCE ROW LEVEL SECURITY;
ALTER TABLE categories FORCE ROW LEVEL SECURITY;
ALTER TABLE products FORCE ROW LEVEL SECURITY;
ALTER TABLE inventory FORCE ROW LEVEL SECURITY;
ALTER TABLE orders FORCE ROW LEVEL SECURITY;
ALTER TABLE order_items FORCE ROW LEVEL SECURITY;
ALTER TABLE payments FORCE ROW LEVEL SECURITY;
ALTER TABLE audit_logs FORCE ROW LEVEL SECURITY;

-- =========================================================
-- CUSTOMERS
-- =========================================================

CREATE POLICY customers_tenant_isolation
ON customers
USING (
    tenant_id = NULLIF(
        current_setting('app.current_tenant_id', true),
        ''
    )::UUID
)
WITH CHECK (
    tenant_id = NULLIF(
        current_setting('app.current_tenant_id', true),
        ''
    )::UUID
);

-- =========================================================
-- CATEGORIES
-- =========================================================

CREATE POLICY categories_tenant_isolation
ON categories
USING (
    tenant_id = NULLIF(
        current_setting('app.current_tenant_id', true),
        ''
    )::UUID
)
WITH CHECK (
    tenant_id = NULLIF(
        current_setting('app.current_tenant_id', true),
        ''
    )::UUID
);

-- =========================================================
-- PRODUCTS
-- =========================================================

CREATE POLICY products_tenant_isolation
ON products
USING (
    tenant_id = NULLIF(
        current_setting('app.current_tenant_id', true),
        ''
    )::UUID
)
WITH CHECK (
    tenant_id = NULLIF(
        current_setting('app.current_tenant_id', true),
        ''
    )::UUID
);

-- =========================================================
-- ORDERS
-- =========================================================

CREATE POLICY orders_tenant_isolation
ON orders
USING (
    tenant_id = NULLIF(
        current_setting('app.current_tenant_id', true),
        ''
    )::UUID
)
WITH CHECK (
    tenant_id = NULLIF(
        current_setting('app.current_tenant_id', true),
        ''
    )::UUID
);

-- =========================================================
-- AUDIT LOGS
-- =========================================================

CREATE POLICY audit_logs_tenant_isolation
ON audit_logs
USING (
    tenant_id = NULLIF(
        current_setting('app.current_tenant_id', true),
        ''
    )::UUID
)
WITH CHECK (
    tenant_id = NULLIF(
        current_setting('app.current_tenant_id', true),
        ''
    )::UUID
);

-- =========================================================
-- ADDRESSES
-- Tenant is determined through the customer
-- =========================================================

CREATE POLICY addresses_tenant_isolation
ON addresses
USING (
    EXISTS (
        SELECT 1
        FROM customers c
        WHERE c.id = addresses.customer_id
          AND c.tenant_id = NULLIF(
              current_setting('app.current_tenant_id', true),
              ''
          )::UUID
    )
);

-- =========================================================
-- INVENTORY
-- Tenant is determined through the product
-- =========================================================

CREATE POLICY inventory_tenant_isolation
ON inventory
USING (
    EXISTS (
        SELECT 1
        FROM products p
        WHERE p.id = inventory.product_id
          AND p.tenant_id = NULLIF(
              current_setting('app.current_tenant_id', true),
              ''
          )::UUID
    )
);

-- =========================================================
-- ORDER ITEMS
-- Tenant is determined through the order
-- =========================================================

CREATE POLICY order_items_tenant_isolation
ON order_items
USING (
    EXISTS (
        SELECT 1
        FROM orders o
        WHERE o.id = order_items.order_id
          AND o.tenant_id = NULLIF(
              current_setting('app.current_tenant_id', true),
              ''
          )::UUID
    )
);

-- =========================================================
-- PAYMENTS
-- Tenant is determined through the order
-- =========================================================

CREATE POLICY payments_tenant_isolation
ON payments
USING (
    EXISTS (
        SELECT 1
        FROM orders o
        WHERE o.id = payments.order_id
          AND o.tenant_id = NULLIF(
              current_setting('app.current_tenant_id', true),
              ''
          )::UUID
    )
);
