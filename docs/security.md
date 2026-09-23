# Database Security

## 1. Least-Privilege Application Role

The database uses a dedicated application role named `capstone_app`.

The application role is not a PostgreSQL superuser and does not have `BYPASSRLS`.

The role has access to the `capstone` database and the `public` schema, with CRUD permissions on the application tables.

The PostgreSQL administration role `capstone_admin` is used for database administration and migrations. The application should connect using `capstone_app` rather than the administrative role.

## 2. Row-Level Security

Row-Level Security (RLS) is enabled on tenant-sensitive tables to prevent one organization from accessing another organization's data.

RLS policies are implemented on:

* addresses
* audit_logs
* categories
* customers
* inventory
* order_items
* orders
* payments
* products

The policies use the application tenant context:

`app.current_tenant_id`

## 3. RLS Isolation Test

### Tenant A

The application role was connected using:

`app.current_tenant_id = '11111111-1111-1111-1111-111111111111'`

The customer query returned:

* Ahmed Ali — [ahmed@demo-a.com](mailto:ahmed@demo-a.com)
* Fatima Hassan — [fatima@demo-a.com](mailto:fatima@demo-a.com)

No customer belonging to Tenant B was returned.

### Tenant B

The application role was connected using:

`app.current_tenant_id = '22222222-2222-2222-2222-222222222222'`

The customer query returned:

* Mohamed Omar — [mohamed@demo-b.com](mailto:mohamed@demo-b.com)

No customer belonging to Tenant A was returned.

## 4. Security Result

The RLS tests demonstrate that tenant-sensitive customer data is isolated according to the current tenant context.

The application role can access the database without requiring superuser privileges, while PostgreSQL Row-Level Security provides tenant-level data isolation.

## 5. Application Security Requirements

Application queries should use parameterized statements rather than concatenating user-provided values into SQL.

Passwords and other sensitive information must not be stored as plaintext.

Payment records store transaction metadata rather than sensitive card or payment credentials.

Critical database operations are recorded through the audit logging functionality.
