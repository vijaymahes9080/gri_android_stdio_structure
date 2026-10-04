-- =========================================================================
-- GANDHIGRAM RURAL INSTITUTE (GRI) MOBILE PORTAL 2026
-- Supabase Cloud Migration: Official GRI Institutional Content Schema
-- Source of Truth: https://www.ruraluniv.ac.in/
-- =========================================================================

-- Enable pgcrypto for UUID and hash functions
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- -------------------------------------------------------------------------
-- 1. Table: schools
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.schools (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    dean TEXT NOT NULL,
    dean_email TEXT,
    dean_phone TEXT,
    programmes_count INTEGER DEFAULT 0,
    highlights TEXT,
    source_url TEXT NOT NULL,
    source_domain TEXT DEFAULT 'ruraluniv.ac.in',
    source_type TEXT DEFAULT 'OFFICIAL_WEB',
    source_last_checked TIMESTAMPTZ DEFAULT now(),
    imported_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    content_hash TEXT UNIQUE,
    status TEXT DEFAULT 'PUBLISHED'
);

-- -------------------------------------------------------------------------
-- 2. Table: departments
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.departments (
    id TEXT PRIMARY KEY,
    school_id TEXT REFERENCES public.schools(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    hod_name TEXT,
    hod_email TEXT,
    contact_phone TEXT,
    programmes_offered TEXT[],
    overview TEXT,
    image_url TEXT,
    source_url TEXT NOT NULL,
    source_domain TEXT DEFAULT 'ruraluniv.ac.in',
    source_type TEXT DEFAULT 'OFFICIAL_WEB',
    source_last_checked TIMESTAMPTZ DEFAULT now(),
    imported_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    content_hash TEXT UNIQUE,
    status TEXT DEFAULT 'PUBLISHED'
);

-- -------------------------------------------------------------------------
-- 3. Table: programmes
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.programmes (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    school_id TEXT REFERENCES public.schools(id) ON DELETE SET NULL,
    department_id TEXT REFERENCES public.departments(id) ON DELETE SET NULL,
    level TEXT NOT NULL CHECK (level IN ('UG', 'PG', 'Diploma', 'PG Diploma', 'Doctoral', 'Post-Doc', 'Certificate')),
    duration TEXT NOT NULL,
    eligibility TEXT NOT NULL,
    cuet_code TEXT,
    intake INTEGER,
    prospectus_url TEXT,
    is_featured BOOLEAN DEFAULT false,
    source_url TEXT NOT NULL,
    source_domain TEXT DEFAULT 'ruraluniv.ac.in',
    source_type TEXT DEFAULT 'OFFICIAL_WEB',
    source_last_checked TIMESTAMPTZ DEFAULT now(),
    imported_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    content_hash TEXT UNIQUE,
    status TEXT DEFAULT 'CURRENT'
);

-- -------------------------------------------------------------------------
-- 4. Table: events
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.events (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    date TEXT NOT NULL,
    end_date TEXT,
    venue TEXT NOT NULL,
    category TEXT NOT NULL,
    organizer TEXT,
    description TEXT,
    banner_url TEXT,
    circular_url TEXT,
    is_featured BOOLEAN DEFAULT false,
    source_url TEXT NOT NULL,
    source_domain TEXT DEFAULT 'ruraluniv.ac.in',
    source_type TEXT DEFAULT 'OFFICIAL_WEB',
    source_last_checked TIMESTAMPTZ DEFAULT now(),
    imported_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    content_hash TEXT UNIQUE,
    status TEXT DEFAULT 'UPCOMING'
);

-- -------------------------------------------------------------------------
-- 5. Table: careers (Recruitment Advertisements & Notifications)
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.careers (
    id TEXT PRIMARY KEY,
    notification_no TEXT,
    title TEXT NOT NULL,
    post_type TEXT NOT NULL CHECK (post_type IN ('Teaching', 'Non-Teaching', 'Project Fellow', 'Contractual', 'Guest Faculty')),
    department TEXT,
    num_positions INTEGER DEFAULT 1,
    closing_date TEXT NOT NULL,
    qualification TEXT,
    application_pdf_url TEXT,
    general_instructions_url TEXT,
    is_active BOOLEAN DEFAULT true,
    source_url TEXT NOT NULL,
    source_domain TEXT DEFAULT 'ruraluniv.ac.in',
    source_type TEXT DEFAULT 'OFFICIAL_WEB',
    source_last_checked TIMESTAMPTZ DEFAULT now(),
    imported_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    content_hash TEXT UNIQUE,
    status TEXT DEFAULT 'CURRENT'
);

-- -------------------------------------------------------------------------
-- 6. Table: tenders (Public Procurement & Works)
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.tenders (
    id TEXT PRIMARY KEY,
    tender_ref TEXT NOT NULL,
    title TEXT NOT NULL,
    department TEXT,
    tender_value TEXT,
    published_date TEXT NOT NULL,
    closing_date TEXT NOT NULL,
    opening_date TEXT,
    tender_doc_url TEXT,
    corrigendum_url TEXT,
    source_url TEXT NOT NULL,
    source_domain TEXT DEFAULT 'ruraluniv.ac.in',
    source_type TEXT DEFAULT 'OFFICIAL_WEB',
    source_last_checked TIMESTAMPTZ DEFAULT now(),
    imported_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    content_hash TEXT UNIQUE,
    status TEXT DEFAULT 'CURRENT'
);

-- -------------------------------------------------------------------------
-- 7. Table: scholarships
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.scholarships (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    provider TEXT NOT NULL,
    category TEXT NOT NULL,
    award_amount TEXT NOT NULL,
    academic_year TEXT DEFAULT '2026-2027',
    eligibility TEXT NOT NULL,
    deadline TEXT,
    apply_url TEXT,
    guidelines_pdf_url TEXT,
    is_featured BOOLEAN DEFAULT false,
    source_url TEXT NOT NULL,
    source_domain TEXT DEFAULT 'ruraluniv.ac.in',
    source_type TEXT DEFAULT 'OFFICIAL_WEB',
    source_last_checked TIMESTAMPTZ DEFAULT now(),
    imported_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    content_hash TEXT UNIQUE,
    status TEXT DEFAULT 'OPEN'
);

-- -------------------------------------------------------------------------
-- 8. Table: examinations
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.examinations (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    category TEXT NOT NULL CHECK (category IN ('Timetable', 'Result', 'Tatkal', 'e-SANAD', 'Transcript', 'Regulations')),
    session TEXT NOT NULL,
    publish_date TEXT NOT NULL,
    doc_url TEXT,
    description TEXT,
    is_urgent BOOLEAN DEFAULT false,
    source_url TEXT NOT NULL,
    source_domain TEXT DEFAULT 'ruraluniv.ac.in',
    source_type TEXT DEFAULT 'OFFICIAL_WEB',
    source_last_checked TIMESTAMPTZ DEFAULT now(),
    imported_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    content_hash TEXT UNIQUE,
    status TEXT DEFAULT 'CURRENT'
);

-- -------------------------------------------------------------------------
-- 9. Table: documents_repository
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.documents_repository (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    category TEXT NOT NULL,
    department TEXT NOT NULL,
    date TEXT NOT NULL,
    academic_year TEXT,
    doc_type TEXT NOT NULL,
    doc_url TEXT NOT NULL,
    file_size TEXT,
    sha256 TEXT,
    audience TEXT DEFAULT 'Universal',
    source_url TEXT NOT NULL,
    source_domain TEXT DEFAULT 'ruraluniv.ac.in',
    source_type TEXT DEFAULT 'OFFICIAL_WEB',
    source_last_checked TIMESTAMPTZ DEFAULT now(),
    imported_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    content_hash TEXT UNIQUE,
    status TEXT DEFAULT 'CURRENT'
);

-- -------------------------------------------------------------------------
-- 10. Table: facilities (Campus Infrastructure & Facilities)
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.facilities (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    image_url TEXT,
    badge TEXT,
    description TEXT NOT NULL,
    stats JSONB DEFAULT '[]'::JSONB,
    features TEXT[],
    contact TEXT,
    source_url TEXT NOT NULL,
    source_domain TEXT DEFAULT 'ruraluniv.ac.in',
    source_type TEXT DEFAULT 'OFFICIAL_WEB',
    source_last_checked TIMESTAMPTZ DEFAULT now(),
    imported_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    content_hash TEXT UNIQUE,
    status TEXT DEFAULT 'CURRENT'
);

-- -------------------------------------------------------------------------
-- 11. Table: media_gallery (Official Campus Images & Archives)
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.media_gallery (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    category TEXT NOT NULL,
    image_url TEXT NOT NULL,
    thumbnail_url TEXT,
    caption TEXT,
    photographer TEXT,
    date_taken TEXT,
    is_featured BOOLEAN DEFAULT false,
    source_url TEXT NOT NULL,
    source_domain TEXT DEFAULT 'ruraluniv.ac.in',
    source_type TEXT DEFAULT 'OFFICIAL_WEB',
    source_last_checked TIMESTAMPTZ DEFAULT now(),
    imported_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    content_hash TEXT UNIQUE,
    status TEXT DEFAULT 'PUBLISHED'
);

-- -------------------------------------------------------------------------
-- 12. Table: video_gallery (Official Convocations, Documentaries & Lectures)
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.video_gallery (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    category TEXT NOT NULL,
    video_url TEXT NOT NULL,
    thumbnail_url TEXT,
    duration TEXT,
    provider TEXT DEFAULT 'youtube' CHECK (provider IN ('youtube', 'direct', 'vimeo')),
    description TEXT,
    is_featured BOOLEAN DEFAULT false,
    source_url TEXT NOT NULL,
    source_domain TEXT DEFAULT 'ruraluniv.ac.in',
    source_type TEXT DEFAULT 'OFFICIAL_WEB',
    source_last_checked TIMESTAMPTZ DEFAULT now(),
    imported_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    content_hash TEXT UNIQUE,
    status TEXT DEFAULT 'PUBLISHED'
);

-- -------------------------------------------------------------------------
-- 13. Table: contacts (Official Directory & Extension Directory)
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.contacts (
    id TEXT PRIMARY KEY,
    office_name TEXT NOT NULL,
    officer_name TEXT,
    designation TEXT NOT NULL,
    phone_direct TEXT,
    phone_ext TEXT,
    email TEXT,
    location TEXT,
    category TEXT NOT NULL,
    source_url TEXT NOT NULL,
    source_domain TEXT DEFAULT 'ruraluniv.ac.in',
    source_type TEXT DEFAULT 'OFFICIAL_WEB',
    source_last_checked TIMESTAMPTZ DEFAULT now(),
    imported_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    content_hash TEXT UNIQUE,
    status TEXT DEFAULT 'CURRENT'
);

-- -------------------------------------------------------------------------
-- 14. Table: important_links (Official Portals & External Systems)
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.important_links (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    url TEXT NOT NULL,
    category TEXT NOT NULL,
    description TEXT,
    is_external BOOLEAN DEFAULT true,
    source_url TEXT NOT NULL,
    source_domain TEXT DEFAULT 'ruraluniv.ac.in',
    source_type TEXT DEFAULT 'OFFICIAL_WEB',
    source_last_checked TIMESTAMPTZ DEFAULT now(),
    imported_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    content_hash TEXT UNIQUE,
    status TEXT DEFAULT 'CURRENT'
);

-- -------------------------------------------------------------------------
-- 15. Table: official_sync_logs (Sync Audit & Freshness Ledger)
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.official_sync_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    synced_by TEXT NOT NULL,
    source_domain TEXT DEFAULT 'ruraluniv.ac.in',
    records_synced INTEGER DEFAULT 0,
    records_updated INTEGER DEFAULT 0,
    records_inserted INTEGER DEFAULT 0,
    status TEXT NOT NULL,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexing for High-Performance Queries
CREATE INDEX IF NOT EXISTS idx_programmes_level ON public.programmes(level);
CREATE INDEX IF NOT EXISTS idx_programmes_school ON public.programmes(school_id);
CREATE INDEX IF NOT EXISTS idx_events_date ON public.events(date);
CREATE INDEX IF NOT EXISTS idx_careers_closing ON public.careers(closing_date);
CREATE INDEX IF NOT EXISTS idx_tenders_closing ON public.tenders(closing_date);
CREATE INDEX IF NOT EXISTS idx_scholarships_category ON public.scholarships(category);
CREATE INDEX IF NOT EXISTS idx_docs_category ON public.documents_repository(category);
CREATE INDEX IF NOT EXISTS idx_media_category ON public.media_gallery(category);
CREATE INDEX IF NOT EXISTS idx_video_category ON public.video_gallery(category);

-- Enable Row Level Security (RLS) on all official content tables
ALTER TABLE public.schools ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.departments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.programmes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.careers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tenders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.scholarships ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.examinations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.documents_repository ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.facilities ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.media_gallery ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.video_gallery ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.contacts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.important_links ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.official_sync_logs ENABLE ROW LEVEL SECURITY;

-- Universal Read Policies for Public Official Content
DO $$
DECLARE
    tbl text;
BEGIN
    FOR tbl IN 
        SELECT tablename FROM pg_tables 
        WHERE schemaname = 'public' 
        AND tablename IN (
            'schools', 'departments', 'programmes', 'events', 'careers', 
            'tenders', 'scholarships', 'examinations', 'documents_repository', 
            'facilities', 'media_gallery', 'video_gallery', 'contacts', 
            'important_links', 'official_sync_logs'
        )
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS "Public Read Access" ON public.%I;', tbl);
        EXECUTE format('CREATE POLICY "Public Read Access" ON public.%I FOR SELECT USING (true);', tbl);
        
        EXECUTE format('DROP POLICY IF EXISTS "Admin Full Access" ON public.%I;', tbl);
        EXECUTE format('CREATE POLICY "Admin Full Access" ON public.%I FOR ALL USING (
            auth.role() = ''authenticated''
        );', tbl);
    END LOOP;
END $$;
