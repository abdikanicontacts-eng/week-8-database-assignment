-- V2__indexes.sql
-- Indexes for frequently used queries

-- Customer lookups
CREATE INDEX idx_customers_tenant_id
    ON customers (tenant_id);

CREATE INDEX idx_customers_tenant_status
    ON customers (tenant_id, status);

-- Address lookups
CREATE INDEX idx_addresses_customer_id
    ON addresses (customer_id);

-- Category lookups
CREATE INDEX idx_categories_tenant_id
    ON categories (tenant_id);

-- Product lookups
CREATE INDEX idx_products_tenant_category
    ON products (tenant_id, category_id);

CREATE INDEX idx_products_tenant_status
    ON products (tenant_id, status);

CREATE INDEX idx_products_name
    ON products (name);

-- Inventory lookups
CREATE INDEX idx_inventory_product_id
    ON inventory (product_id);

CREATE INDEX idx_inventory_stock_level
    ON inventory (quantity_on_hand);

-- Order lookups
CREATE INDEX idx_orders_tenant_customer
    ON orders (tenant_id, customer_id);

CREATE INDEX idx_orders_tenant_status
    ON orders (tenant_id, status);

CREATE INDEX idx_orders_tenant_created
    ON orders (tenant_id, created_at);

-- Order item lookups
CREATE INDEX idx_order_items_order_id
    ON order_items (order_id);

CREATE INDEX idx_order_items_product_id
    ON order_items (product_id);

-- Payment lookups
CREATE INDEX idx_payments_order_id
    ON payments (order_id);

CREATE INDEX idx_payments_status
    ON payments (payment_status);

-- Audit log lookups
CREATE INDEX idx_audit_logs_tenant_created
    ON audit_logs (tenant_id, created_at);

CREATE INDEX idx_audit_logs_record
    ON audit_logs (table_name, record_id);
    -- Optimization index for customer order history
CREATE INDEX IF NOT EXISTS idx_orders_customer_created
ON orders (customer_id, created_at DESC);
