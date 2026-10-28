-- =========================================================================
-- Migration: attendance_registers (Faculty Roll-Call Ledger)
-- Migration: 20261028120000
-- Purpose: Durable cloud mirror of the faculty attendance registers
--          recorded in the mobile portal. Mirrors the local vault
--          (`gri_vault_roll_call_records`) so registers survive device
--          loss and can feed the Samarth ERP reconciliation reports.
-- =========================================================================

-- 1. Table: attendance_registers (append-only session records)
CREATE TABLE IF NOT EXISTS public.attendance_registers (
    id TEXT PRIMARY KEY,
    course_code TEXT NOT NULL,
    batch TEXT NOT NULL,
    recorded_by TEXT NOT NULL,
    present_count INTEGER NOT NULL DEFAULT 0,
    absent_count INTEGER NOT NULL DEFAULT 0,
    od_count INTEGER NOT NULL DEFAULT 0,
    recorded_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_attendance_registers_course
    ON public.attendance_registers(course_code);
CREATE INDEX IF NOT EXISTS idx_attendance_registers_recorded_at
    ON public.attendance_registers(recorded_at DESC);

ALTER TABLE public.attendance_registers ENABLE ROW LEVEL SECURITY;

-- Staff submit registers; approved institutional roles may read the
-- aggregated counts (no personal data beyond roll-call totals is stored).
CREATE POLICY "Staff submit attendance registers" ON public.attendance_registers
    FOR INSERT TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.user_profiles AS up
            WHERE up.auth_user_id = auth.uid()
            AND up.active_role IN ('FACULTY', 'ADMIN', 'SUPER_ADMIN', 'COE_STAFF')
            AND up.status = 'APPROVED'
        )
    );

CREATE POLICY "Approved roles read attendance registers" ON public.attendance_registers
    FOR SELECT TO authenticated
    USING (
        auth.uid() IS NOT NULL
        AND EXISTS (
            SELECT 1 FROM public.user_profiles AS up
            WHERE up.auth_user_id = auth.uid()
            AND up.status = 'APPROVED'
        )
    );

-- The register is append-only: no UPDATE/DELETE policies are granted, and
-- legacy grants are revoked so anon/authenticated sessions cannot alter
-- submitted registers.
REVOKE UPDATE, DELETE ON public.attendance_registers FROM anon, authenticated;
