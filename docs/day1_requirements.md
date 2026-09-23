Multi-Tenant E-Commerce Order Management System 
1. Project Overview

The proposed system is a multi-tenant e-commerce order management system designed to support multiple independent organizations using the same application. Each organization can manage its own customers, products, inventory, orders, payments, and related business data while preventing unauthorized access to another organization's data.

PostgreSQL will be used as the primary relational database because the system contains strongly related transactional data and requires ACID transactions, referential integrity, complex queries, indexing, auditing, and row-level security. Redis will later be integrated for high-speed temporary data such as shopping carts and frequently accessed product information.
2. Business Objectives

The main objectives of the system are to:

• Manage products and product categories.
• Register and manage customers.
• Store customer addresses.
• Create and manage customer orders.
• Add multiple products to an order.
• Track order quantities and prices.
• Maintain product inventory.
• Record and track payments.
• Generate sales and operational reports.
• Maintain an audit history of important changes.
• Keep each organization's data isolated from other organizations.
3. Functional Requirements
Customer Management
The system shall allow organizations to create and manage customer records, including names, email addresses, phone numbers, and customer status. A customer may have multiple addresses.
Product Management
The system shall allow organizations to create products, assign products to categories, manage prices, and control product availability.
Inventory Management
The system shall maintain the quantity of products available in inventory and support stock-level monitoring.
Order Management
The system shall allow customers to place orders containing one or more products. Each order shall record the customer, shipping address, order status, total amount, and timestamps.
Payment Management
The system shall record payments associated with orders, including payment amount, payment method, payment status, transaction reference, and payment date. Sensitive payment information shall not be stored directly.
Audit Management
The system shall record important database changes in an audit log, including the actor, action, affected table, record identifier, and timestamp.
4. Security Requirements
The database shall use least-privilege roles so that the application does not connect using a superuser account.
Row-Level Security (RLS) shall be implemented on tenant-sensitive tables to ensure that users can only access data belonging to their organization.
Sensitive information such as passwords shall never be stored as plaintext. Passwords must be securely hashed, and other sensitive information shall be encrypted where appropriate.
All application database queries shall use parameterized statements. Dynamic SQL string concatenation shall not be used for user-provided values.
Critical business operations shall be recorded in the audit log to provide accountability and traceability.
5. Non-Functional Requirements
The system shall:
Maintain data integrity using primary keys, foreign keys, constraints, and transactions.
Use versioned Flyway migrations so that the database can be recreated consistently from an empty database.
Use appropriate indexes to improve the performance of frequently executed queries.
Demonstrate query optimization using EXPLAIN ANALYZE with before-and-after execution plans.
Use Redis for temporary or frequently accessed data where a non-relational store provides a performance benefit.
Provide PostgreSQL backup and test-restore procedures.
Maintain audit records for critical business operations.
Support secure access through appropriate database roles and permissions.
6. Reporting Requirements
The system shall support analytical queries that provide useful information about business operations, including:
Total sales by organization.
Monthly sales trends.
Top-selling products.
Orders grouped by status.
Current inventory levels.
Customer purchase history.
Revenue by product category.
These queries will later be used to demonstrate database performance optimization using EXPLAIN ANALYZE before and after appropriate indexes or query improvements are applied.
7. Technology Stack
The project will use the following technologies:
PostgreSQL — primary relational database.
Redis — caching and temporary shopping-cart data.
Flyway — versioned database migrations.
Docker — reproducible development environment.
SQL and EXPLAIN ANALYZE — database query analysis and optimization.
pg_dump and pg_restore — database backup and recovery.
dbdiagram.io — Entity Relationship Diagram (ERD).
Google Docs — project documentation.
8. Expected Outcome
At the end of the project, the system will provide a secure and version-controlled multi-tenant e-commerce database.
PostgreSQL will serve as the primary source of truth for customers, products, inventory, orders, payments, and related business data. Redis will provide a supporting NoSQL layer for temporary and frequently accessed data such as shopping carts and cached information.
The completed project will include database migrations, appropriate indexes, audit logging, row-level security, query optimization evidence, backup and restore procedures, and documentation of the major architectural decisions.

