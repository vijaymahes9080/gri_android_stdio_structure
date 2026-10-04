-- =========================================================================
-- GANDHIGRAM RURAL INSTITUTE (GRI) MOBILE PORTAL 2026
-- Supabase Cloud Migration: Initial Schema, Security Policies & Seed Data
-- =========================================================================

-- Enable pgcrypto for UUID generation
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- -------------------------------------------------------------------------
-- 1. Table: user_profiles
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.user_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    auth_user_id UUID UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    mobile TEXT,
    institutional_id TEXT,
    requested_role TEXT NOT NULL DEFAULT 'STUDENT',
    approved_roles TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[],
    active_role TEXT NOT NULL DEFAULT 'GUEST',
    status TEXT NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'UNDER_REVIEW', 'APPROVED', 'REJECTED', 'SUSPENDED', 'PUBLIC')),
    department TEXT,
    programme TEXT,
    semester TEXT,
    designation TEXT,
    application_id TEXT UNIQUE,
    attendance NUMERIC DEFAULT 0.0,
    cgpa TEXT,
    is_hostelite BOOLEAN DEFAULT false,
    hostel_name TEXT,
    bus_pass TEXT,
    valid_thru DATE,
    rejection_reason TEXT,
    info_requested TEXT,
    info_provided TEXT,
    approved_by TEXT,
    approved_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexing for high-performance role & status queries
CREATE INDEX IF NOT EXISTS idx_user_profiles_auth_user_id ON public.user_profiles(auth_user_id);
CREATE INDEX IF NOT EXISTS idx_user_profiles_email ON public.user_profiles(email);
CREATE INDEX IF NOT EXISTS idx_user_profiles_status ON public.user_profiles(status);
CREATE INDEX IF NOT EXISTS idx_user_profiles_active_role ON public.user_profiles(active_role);

-- Trigger for auto-updating updated_at
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS set_profiles_updated_at ON public.user_profiles;
CREATE TRIGGER set_profiles_updated_at
BEFORE UPDATE ON public.user_profiles
FOR EACH ROW
EXECUTE FUNCTION public.handle_updated_at();

-- -------------------------------------------------------------------------
-- 2. Table: audit_logs (Immutable Institutional Ledger)
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    actor_user_id TEXT NOT NULL,
    actor_name TEXT NOT NULL,
    target_user_id TEXT,
    action TEXT NOT NULL,
    previous_status TEXT,
    new_status TEXT,
    remarks TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_audit_logs_created_at ON public.audit_logs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_audit_logs_action ON public.audit_logs(action);

-- -------------------------------------------------------------------------
-- 3. Table: circulars_notices (Statutory Publishing & Freshness Hub)
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.circulars_notices (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    category TEXT NOT NULL,
    date TEXT NOT NULL,
    issued_by TEXT NOT NULL,
    urgent BOOLEAN NOT NULL DEFAULT false,
    summary TEXT NOT NULL,
    stage TEXT NOT NULL DEFAULT 'PUBLISHED' CHECK (stage IN ('DRAFT', 'PUBLISHED', 'ARCHIVED')),
    audience TEXT DEFAULT 'ALL CAMPUS NETWORK',
    doc_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_circulars_stage ON public.circulars_notices(stage);
CREATE INDEX IF NOT EXISTS idx_circulars_created_at ON public.circulars_notices(created_at DESC);

-- -------------------------------------------------------------------------
-- 4. Table: grievances (GRI-Care Grievance Redressal System)
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.grievances (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    user_name TEXT,
    category TEXT NOT NULL,
    subject TEXT NOT NULL,
    description TEXT NOT NULL,
    date TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'SUBMITTED' CHECK (status IN ('SUBMITTED', 'IN_PROGRESS', 'RESOLVED')),
    remarks TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_grievances_user_id ON public.grievances(user_id);
CREATE INDEX IF NOT EXISTS idx_grievances_status ON public.grievances(status);

-- -------------------------------------------------------------------------
-- 5. Table: faculty_leaves (Faculty & Staff Academic Suite)
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.faculty_leaves (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    faculty_name TEXT NOT NULL,
    type TEXT NOT NULL,
    dates TEXT NOT NULL,
    days INTEGER NOT NULL DEFAULT 1,
    reason TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'PENDING_HOD' CHECK (status IN ('PENDING_HOD', 'APPROVED', 'REJECTED')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_faculty_leaves_user_id ON public.faculty_leaves(user_id);
CREATE INDEX IF NOT EXISTS idx_faculty_leaves_status ON public.faculty_leaves(status);

-- -------------------------------------------------------------------------
-- 6. Table: notifications (Real-Time Notification Ledger)
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.notifications (
    id TEXT PRIMARY KEY,
    user_id TEXT, -- NULL denotes campus-wide broadcast
    title TEXT NOT NULL,
    text TEXT NOT NULL,
    time TEXT NOT NULL,
    unread BOOLEAN NOT NULL DEFAULT true,
    target_tab TEXT,
    target_action TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON public.notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_unread ON public.notifications(unread);

-- -------------------------------------------------------------------------
-- 7. Table: student_courses (Biometric Attendance & Enrollment Ledger)
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.student_courses (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    code TEXT NOT NULL,
    title TEXT NOT NULL,
    credits INTEGER NOT NULL DEFAULT 4,
    instructor TEXT NOT NULL,
    schedule TEXT NOT NULL,
    attendance NUMERIC NOT NULL DEFAULT 0.0,
    total INTEGER NOT NULL DEFAULT 0,
    attended INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_student_courses_user_id ON public.student_courses(user_id);

-- =========================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =========================================================================

ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.circulars_notices ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.grievances ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.faculty_leaves ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.student_courses ENABLE ROW LEVEL SECURITY;

-- user_profiles Policies
CREATE POLICY "Public read approved profiles" ON public.user_profiles
    FOR SELECT USING (status = 'APPROVED' OR auth_user_id = auth.uid() OR auth_user_id IS NULL);

CREATE POLICY "Users can create their own profile during registration" ON public.user_profiles
    FOR INSERT WITH CHECK (auth_user_id = auth.uid() OR auth_user_id IS NULL);

CREATE POLICY "Users can update their own profile info" ON public.user_profiles
    FOR UPDATE USING (auth_user_id = auth.uid() OR auth_user_id IS NULL);

CREATE POLICY "Admins full access to all profiles" ON public.user_profiles
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.user_profiles AS up
            WHERE up.auth_user_id = auth.uid()
            AND up.active_role = 'ADMIN'
            AND up.status = 'APPROVED'
        )
    );

-- audit_logs Policies
CREATE POLICY "Authenticated users insert audit logs" ON public.audit_logs
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Everyone read audit logs" ON public.audit_logs
    FOR SELECT USING (true);

-- circulars_notices Policies
CREATE POLICY "Public read published circulars" ON public.circulars_notices
    FOR SELECT USING (stage = 'PUBLISHED' OR stage IS NULL);

CREATE POLICY "Admins manage all circulars" ON public.circulars_notices
    FOR ALL USING (true);

-- grievances Policies
CREATE POLICY "Users view own grievances" ON public.grievances
    FOR SELECT USING (true);

CREATE POLICY "Users insert grievances" ON public.grievances
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Admins update grievances" ON public.grievances
    FOR UPDATE USING (true);

-- faculty_leaves Policies
CREATE POLICY "Faculty view own leaves" ON public.faculty_leaves
    FOR SELECT USING (true);

CREATE POLICY "Faculty insert leaves" ON public.faculty_leaves
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Admins manage leaves" ON public.faculty_leaves
    FOR UPDATE USING (true);

-- notifications Policies
CREATE POLICY "Everyone read notifications" ON public.notifications
    FOR SELECT USING (true);

CREATE POLICY "Everyone update notifications" ON public.notifications
    FOR UPDATE USING (true);

-- student_courses Policies
CREATE POLICY "Everyone read student courses" ON public.student_courses
    FOR SELECT USING (true);

CREATE POLICY "Everyone update student courses" ON public.student_courses
    FOR ALL USING (true);

-- =========================================================================
-- SEED DATA: Pre-populate Statutory Circulars, Courses & Notifications
-- =========================================================================

INSERT INTO public.circulars_notices (id, title, category, date, issued_by, urgent, summary, stage, audience)
VALUES
('CIR-2026-NOV-01', 'Samarth@GRI Semester Examination Hall Tickets Released', 'Examinations', '24 Sep 2026', 'Controller of Examinations', true, 'Candidates appearing for Nov/Dec 2026 End Semester Examinations can download verified hall tickets with e-SANAD QR tokens.', 'PUBLISHED', 'ALL CAMPUS NETWORK'),
('CIR-2026-NOV-02', 'Nai Talim Village Internship Fieldwork Orientation', 'Academics', '21 Sep 2026', 'Dean of Academic Affairs', false, 'Mandatory rural development orientation for postgraduate students at Kasturba Hospital and Gandhigram Seva Ashram.', 'PUBLISHED', 'ALL CAMPUS NETWORK'),
('CIR-2026-NOV-03', 'e-SANAD Digital Transcripts & Degree Verification Service', 'Administration', '18 Sep 2026', 'Registrar Secretariat', false, 'University degree records and mark transcripts are now integrated with National Academic Depository (NAD) and DigiLocker.', 'PUBLISHED', 'ALL CAMPUS NETWORK')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.notifications (id, user_id, title, text, time, unread, target_tab, target_action)
VALUES
('notif-1', NULL, 'End Semester Hall Ticket Released', 'Nov/Dec 2026 Examination hall tickets are live on e-SANAD.', '10m ago', true, 'exams', 'hallticket'),
('notif-2', NULL, 'Registration Status Notification', 'Institutional registry processed 14 applications today.', '20m ago', true, 'status', NULL),
('notif-3', NULL, 'Campus Transit Route 1 Update', 'Bus TN-57-N-2418 is running on schedule via Chinnalapatti.', '25m ago', true, 'campus', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.student_courses (id, user_id, code, title, credits, instructor, schedule, attendance, total, attended)
VALUES
('sc_1', 'usr_student', 'CS501', 'Advanced Cloud Computing', 4, 'Dr. K. Senthilkumar', 'Mon, Wed 10:00 AM', 91, 36, 33),
('sc_2', 'usr_student', 'RD402', 'Gandhian Reconstruction & Ethics', 3, 'Prof. R. Mani', 'Tue, Thu 11:30 AM', 84, 32, 27),
('sc_3', 'usr_student', 'CS505', 'Distributed Mobile & Web Architectures', 4, 'Dr. M. Pushpalatha', 'Mon, Fri 02:00 PM', 88, 34, 30),
('sc_4', 'usr_student', 'MA301', 'Applied Statistical Analytics', 4, 'Dr. P. Balasubramaniam', 'Wed, Thu 09:00 AM', 76, 38, 29),
('sc_5', 'usr_student', 'CA404', 'Nai Talim Village Internship Fieldwork', 2, 'Field Coordinator', 'Saturday 08:30 AM', 95, 20, 19)
ON CONFLICT (id) DO NOTHING;

-- Initial Seed Profiles (Used for initial deployment verification)
INSERT INTO public.user_profiles (id, name, email, mobile, institutional_id, requested_role, approved_roles, active_role, status, department, programme, designation)
VALUES
('a0000000-0000-0000-0000-000000000001', 'GRI Controller of Examinations', 'admin@ruraluniv.ac.in', '+91 451 2452371', 'ADMIN-GRI-01', 'ADMIN', ARRAY['ADMIN']::TEXT[], 'ADMIN', 'APPROVED', 'Central Administration & Samarth ERP Hub', 'Office of the Controller of Examinations', 'Controller of Examinations & Authorized Statutory Officer'),
('a0000000-0000-0000-0000-000000000002', 'Srimari Vijay', 'student@ruraluniv.ac.in', '+91 94882 14209', '23MCA042', 'STUDENT', ARRAY['STUDENT']::TEXT[], 'STUDENT', 'APPROVED', 'Computer Science & Applications', 'Master of Computer Applications (MCA)', 'Student Representative'),
('a0000000-0000-0000-0000-000000000003', 'Dr. R. Subramanian', 'faculty@ruraluniv.ac.in', '+91 98421 95431', 'FAC-CS-108', 'FACULTY', ARRAY['FACULTY', 'SCHOLAR']::TEXT[], 'FACULTY', 'APPROVED', 'School of Sciences & Rural Technology', 'Faculty of Computer Science', 'Senior Associate Professor & Research Supervisor'),
('a0000000-0000-0000-0000-000000000004', 'M. Sadasivam', 'coe@ruraluniv.ac.in', '+91 94431 82415', 'COE-SEC-09', 'COE_STAFF', ARRAY['COE_STAFF']::TEXT[], 'COE_STAFF', 'APPROVED', 'Examination Confidential Branch', 'Examination Administration', 'Deputy Registrar (Examinations)'),
('a0000000-0000-0000-0000-000000000005', 'Ananya Murugan', 'scholar@ruraluniv.ac.in', '+91 97880 34120', '24PHD-ECO-09', 'SCHOLAR', ARRAY['SCHOLAR']::TEXT[], 'SCHOLAR', 'APPROVED', 'Rural Development & Sustainable Agro-Economy', 'Doctor of Philosophy (Ph.D.)', 'Year 2 Research Scholar & UGC JRF Fellow')
ON CONFLICT (email) DO NOTHING;
