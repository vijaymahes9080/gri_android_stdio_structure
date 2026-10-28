-- =========================================================================
-- GRI MOBILE PORTAL — Document Certification Register & Application Queue
-- Migration: 20261028000000
-- Adds the certificate authenticity register used by the Official Document
-- Center and the registrar application review queue used by the registration
-- wizard. Both tables are covered by RLS.
-- =========================================================================

-- -------------------------------------------------------------------------
-- 1. Table: document_certificates (e-SANAD verification register)
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.document_certificates (
    code TEXT PRIMARY KEY,
    holder_name TEXT NOT NULL,
    programme TEXT NOT NULL,
    register_number TEXT NOT NULL,
    issued_by TEXT NOT NULL,
    issued_on TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_document_certificates_register_number
    ON public.document_certificates(register_number);

ALTER TABLE public.document_certificates ENABLE ROW LEVEL SECURITY;

-- Verification is a public, read-only operation (holding a certificate code
-- is the credential itself; no personal data beyond the certificate record
-- is exposed).
CREATE POLICY "Public read certificate register" ON public.document_certificates
    FOR SELECT USING (true);

-- Only service-role / admin writes are permitted; no anon-write policy exists.
CREATE POLICY "Admins manage certificate register" ON public.document_certificates
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.user_profiles AS up
            WHERE up.auth_user_id = auth.uid()
            AND up.active_role = 'ADMIN'
            AND up.status = 'APPROVED'
        )
    );

-- Seed rows mirror the development register shipped with the app
-- (lib/services/document_certification_service.dart). Codes carry the
-- trailing check digit defined by the app-side checksum algorithm.
INSERT INTO public.document_certificates
    (code, holder_name, programme, register_number, issued_by, issued_on)
VALUES
    ('GRI-CERT-2023-015468', 'Preethi Ramasamy',
     'B.Sc. (Hons) Agriculture', '2020-BSC-AGR-0901',
     'Office of the Controller of Examinations, GRI', '18 Aug 2023'),
    ('GRI-MARK-2024-40118', 'Vijay Pradhap',
     'M.C.A. — Semester IV Statement of Marks (CBCS)', '2024-MS-4011',
     'Office of the Controller of Examinations, GRI', '06 Oct 2026'),
    ('GRI-DEG-2022-022775', 'Aravind Manoharan',
     'M.A. Rural Development — Degree Certificate', '2020-MA-RD-1180',
     'Office of the Registrar (Academic), GRI', '21 Feb 2022'),
    ('GRI-TRAN-2026-009821', 'Divya Bharathi',
     'Ph.D. Rural Future Studies — Course Transcript', '2023-PHD-RFS-0412',
     'Office of the Controller of Examinations, GRI', '12 Sep 2026')
ON CONFLICT (code) DO NOTHING;

-- -------------------------------------------------------------------------
-- 2. Table: registration_applications (Registrar review queue)
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.registration_applications (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    full_name TEXT NOT NULL,
    email TEXT NOT NULL,
    mobile TEXT NOT NULL DEFAULT '',
    institutional_id TEXT NOT NULL DEFAULT '',
    requested_role TEXT NOT NULL,
    department TEXT NOT NULL DEFAULT '',
    programme TEXT NOT NULL DEFAULT '',
    year_semester TEXT NOT NULL DEFAULT '',
    designation TEXT NOT NULL DEFAULT '',
    research_topic TEXT NOT NULL DEFAULT '',
    status TEXT NOT NULL DEFAULT 'PENDING_APPROVAL' CHECK (status IN
        ('PENDING_APPROVAL', 'UNDER_REVIEW', 'APPROVED', 'REJECTED',
         'SUSPENDED', 'DISABLED')),
    submitted_date TEXT NOT NULL DEFAULT '',
    admin_query TEXT NOT NULL DEFAULT '',
    applicant_response TEXT NOT NULL DEFAULT '',
    rejection_reason TEXT NOT NULL DEFAULT '',
    history JSONB NOT NULL DEFAULT '[]'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_registration_applications_status
    ON public.registration_applications(status);
CREATE INDEX IF NOT EXISTS idx_registration_applications_email
    ON public.registration_applications(email);

DROP TRIGGER IF EXISTS set_reg_apps_updated_at ON public.registration_applications;
CREATE TRIGGER set_reg_apps_updated_at
BEFORE UPDATE ON public.registration_applications
FOR EACH ROW
EXECUTE FUNCTION public.handle_updated_at();

ALTER TABLE public.registration_applications ENABLE ROW LEVEL SECURITY;

-- Anyone (including pre-auth applicants from the public wizard) may submit
-- an application for review.
CREATE POLICY "Applicants and public submit registrations" ON public.registration_applications
    FOR INSERT WITH CHECK (true);

-- Applicants may read their own queue entry; approved admins may read all.
CREATE POLICY "Applicants read own application" ON public.registration_applications
    FOR SELECT USING (
        email = auth.email()
        OR EXISTS (
            SELECT 1 FROM public.user_profiles AS up
            WHERE up.auth_user_id = auth.uid()
            AND up.active_role IN ('ADMIN', 'SUPER_ADMIN')
            AND up.status = 'APPROVED'
        )
    );

-- Review actions (approve, reject, query) are admin-only.
CREATE POLICY "Admins review applications" ON public.registration_applications
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM public.user_profiles AS up
            WHERE up.auth_user_id = auth.uid()
            AND up.active_role IN ('ADMIN', 'SUPER_ADMIN')
            AND up.status = 'APPROVED'
        )
    );
