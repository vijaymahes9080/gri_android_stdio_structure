-- =========================================================================
-- GRI MOBILE PORTAL — RLS Hardening (fail-closed)
-- Migration: 20261028010000
--
-- Round-2 security audit findings:
--   * circulars_notices / student_courses were writable by ANON sessions
--     ("FOR ALL USING (true)"), meaning any holder of the anon key could
--     publish/alter official notices or attendance records.
--   * grievances / audit_logs / faculty_leaves / notifications were readable
--     (and notifications uploadable) by anonymous sessions, exposing personal
--     complaint text and administrative actions publicly.
--
-- Replacement policies below fail closed: unauthenticated (anon-key) sessions
-- get NO access to these tables by design. That is intentional — until Supabase
-- Auth sessions are wired into the application, cloud-mode data is considered
-- admin-side only. The offline local vault is completely unaffected.
-- =========================================================================

-- ---------------------------------------------------------------- circulars
-- Public read of published notices is intentionally retained (marketing-grade
-- public information); writing is restricted to approved admins.
DROP POLICY IF EXISTS "Admins manage all circulars" ON public.circulars_notices;

CREATE POLICY "Admins manage all circulars" ON public.circulars_notices
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM public.user_profiles AS up
            WHERE up.auth_user_id = auth.uid()
            AND up.active_role IN ('ADMIN', 'SUPER_ADMIN')
            AND up.status = 'APPROVED'
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.user_profiles AS up
            WHERE up.auth_user_id = auth.uid()
            AND up.active_role IN ('ADMIN', 'SUPER_ADMIN')
            AND up.status = 'APPROVED'
        )
    );

-- --------------------------------------------------------------- grievances
DROP POLICY IF EXISTS "Users view own grievances" ON public.grievances;
DROP POLICY IF EXISTS "Admins update grievances" ON public.grievances;

-- Complaint text is personal data: visible to the owning student (matched
-- through the institutional profile) or approved staff/admin roles.
CREATE POLICY "Owner or admins view grievances" ON public.grievances
    FOR SELECT USING (
        auth.uid() IS NOT NULL
        AND (
            EXISTS (
                SELECT 1 FROM public.user_profiles AS op
                WHERE op.auth_user_id = auth.uid()
                AND (op.institutional_id = user_id OR op.id::text = user_id)
            )
            OR EXISTS (
                SELECT 1 FROM public.user_profiles AS up
                WHERE up.auth_user_id = auth.uid()
                AND up.active_role IN ('ADMIN', 'SUPER_ADMIN', 'COE_STAFF')
                AND up.status = 'APPROVED'
            )
        )
    );

CREATE POLICY "Owner or admins update grievances" ON public.grievances
    FOR UPDATE USING (
        auth.uid() IS NOT NULL
        AND (
            EXISTS (
                SELECT 1 FROM public.user_profiles AS op
                WHERE op.auth_user_id = auth.uid()
                AND (op.institutional_id = user_id OR op.id::text = user_id)
            )
            OR EXISTS (
                SELECT 1 FROM public.user_profiles AS up
                WHERE up.auth_user_id = auth.uid()
                AND up.active_role IN ('ADMIN', 'SUPER_ADMIN')
                AND up.status = 'APPROVED'
            )
        )
    );

-- ------------------------------------------------------------- faculty_leaves
DROP POLICY IF EXISTS "Faculty view own leaves" ON public.faculty_leaves;
DROP POLICY IF EXISTS "Admins manage leaves" ON public.faculty_leaves;

CREATE POLICY "Owner or admins view leaves" ON public.faculty_leaves
    FOR SELECT USING (
        auth.uid() IS NOT NULL
        AND (
            EXISTS (
                SELECT 1 FROM public.user_profiles AS op
                WHERE op.auth_user_id = auth.uid()
                AND (op.institutional_id = user_id OR op.id::text = user_id)
            )
            OR EXISTS (
                SELECT 1 FROM public.user_profiles AS up
                WHERE up.auth_user_id = auth.uid()
                AND up.active_role IN ('ADMIN', 'SUPER_ADMIN')
                AND up.status = 'APPROVED'
            )
        )
    );

CREATE POLICY "Owner or admins update leaves" ON public.faculty_leaves
    FOR UPDATE USING (
        auth.uid() IS NOT NULL
        AND (
            EXISTS (
                SELECT 1 FROM public.user_profiles AS op
                WHERE op.auth_user_id = auth.uid()
                AND (op.institutional_id = user_id OR op.id::text = user_id)
            )
            OR EXISTS (
                SELECT 1 FROM public.user_profiles AS up
                WHERE up.auth_user_id = auth.uid()
                AND up.active_role IN ('ADMIN', 'SUPER_ADMIN')
                AND up.status = 'APPROVED'
            )
        )
    );

-- ----------------------------------------------------------------- audit_logs
-- The audit ledger is administrative: read access for authenticated users is
-- still exposed via application screens only in admin context.
DROP POLICY IF EXISTS "Everyone read audit logs" ON public.audit_logs;
CREATE POLICY "Authenticated read audit logs" ON public.audit_logs
    FOR SELECT USING (auth.uid() IS NOT NULL);

-- ----------------------------------------------------------------- courses
-- Attendance is ledger data: reads are restricted to the owning student or
-- academic staff; writes gone entirely for anon.
DROP POLICY IF EXISTS "Everyone read student courses" ON public.student_courses;
DROP POLICY IF EXISTS "Everyone update student courses" ON public.student_courses;

CREATE POLICY "Owner or staff read student courses" ON public.student_courses
    FOR SELECT USING (
        auth.uid() IS NOT NULL
        AND (
            EXISTS (
                SELECT 1 FROM public.user_profiles AS op
                WHERE op.auth_user_id = auth.uid()
                AND (op.institutional_id = user_id OR op.id::text = user_id)
            )
            OR EXISTS (
                SELECT 1 FROM public.user_profiles AS up
                WHERE up.auth_user_id = auth.uid()
                AND up.active_role IN ('ADMIN', 'SUPER_ADMIN', 'FACULTY')
                AND up.status = 'APPROVED'
            )
        )
    );

CREATE POLICY "Owner updates own course attendance" ON public.student_courses
    FOR UPDATE
    USING (
        auth.uid() IS NOT NULL
        AND EXISTS (
            SELECT 1 FROM public.user_profiles AS op
            WHERE op.auth_user_id = auth.uid()
            AND (op.institutional_id = user_id OR op.id::text = user_id)
        )
    )
    WITH CHECK (
        auth.uid() IS NOT NULL
        AND EXISTS (
            SELECT 1 FROM public.user_profiles AS op
            WHERE op.auth_user_id = auth.uid()
            AND (op.institutional_id = user_id OR op.id::text = user_id)
        )
    );

-- ------------------------------------------------------------- notifications
-- Broadcast notification read flags: authenticated update only.
DROP POLICY IF EXISTS "Everyone update notifications" ON public.notifications;
CREATE POLICY "Authenticated update own notifications" ON public.notifications
    FOR UPDATE USING (
        auth.uid() IS NOT NULL
        AND (user_id IS NULL OR EXISTS (
            SELECT 1 FROM public.user_profiles AS op
            WHERE op.auth_user_id = auth.uid()
            AND (op.institutional_id = user_id OR op.id::text = user_id)
        ))
    );
