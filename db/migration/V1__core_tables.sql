-- V1__core_tables.sql
-- Multi-Tenant E-Commerce Order Management System

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- =========================================================
-- TENANTS
-- =========================================================

CREATE TABLE tenants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(150) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_tenants_status
        CHECK (status IN ('active', 'inactive', 'suspended'))
);

-- =========================================================
-- CUSTOMERS
-- =========================================================

CREATE TABLE customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(50),
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_customers_tenant
        FOREIGN KEY (tenant_id)
        REFERENCES tenants(id)
        ON DELETE CASCADE,

    CONSTRAINT uq_customers_tenant_email
        UNIQUE (tenant_id, email),

    CONSTRAINT chk_customers_status
        CHECK (status IN ('active', 'inactive'))
);

-- =========================================================
-- ADDRESSES
-- =========================================================

CREATE TABLE addresses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL,
    address_line1 VARCHAR(255) NOT NULL,
    address_line2 VARCHAR(255),
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    postal_code VARCHAR(30),
    address_type VARCHAR(20) NOT NULL DEFAULT 'shipping',
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_addresses_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_addresses_type
        CHECK (address_type IN ('billing', 'shipping'))
);

-- =========================================================
-- CATEGORIES
-- =========================================================

CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_categories_tenant
        FOREIGN KEY (tenant_id)
        REFERENCES tenants(id)
        ON DELETE CASCADE,

    CONSTRAINT uq_categories_tenant_name
        UNIQUE (tenant_id, name)
);

-- =========================================================
-- PRODUCTS
-- =========================================================

CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    category_id UUID NOT NULL,
    sku VARCHAR(100) NOT NULL,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price NUMERIC(12,2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_products_tenant
        FOREIGN KEY (tenant_id)
        REFERENCES tenants(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id)
        REFERENCES categories(id)
        ON DELETE RESTRICT,

    CONSTRAINT uq_products_tenant_sku
        UNIQUE (tenant_id, sku),

    CONSTRAINT chk_products_price
        CHECK (price >= 0),

    CONSTRAINT chk_products_status
        CHECK (status IN ('active', 'inactive'))
);

-- =========================================================
-- INVENTORY
-- =========================================================

CREATE TABLE inventory (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL UNIQUE,
    quantity_on_hand INTEGER NOT NULL DEFAULT 0,
    reorder_level INTEGER NOT NULL DEFAULT 0,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_inventory_product
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_inventory_quantity
        CHECK (quantity_on_hand >= 0),

    CONSTRAINT chk_inventory_reorder_level
        CHECK (reorder_level >= 0)
);

-- =========================================================
-- ORDERS
-- =========================================================

CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    customer_id UUID NOT NULL,
    shipping_address_id UUID,
    status VARCHAR(30) NOT NULL DEFAULT 'pending',
    total_amount NUMERIC(12,2) NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_orders_tenant
        FOREIGN KEY (tenant_id)
        REFERENCES tenants(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_orders_shipping_address
        FOREIGN KEY (shipping_address_id)
        REFERENCES addresses(id)
        ON DELETE SET NULL,

    CONSTRAINT chk_orders_status
        CHECK (
            status IN (
                'pending',
                'confirmed',
                'processing',
                'shipped',
                'delivered',
                'cancelled'
            )
        ),

    CONSTRAINT chk_orders_total
        CHECK (total_amount >= 0)
);

-- =========================================================
-- ORDER ITEMS
-- =========================================================

CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL,
    product_id UUID NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price NUMERIC(12,2) NOT NULL,
    line_total NUMERIC(12,2)
        GENERATED ALWAYS AS (quantity * unit_price) STORED,

    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)
        REFERENCES orders(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_order_items_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_order_items_unit_price
        CHECK (unit_price >= 0)
);

-- =========================================================
-- PAYMENTS
-- =========================================================

CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL,
    amount NUMERIC(12,2) NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    payment_status VARCHAR(30) NOT NULL DEFAULT 'pending',
    transaction_reference VARCHAR(255),
    paid_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_payments_order
        FOREIGN KEY (order_id)
        REFERENCES orders(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_payments_amount
        CHECK (amount > 0),

    CONSTRAINT chk_payment_method
        CHECK (
            payment_method IN (
                'card',
                'mobile_money',
                'bank_transfer',
                'cash'
            )
        ),

    CONSTRAINT chk_payment_status
        CHECK (
            payment_status IN (
                'pending',
                'completed',
                'failed',
                'refunded'
            )
        )
);

-- =========================================================
-- AUDIT LOGS
-- =========================================================

CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID,
    actor_id UUID,
    action VARCHAR(20) NOT NULL,
    table_name VARCHAR(100) NOT NULL,
    record_id UUID,
    old_values JSONB,
    new_values JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_audit_logs_tenant
        FOREIGN KEY (tenant_id)
        REFERENCES tenants(id)
        ON DELETE SET NULL,

    CONSTRAINT chk_audit_action
        CHECK (action IN ('INSERT', 'UPDATE', 'DELETE'))
);
