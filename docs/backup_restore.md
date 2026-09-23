# PostgreSQL Backup and Restore

## Overview

The project uses PostgreSQL as the primary relational database. PostgreSQL backup and restore procedures were tested using Docker, `pg_dump`, and `pg_restore`.

## Backup Procedure

A custom-format PostgreSQL backup was created from the `capstone` database:

```powershell
docker exec capstone-postgres pg_dump -U capstone_admin -d capstone -F c -f /tmp/capstone_backup.dump