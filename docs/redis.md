# Redis Integration

## Overview

This project uses PostgreSQL as the primary source of truth and Redis as a fast, temporary data store for data that benefits from quick access.

Redis is used for:

* Shopping carts
* Frequently accessed product information
* Temporary data with expiration

## Redis Container

Redis runs in Docker using Redis 7.

Container name:

```text
capstone-redis
```

Redis port:

```text
6379
```

The Redis connection was verified with:

```text
docker exec capstone-redis redis-cli ping
```

Expected response:

```text
PONG
```

## Shopping Cart

Shopping cart data is stored in Redis using a customer-specific key.

Example:

```text
cart:demo:customer1
```

Example stored value:

```text
product-1:2,product-2:1
```

The cart can be stored with:

```text
SET cart:demo:customer1 "product-1:2,product-2:1"
```

The stored cart can be retrieved with:

```text
GET cart:demo:customer1
```

## Product Cache

Frequently accessed product information can be cached in Redis.

Example key:

```text
product:ELEC-001
```

Example value:

```text
Wireless Headphones|59.99|active
```

The value can be stored with:

```text
SET product:ELEC-001 "Wireless Headphones|59.99|active"
```

It can be retrieved with:

```text
GET product:ELEC-001
```

## TTL and Expiration

Shopping cart data is temporary, so the cart key can use Redis expiration.

Example:

```text
EXPIRE cart:demo:customer1 3600
```

The value `3600` represents one hour.

The remaining TTL can be checked with:

```text
TTL cart:demo:customer1
```

During testing, the TTL was successfully created and returned a value close to 3600 seconds.

## PostgreSQL and Redis Responsibilities

PostgreSQL remains the primary persistent database for the application.

PostgreSQL stores:

* Tenants
* Customers
* Addresses
* Categories
* Products
* Inventory
* Orders
* Order items
* Payments
* Audit logs

Redis is used for fast-access and temporary data such as:

* Shopping carts
* Product cache

This separation allows persistent business data to remain in PostgreSQL while temporary or frequently accessed information can be served quickly from Redis.

## Verification

Redis was verified using Docker commands.

Connection test:

```text
PONG
```

Shopping cart test:

```text
cart:demo:customer1
```

Product cache test:

```text
product:ELEC-001
```

Both Redis keys were successfully created and retrieved during development testing.
