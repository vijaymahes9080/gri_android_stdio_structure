-- =========================================================================
-- GANDHIGRAM RURAL INSTITUTE (GRI) MOBILE PORTAL 2026
-- Migration: 20261113000000_telegram_integration_and_activity_sync.sql
-- Description: Telegram Bot Integration with Role-Based Access Control (RBAC),
--              Username & Password Authentication, Link Tokens, Message Ledger,
--              Webhook Idempotency, Activity Logs & Notification Preferences.
-- =========================================================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- -------------------------------------------------------------------------
-- 1. Table: user_credentials (Institutional Authentication Ledger)
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.user_credentials (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id TEXT NOT NULL UNIQUE,
    username TEXT NOT NULL UNIQUE,
    email TEXT UNIQUE,
    password_hash TEXT NOT NULL,
    role TEXT NOT NULL DEFAULT 'STUDENT' CHECK (role IN ('STUDENT', 'FACULTY', 'COE_STAFF', 'SCHOLAR', 'ADMIN', 'SUPER_ADMIN', 'STAFF', 'GUEST')),
    is_active BOOLEAN NOT NULL DEFAULT true,
    failed_login_attempts INT NOT NULL DEFAULT 0,
    locked_until TIMESTAMPTZ,
    last_login_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_user_credentials_username ON public.user_credentials(username);
CREATE INDEX IF NOT EXISTS idx_user_credentials_email ON public.user_credentials(email);
CREATE INDEX IF NOT EXISTS idx_user_credentials_role ON public.user_credentials(role);

-- Seed default institutional credentials with SHA-256 hashed passwords (fallback/demo baseline)
-- Note: 'gri@2026' SHA-256: 785d1dcfc21ff21b333a948e4cf19d4586d6349ceeaeb7fec8fb7008aa22f77b
INSERT INTO public.user_credentials (user_id, username, email, password_hash, role)
VALUES
    ('2026GRI001', 'student1', 'student1@ruraluniv.ac.in', '785d1dcfc21ff21b333a948e4cf19d4586d6349ceeaeb7fec8fb7008aa22f77b', 'STUDENT'),
    ('2026FAC012', 'faculty1', 'faculty1@ruraluniv.ac.in', '785d1dcfc21ff21b333a948e4cf19d4586d6349ceeaeb7fec8fb7008aa22f77b', 'FACULTY'),
    ('2026COE005', 'coe1', 'coe@ruraluniv.ac.in', '785d1dcfc21ff21b333a948e4cf19d4586d6349ceeaeb7fec8fb7008aa22f77b', 'COE_STAFF'),
    ('2026ADM001', 'admin1', 'admin@ruraluniv.ac.in', '785d1dcfc21ff21b333a948e4cf19d4586d6349ceeaeb7fec8fb7008aa22f77b', 'ADMIN')
ON CONFLICT (user_id) DO NOTHING;

-- -------------------------------------------------------------------------
-- 2. Table: telegram_connections
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.telegram_connections (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id TEXT NOT NULL,
    telegram_user_id BIGINT NOT NULL UNIQUE,
    telegram_chat_id BIGINT NOT NULL,
    telegram_username TEXT,
    telegram_first_name TEXT,
    authenticated_role TEXT NOT NULL DEFAULT 'GUEST',
    is_authenticated BOOLEAN NOT NULL DEFAULT false,
    connection_status TEXT NOT NULL DEFAULT 'CONNECTED' CHECK (connection_status IN ('CONNECTED', 'DISCONNECTED', 'SUSPENDED')),
    linked_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    last_interaction_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    last_login_at TIMESTAMPTZ,
    disconnected_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_telegram_connections_user_id ON public.telegram_connections(user_id);
CREATE INDEX IF NOT EXISTS idx_telegram_connections_chat_id ON public.telegram_connections(telegram_chat_id);
CREATE INDEX IF NOT EXISTS idx_telegram_connections_status ON public.telegram_connections(connection_status);
CREATE INDEX IF NOT EXISTS idx_telegram_connections_auth ON public.telegram_connections(is_authenticated);

-- -------------------------------------------------------------------------
-- 3. Table: telegram_link_tokens
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.telegram_link_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id TEXT NOT NULL,
    token_hash TEXT NOT NULL UNIQUE,
    expires_at TIMESTAMPTZ NOT NULL,
    used_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_telegram_link_tokens_hash ON public.telegram_link_tokens(token_hash);
CREATE INDEX IF NOT EXISTS idx_telegram_link_tokens_user_id ON public.telegram_link_tokens(user_id);

-- -------------------------------------------------------------------------
-- 4. Table: telegram_messages
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.telegram_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id TEXT NOT NULL,
    telegram_connection_id UUID REFERENCES public.telegram_connections(id) ON DELETE CASCADE,
    telegram_message_id BIGINT,
    direction TEXT NOT NULL CHECK (direction IN ('INBOUND', 'OUTBOUND')),
    message_type TEXT NOT NULL DEFAULT 'TEXT' CHECK (message_type IN ('TEXT', 'COMMAND', 'NOTIFICATION', 'CALLBACK')),
    message_content TEXT NOT NULL,
    processing_status TEXT NOT NULL DEFAULT 'DELIVERED' CHECK (processing_status IN ('PENDING', 'DELIVERED', 'FAILED', 'RECEIVED')),
    error_message TEXT,
    sent_at TIMESTAMPTZ,
    received_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_telegram_messages_user_id ON public.telegram_messages(user_id);
CREATE INDEX IF NOT EXISTS idx_telegram_messages_conn_id ON public.telegram_messages(telegram_connection_id);
CREATE INDEX IF NOT EXISTS idx_telegram_messages_created_at ON public.telegram_messages(created_at DESC);

-- -------------------------------------------------------------------------
-- 5. Table: telegram_webhook_events
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.telegram_webhook_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    update_id BIGINT NOT NULL UNIQUE,
    event_type TEXT NOT NULL,
    raw_payload JSONB NOT NULL,
    processing_status TEXT NOT NULL DEFAULT 'PROCESSED' CHECK (processing_status IN ('PROCESSED', 'IGNORED', 'FAILED')),
    processing_error TEXT,
    processed_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_telegram_webhook_events_update_id ON public.telegram_webhook_events(update_id);

-- -------------------------------------------------------------------------
-- 6. Table: app_activity_logs (Centralized Institutional Activity Ledger)
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.app_activity_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id TEXT NOT NULL,
    action TEXT NOT NULL,
    module TEXT NOT NULL,
    entity_type TEXT,
    entity_id TEXT,
    metadata JSONB DEFAULT '{}'::jsonb,
    source TEXT NOT NULL DEFAULT 'FLUTTER_MOBILE',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_app_activity_logs_user_id ON public.app_activity_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_app_activity_logs_action ON public.app_activity_logs(action);
CREATE INDEX IF NOT EXISTS idx_app_activity_logs_created_at ON public.app_activity_logs(created_at DESC);

-- -------------------------------------------------------------------------
-- 7. Table: notification_preferences
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.notification_preferences (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id TEXT NOT NULL UNIQUE,
    telegram_enabled BOOLEAN NOT NULL DEFAULT true,
    circulars_enabled BOOLEAN NOT NULL DEFAULT true,
    exam_alerts_enabled BOOLEAN NOT NULL DEFAULT true,
    grievance_alerts_enabled BOOLEAN NOT NULL DEFAULT true,
    administrative_alerts_enabled BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_notification_prefs_user_id ON public.notification_preferences(user_id);

-- =========================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES — FAIL-CLOSED DATA ISOLATION
-- =========================================================================

ALTER TABLE public.user_credentials ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.telegram_connections ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.telegram_link_tokens ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.telegram_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.telegram_webhook_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.app_activity_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notification_preferences ENABLE ROW LEVEL SECURITY;

-- 1. user_credentials RLS (strictly confidential, only admins or user themselves)
CREATE POLICY "Admins or self manage credentials" ON public.user_credentials
    FOR SELECT USING (
        auth.uid() IS NOT NULL
        AND (
            user_id = auth.uid()::text
            OR EXISTS (
                SELECT 1 FROM public.user_profiles AS up
                WHERE up.auth_user_id = auth.uid()
                AND up.active_role IN ('ADMIN', 'SUPER_ADMIN')
                AND up.status = 'APPROVED'
            )
        )
    );

-- 2. telegram_connections RLS
CREATE POLICY "Users read own telegram connection" ON public.telegram_connections
    FOR SELECT USING (
        auth.uid() IS NOT NULL
        AND (
            user_id = auth.uid()::text
            OR EXISTS (
                SELECT 1 FROM public.user_profiles AS up
                WHERE up.auth_user_id = auth.uid()
                AND (up.institutional_id = telegram_connections.user_id OR up.id::text = telegram_connections.user_id)
            )
            OR EXISTS (
                SELECT 1 FROM public.user_profiles AS up
                WHERE up.auth_user_id = auth.uid()
                AND up.active_role IN ('ADMIN', 'SUPER_ADMIN')
                AND up.status = 'APPROVED'
            )
        )
    );

CREATE POLICY "Users update own telegram connection" ON public.telegram_connections
    FOR UPDATE USING (
        auth.uid() IS NOT NULL
        AND (
            user_id = auth.uid()::text
            OR EXISTS (
                SELECT 1 FROM public.user_profiles AS up
                WHERE up.auth_user_id = auth.uid()
                AND (up.institutional_id = telegram_connections.user_id OR up.id::text = telegram_connections.user_id)
            )
        )
    );

-- 3. telegram_link_tokens RLS
CREATE POLICY "Users manage own link tokens" ON public.telegram_link_tokens
    FOR ALL USING (
        auth.uid() IS NOT NULL
        AND (
            user_id = auth.uid()::text
            OR EXISTS (
                SELECT 1 FROM public.user_profiles AS up
                WHERE up.auth_user_id = auth.uid()
                AND (up.institutional_id = telegram_link_tokens.user_id OR up.id::text = telegram_link_tokens.user_id)
            )
        )
    );

-- 4. telegram_messages RLS
CREATE POLICY "Users view own telegram messages" ON public.telegram_messages
    FOR SELECT USING (
        auth.uid() IS NOT NULL
        AND (
            user_id = auth.uid()::text
            OR EXISTS (
                SELECT 1 FROM public.user_profiles AS up
                WHERE up.auth_user_id = auth.uid()
                AND (up.institutional_id = telegram_messages.user_id OR up.id::text = telegram_messages.user_id)
            )
            OR EXISTS (
                SELECT 1 FROM public.user_profiles AS up
                WHERE up.auth_user_id = auth.uid()
                AND up.active_role IN ('ADMIN', 'SUPER_ADMIN')
                AND up.status = 'APPROVED'
            )
        )
    );

CREATE POLICY "Users insert telegram messages" ON public.telegram_messages
    FOR INSERT WITH CHECK (
        auth.uid() IS NOT NULL
        AND (
            user_id = auth.uid()::text
            OR EXISTS (
                SELECT 1 FROM public.user_profiles AS up
                WHERE up.auth_user_id = auth.uid()
                AND (up.institutional_id = telegram_messages.user_id OR up.id::text = telegram_messages.user_id)
            )
        )
    );

-- 5. telegram_webhook_events RLS: strictly restricted to admins / service role
CREATE POLICY "Admins view webhook events" ON public.telegram_webhook_events
    FOR SELECT USING (
        auth.uid() IS NOT NULL
        AND EXISTS (
            SELECT 1 FROM public.user_profiles AS up
            WHERE up.auth_user_id = auth.uid()
            AND up.active_role IN ('ADMIN', 'SUPER_ADMIN')
            AND up.status = 'APPROVED'
        )
    );

-- 6. app_activity_logs RLS
CREATE POLICY "Users view own activity logs" ON public.app_activity_logs
    FOR SELECT USING (
        auth.uid() IS NOT NULL
        AND (
            user_id = auth.uid()::text
            OR EXISTS (
                SELECT 1 FROM public.user_profiles AS up
                WHERE up.auth_user_id = auth.uid()
                AND (up.institutional_id = app_activity_logs.user_id OR up.id::text = app_activity_logs.user_id)
            )
            OR EXISTS (
                SELECT 1 FROM public.user_profiles AS up
                WHERE up.auth_user_id = auth.uid()
                AND up.active_role IN ('ADMIN', 'SUPER_ADMIN')
                AND up.status = 'APPROVED'
            )
        )
    );

CREATE POLICY "Users insert own activity logs" ON public.app_activity_logs
    FOR INSERT WITH CHECK (
        auth.uid() IS NOT NULL
        AND (
            user_id = auth.uid()::text
            OR EXISTS (
                SELECT 1 FROM public.user_profiles AS up
                WHERE up.auth_user_id = auth.uid()
                AND (up.institutional_id = app_activity_logs.user_id OR up.id::text = app_activity_logs.user_id)
            )
        )
    );

-- 7. notification_preferences RLS
CREATE POLICY "Users manage own notification preferences" ON public.notification_preferences
    FOR ALL USING (
        auth.uid() IS NOT NULL
        AND (
            user_id = auth.uid()::text
            OR EXISTS (
                SELECT 1 FROM public.user_profiles AS up
                WHERE up.auth_user_id = auth.uid()
                AND (up.institutional_id = notification_preferences.user_id OR up.id::text = notification_preferences.user_id)
            )
        )
    );
