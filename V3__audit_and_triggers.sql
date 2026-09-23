-- V3__audit_and_triggers.sql
-- Audit logging and automatic timestamp triggers

-- =========================================================
-- UPDATED_AT TRIGGER FUNCTION
-- =========================================================

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

-- =========================================================
-- ORDERS UPDATED_AT TRIGGER
-- =========================================================

CREATE TRIGGER trg_orders_updated_at
BEFORE UPDATE ON orders
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

-- =========================================================
-- AUDIT FUNCTION
-- =========================================================

CREATE OR REPLACE FUNCTION audit_row_changes()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    current_tenant_id UUID;
    current_actor_id UUID;
BEGIN
    BEGIN
        current_tenant_id :=
            NULLIF(current_setting('app.current_tenant_id', true), '')::UUID;
    EXCEPTION WHEN OTHERS THEN
        current_tenant_id := NULL;
    END;

    BEGIN
        current_actor_id :=
            NULLIF(current_setting('app.current_actor_id', true), '')::UUID;
    EXCEPTION WHEN OTHERS THEN
        current_actor_id := NULL;
    END;

    IF TG_OP = 'INSERT' THEN

        INSERT INTO audit_logs (
            tenant_id,
            actor_id,
            action,
            table_name,
            record_id,
            old_values,
            new_values
        )
        VALUES (
            current_tenant_id,
            current_actor_id,
            'INSERT',
            TG_TABLE_NAME,
            NEW.id,
            NULL,
            to_jsonb(NEW)
        );

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN

        INSERT INTO audit_logs (
            tenant_id,
            actor_id,
            action,
            table_name,
            record_id,
            old_values,
            new_values
        )
        VALUES (
            current_tenant_id,
            current_actor_id,
            'UPDATE',
            TG_TABLE_NAME,
            NEW.id,
            to_jsonb(OLD),
            to_jsonb(NEW)
        );

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN

        INSERT INTO audit_logs (
            tenant_id,
            actor_id,
            action,
            table_name,
            record_id,
            old_values,
            new_values
        )
        VALUES (
            current_tenant_id,
            current_actor_id,
            'DELETE',
            TG_TABLE_NAME,
            OLD.id,
            to_jsonb(OLD),
            NULL
        );

        RETURN OLD;

    END IF;

    RETURN NULL;
END;
$$;

-- =========================================================
-- AUDIT TRIGGERS
-- =========================================================

CREATE TRIGGER trg_customers_audit
AFTER INSERT OR UPDATE OR DELETE ON customers
FOR EACH ROW
EXECUTE FUNCTION audit_row_changes();

CREATE TRIGGER trg_products_audit
AFTER INSERT OR UPDATE OR DELETE ON products
FOR EACH ROW
EXECUTE FUNCTION audit_row_changes();

CREATE TRIGGER trg_orders_audit
AFTER INSERT OR UPDATE OR DELETE ON orders
FOR EACH ROW
EXECUTE FUNCTION audit_row_changes();

CREATE TRIGGER trg_payments_audit
AFTER INSERT OR UPDATE OR DELETE ON payments
FOR EACH ROW
EXECUTE FUNCTION audit_row_changes();

CREATE TRIGGER trg_inventory_audit
AFTER INSERT OR UPDATE OR DELETE ON inventory
FOR EACH ROW
EXECUTE FUNCTION audit_row_changes();
