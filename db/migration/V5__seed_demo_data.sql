-- V5__seed_demo_data.sql
-- Demo data for development and testing

-- =========================================================
-- TENANTS
-- =========================================================

INSERT INTO tenants (id, name, status)
VALUES
    (
        '11111111-1111-1111-1111-111111111111',
        'Demo Store A',
        'active'
    ),
    (
        '22222222-2222-2222-2222-222222222222',
        'Demo Store B',
        'active'
    );

-- =========================================================
-- CUSTOMERS
-- =========================================================

INSERT INTO customers (
    id,
    tenant_id,
    first_name,
    last_name,
    email,
    phone,
    status
)
VALUES
    (
        'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
        '11111111-1111-1111-1111-111111111111',
        'Ahmed',
        'Ali',
        'ahmed@demo-a.com',
        '+254700000001',
        'active'
    ),
    (
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
        '11111111-1111-1111-1111-111111111111',
        'Fatima',
        'Hassan',
        'fatima@demo-a.com',
        '+254700000002',
        'active'
    ),
    (
        'cccccccc-cccc-cccc-cccc-cccccccccccc',
        '22222222-2222-2222-2222-222222222222',
        'Mohamed',
        'Omar',
        'mohamed@demo-b.com',
        '+254700000003',
        'active'
    );

-- =========================================================
-- ADDRESSES
-- =========================================================

INSERT INTO addresses (
    id,
    customer_id,
    address_line1,
    city,
    country,
    postal_code,
    address_type
)
VALUES
    (
        'aaaa1111-1111-1111-1111-111111111111',
        'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
        '123 Demo Street',
        'Nairobi',
        'Kenya',
        '00100',
        'shipping'
    ),
    (
        'bbbb2222-2222-2222-2222-222222222222',
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
        '456 Demo Road',
        'Nairobi',
        'Kenya',
        '00200',
        'shipping'
    ),
    (
        'cccc3333-3333-3333-3333-333333333333',
        'cccccccc-cccc-cccc-cccc-cccccccccccc',
        '789 Demo Avenue',
        'Mombasa',
        'Kenya',
        '80100',
        'shipping'
    );

-- =========================================================
-- CATEGORIES
-- =========================================================

INSERT INTO categories (
    id,
    tenant_id,
    name,
    description
)
VALUES
    (
        'ca111111-1111-1111-1111-111111111111',
        '11111111-1111-1111-1111-111111111111',
        'Electronics',
        'Electronic products'
    ),
    (
        'ca222222-2222-2222-2222-222222222222',
        '11111111-1111-1111-1111-111111111111',
        'Accessories',
        'Electronic accessories'
    ),
    (
        'ca333333-3333-3333-3333-333333333333',
        '22222222-2222-2222-2222-222222222222',
        'Home',
        'Home products'
    );

-- =========================================================
-- PRODUCTS
-- =========================================================

INSERT INTO products (
    id,
    tenant_id,
    category_id,
    sku,
    name,
    description,
    price,
    status
)
VALUES
    (
        'd1111111-1111-1111-1111-111111111111',
        '11111111-1111-1111-1111-111111111111',
        'ca111111-1111-1111-1111-111111111111',
        'ELEC-001',
        'Wireless Headphones',
        'Bluetooth wireless headphones',
        59.99,
        'active'
    ),
    (
        'd2222222-2222-2222-2222-222222222222',
        '11111111-1111-1111-1111-111111111111',
        'ca222222-2222-2222-2222-222222222222',
        'ACC-001',
        'USB-C Cable',
        'USB-C charging cable',
        12.50,
        'active'
    ),
    (
        'd3333333-3333-3333-3333-333333333333',
        '22222222-2222-2222-2222-222222222222',
        'ca333333-3333-3333-3333-333333333333',
        'HOME-001',
        'Desk Lamp',
        'LED desk lamp',
        35.00,
        'active'
    );

-- =========================================================
-- INVENTORY
-- =========================================================

INSERT INTO inventory (
    id,
    product_id,
    quantity_on_hand,
    reorder_level
)
VALUES
    (
        'e1111111-1111-1111-1111-111111111111',
        'd1111111-1111-1111-1111-111111111111',
        100,
        10
    ),
    (
        'e2222222-2222-2222-2222-222222222222',
        'd2222222-2222-2222-2222-222222222222',
        250,
        25
    ),
    (
        'e3333333-3333-3333-3333-333333333333',
        'd3333333-3333-3333-3333-333333333333',
        75,
        10
    );

-- =========================================================
-- ORDERS
-- =========================================================

INSERT INTO orders (
    id,
    tenant_id,
    customer_id,
    shipping_address_id,
    status,
    total_amount
)
VALUES
    (
        'f1111111-1111-1111-1111-111111111111',
        '11111111-1111-1111-1111-111111111111',
        'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
        'aaaa1111-1111-1111-1111-111111111111',
        'confirmed',
        72.49
    ),
    (
        'f2222222-2222-2222-2222-222222222222',
        '22222222-2222-2222-2222-222222222222',
        'cccccccc-cccc-cccc-cccc-cccccccccccc',
        'cccc3333-3333-3333-3333-333333333333',
        'pending',
        70.00
    );

-- =========================================================
-- ORDER ITEMS
-- =========================================================

INSERT INTO order_items (
    id,
    order_id,
    product_id,
    quantity,
    unit_price
)
VALUES
    (
        '10111111-1111-1111-1111-111111111111',
        'f1111111-1111-1111-1111-111111111111',
        'd1111111-1111-1111-1111-111111111111',
        1,
        59.99
    ),
    (
        '10222222-2222-2222-2222-222222222222',
        'f1111111-1111-1111-1111-111111111111',
        'd2222222-2222-2222-2222-222222222222',
        1,
        12.50
    ),
    (
        '10333333-3333-3333-3333-333333333333',
        'f2222222-2222-2222-2222-222222222222',
        'd3333333-3333-3333-3333-333333333333',
        2,
        35.00
    );

-- =========================================================
-- PAYMENTS
-- =========================================================

INSERT INTO payments (
    id,
    order_id,
    amount,
    payment_method,
    payment_status,
    transaction_reference,
    paid_at
)
VALUES
    (
        '10444444-4444-4444-4444-444444444444',
        'f1111111-1111-1111-1111-111111111111',
        72.49,
        'mobile_money',
        'completed',
        'DEMO-TXN-001',
        CURRENT_TIMESTAMP
    ),
    (
        '10555555-5555-5555-5555-555555555555',
        'f2222222-2222-2222-2222-222222222222',
        70.00,
        'card',
        'pending',
        'DEMO-TXN-002',
        NULL
    );