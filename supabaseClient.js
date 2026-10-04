// =========================================================================
// GANDHIGRAM RURAL INSTITUTE (GRI) MOBILE PORTAL 2026
// Supabase Cloud Backend Client & Service Layer
// =========================================================================

import { createClient } from '@supabase/supabase-js';

// Read Vite environment variables
const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || '';
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY || '';

// Validate whether real credentials have been configured
export const isSupabaseConfigured = Boolean(
  supabaseUrl &&
  supabaseAnonKey &&
  !supabaseUrl.includes('your-project-ref') &&
  !supabaseAnonKey.includes('placeholder')
);

// Instantiate client if configured, otherwise provide null
export const supabase = isSupabaseConfigured
  ? createClient(supabaseUrl, supabaseAnonKey, {
      auth: {
        persistSession: true,
        autoRefreshToken: true,
        detectSessionInUrl: true,
        storage: window.localStorage
      }
    })
  : null;

// Local fallback store keys
const LOCAL_STORAGE_KEYS = {
  PROFILES: 'gri_cloud_cache_profiles',
  AUDIT: 'gri_cloud_cache_audit',
  CIRCULARS: 'gri_cloud_cache_circulars',
  GRIEVANCES: 'gri_cloud_cache_grievances',
  LEAVES: 'gri_cloud_cache_leaves',
  NOTIFICATIONS: 'gri_cloud_cache_notifs',
  COURSES: 'gri_cloud_cache_courses'
};

function getLocalCache(key, fallback = []) {
  try {
    const raw = localStorage.getItem(key);
    return raw ? JSON.parse(raw) : fallback;
  } catch (e) {
    return fallback;
  }
}

function setLocalCache(key, data) {
  try {
    localStorage.setItem(key, JSON.stringify(data));
  } catch (e) {}
}

// =========================================================================
// AUTHENTICATION SERVICE
// =========================================================================

export async function signUpUser({ email, password, name, mobile, requestedRole, institutionalId, department, program }) {
  if (!isSupabaseConfigured) {
    // Offline / Local Simulation Mode
    const appId = `GRI-2026-APP-${Math.floor(1000 + Math.random() * 9000)}`;
    const newProfile = {
      id: `usr_${Date.now()}`,
      auth_user_id: `auth_${Date.now()}`,
      name,
      email,
      mobile,
      institutional_id: institutionalId || 'Pending',
      requested_role: requestedRole,
      approved_roles: [],
      active_role: 'GUEST',
      status: 'PENDING',
      application_id: appId,
      department: department || 'The Gandhigram Rural Institute',
      programme: program || 'Academic Programme',
      submitted_at: 'Just now',
      created_at: new Date().toISOString()
    };

    const cached = getLocalCache(LOCAL_STORAGE_KEYS.PROFILES, []);
    cached.unshift(newProfile);
    setLocalCache(LOCAL_STORAGE_KEYS.PROFILES, cached);

    await logAuditEntry({
      actorUserId: newProfile.id,
      actorName: `${name} (Applicant)`,
      targetUserId: name,
      action: 'REGISTRATION_SUBMITTED',
      previousStatus: 'NONE',
      newStatus: 'PENDING',
      remarks: `Submitted application for ${requestedRole}. Ref: ${appId}`
    });

    return { user: { id: newProfile.auth_user_id, email }, profile: newProfile, error: null };
  }

  // Real Supabase Authentication
  const { data: authData, error: authError } = await supabase.auth.signUp({
    email,
    password,
    options: {
      data: {
        name,
        requested_role: requestedRole
      }
    }
  });

  if (authError) {
    return { user: null, profile: null, error: authError };
  }

  const user = authData.user;
  if (!user) {
    return { user: null, profile: null, error: new Error('User creation did not return a valid record.') };
  }

  const appId = `GRI-2026-APP-${Math.floor(1000 + Math.random() * 9000)}`;

  // Insert profile record in public.user_profiles
  const profileRecord = {
    auth_user_id: user.id,
    name,
    email,
    mobile: mobile || null,
    institutional_id: institutionalId || null,
    requested_role: requestedRole,
    approved_roles: [],
    active_role: 'GUEST',
    status: 'PENDING',
    application_id: appId,
    department: department || 'The Gandhigram Rural Institute',
    programme: program || null
  };

  const { data: profileData, error: profileError } = await supabase
    .from('user_profiles')
    .insert([profileRecord])
    .select()
    .single();

  if (profileError) {
    console.error('Error creating user profile in Supabase:', profileError);
  }

  await logAuditEntry({
    actorUserId: user.id,
    actorName: `${name} (Applicant)`,
    targetUserId: name,
    action: 'REGISTRATION_SUBMITTED',
    previousStatus: 'NONE',
    newStatus: 'PENDING',
    remarks: `Submitted application for ${requestedRole}. Ref: ${appId}`
  });

  return { user, profile: profileData || profileRecord, error: null };
}

export async function signInUser(email, password) {
  if (!isSupabaseConfigured) {
    // Offline fallback lookup
    const cached = getLocalCache(LOCAL_STORAGE_KEYS.PROFILES, []);
    const match = cached.find(p => p.email?.toLowerCase() === email.toLowerCase());
    if (match) {
      return { user: { id: match.auth_user_id, email }, profile: match, error: null };
    }
    return { user: null, profile: null, error: new Error('Invalid credentials. Local profile not found.') };
  }

  const { data, error } = await supabase.auth.signInWithPassword({ email, password });
  if (error) {
    return { user: null, profile: null, error };
  }

  // Fetch full institutional profile
  const profile = await fetchUserProfile(data.user.id);
  return { user: data.user, profile, error: null };
}

export async function signOutUser() {
  if (isSupabaseConfigured) {
    await supabase.auth.signOut();
  }
}

export async function getCurrentSession() {
  if (!isSupabaseConfigured) return null;
  const { data } = await supabase.auth.getSession();
  return data.session;
}

export function onAuthStateChange(callback) {
  if (!isSupabaseConfigured) return { unsubscribe: () => {} };
  const { data } = supabase.auth.onAuthStateChange(callback);
  return data.subscription;
}

// =========================================================================
// PROFILE & APPLICATION SERVICE
// =========================================================================

export async function fetchUserProfile(authUserId) {
  if (!isSupabaseConfigured) {
    const cached = getLocalCache(LOCAL_STORAGE_KEYS.PROFILES, []);
    return cached.find(p => p.auth_user_id === authUserId) || null;
  }

  try {
    const { data, error } = await supabase
      .from('user_profiles')
      .select('*')
      .eq('auth_user_id', authUserId)
      .maybeSingle();

    if (error) {
      console.warn('Could not fetch user profile:', error.message);
      return null;
    }
    return data;
  } catch (err) {
    console.error('fetchUserProfile error:', err);
    return null;
  }
}

export async function fetchUserProfileByEmail(email) {
  if (!isSupabaseConfigured) {
    const cached = getLocalCache(LOCAL_STORAGE_KEYS.PROFILES, []);
    return cached.find(p => p.email?.toLowerCase() === email.toLowerCase()) || null;
  }

  try {
    const { data, error } = await supabase
      .from('user_profiles')
      .select('*')
      .ilike('email', email)
      .maybeSingle();

    if (error) return null;
    return data;
  } catch (err) {
    return null;
  }
}

export async function fetchPendingApplications() {
  if (!isSupabaseConfigured) {
    const cached = getLocalCache(LOCAL_STORAGE_KEYS.PROFILES, []);
    return cached.filter(p => p.status === 'PENDING' || p.status === 'UNDER_REVIEW');
  }

  try {
    const { data, error } = await supabase
      .from('user_profiles')
      .select('*')
      .in('status', ['PENDING', 'UNDER_REVIEW'])
      .order('created_at', { ascending: false });

    if (error) throw error;
    return data || [];
  } catch (err) {
    console.warn('Failed to load pending applications from Supabase:', err);
    return [];
  }
}

export async function updateApplicationDecision(profileId, { status, approvedRole, reviewerName, rejectionReason, infoRequested }) {
  const updates = {
    status,
    updated_at: new Date().toISOString()
  };

  if (status === 'APPROVED') {
    updates.approved_roles = [approvedRole];
    updates.active_role = approvedRole;
    updates.approved_by = reviewerName || 'Dean Secretariat';
    updates.approved_at = new Date().toISOString();
  } else if (status === 'REJECTED') {
    updates.rejection_reason = rejectionReason;
  } else if (status === 'UNDER_REVIEW') {
    updates.info_requested = infoRequested;
  }

  if (!isSupabaseConfigured) {
    const cached = getLocalCache(LOCAL_STORAGE_KEYS.PROFILES, []);
    const idx = cached.findIndex(p => p.id === profileId || p.application_id === profileId);
    if (idx !== -1) {
      Object.assign(cached[idx], updates);
      setLocalCache(LOCAL_STORAGE_KEYS.PROFILES, cached);
      return { data: cached[idx], error: null };
    }
    return { data: null, error: new Error('Profile not found in local cache') };
  }

  try {
    const { data, error } = await supabase
      .from('user_profiles')
      .update(updates)
      .eq('id', profileId)
      .select()
      .single();

    return { data, error };
  } catch (err) {
    return { data: null, error: err };
  }
}

export async function submitApplicantClarification(profileId, responseText) {
  const updates = {
    info_provided: responseText,
    status: 'UNDER_REVIEW',
    updated_at: new Date().toISOString()
  };

  if (!isSupabaseConfigured) {
    const cached = getLocalCache(LOCAL_STORAGE_KEYS.PROFILES, []);
    const target = cached.find(p => p.id === profileId);
    if (target) Object.assign(target, updates);
    setLocalCache(LOCAL_STORAGE_KEYS.PROFILES, cached);
    return { error: null };
  }

  return await supabase
    .from('user_profiles')
    .update(updates)
    .eq('id', profileId);
}

// =========================================================================
// AUDIT LOG SERVICE
// =========================================================================

export async function logAuditEntry({ actorUserId, actorName, targetUserId, action, previousStatus, newStatus, remarks }) {
  const record = {
    id: `aud_${Date.now()}_${Math.floor(Math.random() * 1000)}`,
    actor_user_id: actorUserId || 'SYSTEM',
    actor_name: actorName || 'Central Registry',
    target_user_id: targetUserId || null,
    action,
    previous_status: previousStatus || null,
    new_status: newStatus || null,
    remarks: remarks || '',
    created_at: new Date().toISOString()
  };

  if (!isSupabaseConfigured) {
    const cached = getLocalCache(LOCAL_STORAGE_KEYS.AUDIT, []);
    cached.unshift(record);
    setLocalCache(LOCAL_STORAGE_KEYS.AUDIT, cached);
    return record;
  }

  try {
    await supabase.from('audit_logs').insert([record]);
  } catch (e) {
    console.warn('Audit log insert failed:', e);
  }
  return record;
}

export async function fetchAuditLogs(limit = 30) {
  if (!isSupabaseConfigured) {
    return getLocalCache(LOCAL_STORAGE_KEYS.AUDIT, []);
  }

  try {
    const { data, error } = await supabase
      .from('audit_logs')
      .select('*')
      .order('created_at', { ascending: false })
      .limit(limit);

    if (error) throw error;
    return data || [];
  } catch (err) {
    return getLocalCache(LOCAL_STORAGE_KEYS.AUDIT, []);
  }
}

// =========================================================================
// CIRCULARS & NOTICES SERVICE
// =========================================================================

export async function fetchPublishedCirculars() {
  if (!isSupabaseConfigured) {
    return getLocalCache(LOCAL_STORAGE_KEYS.CIRCULARS, []);
  }

  try {
    const { data, error } = await supabase
      .from('circulars_notices')
      .select('*')
      .eq('stage', 'PUBLISHED')
      .order('created_at', { ascending: false });

    if (error) throw error;
    return data || [];
  } catch (err) {
    return getLocalCache(LOCAL_STORAGE_KEYS.CIRCULARS, []);
  }
}

export async function createCircularNotice(notice) {
  const record = {
    id: notice.id || `CIR-${Date.now()}`,
    title: notice.title,
    category: notice.category,
    date: notice.date || 'Just now',
    issued_by: notice.issuedBy,
    urgent: Boolean(notice.urgent),
    summary: notice.summary,
    stage: notice.stage || 'PUBLISHED',
    audience: notice.audience || 'ALL CAMPUS NETWORK',
    doc_url: notice.docUrl || null,
    created_at: new Date().toISOString()
  };

  if (!isSupabaseConfigured) {
    const cached = getLocalCache(LOCAL_STORAGE_KEYS.CIRCULARS, []);
    cached.unshift(record);
    setLocalCache(LOCAL_STORAGE_KEYS.CIRCULARS, cached);
    return record;
  }

  const { data, error } = await supabase
    .from('circulars_notices')
    .insert([record])
    .select()
    .single();

  if (error) throw error;
  return data;
}

// =========================================================================
// GRIEVANCES (GRI-CARE) SERVICE
// =========================================================================

export async function fetchUserGrievances(userId) {
  if (!isSupabaseConfigured) {
    return getLocalCache(LOCAL_STORAGE_KEYS.GRIEVANCES, []);
  }

  try {
    const { data, error } = await supabase
      .from('grievances')
      .select('*')
      .order('created_at', { ascending: false });

    if (error) throw error;
    return data || [];
  } catch (err) {
    return getLocalCache(LOCAL_STORAGE_KEYS.GRIEVANCES, []);
  }
}

export async function submitGrievanceTicket(ticket) {
  const record = {
    id: ticket.id || `GRI-2026-TKT-${Math.floor(1000 + Math.random() * 9000)}`,
    user_id: ticket.userId || 'usr_anonymous',
    user_name: ticket.userName || 'Student',
    category: ticket.category,
    subject: ticket.subject,
    description: ticket.description || ticket.subject,
    date: 'Just now',
    status: 'SUBMITTED',
    remarks: 'Acknowledged by Care Cell. Assigned to section officer.',
    created_at: new Date().toISOString()
  };

  if (!isSupabaseConfigured) {
    const cached = getLocalCache(LOCAL_STORAGE_KEYS.GRIEVANCES, []);
    cached.unshift(record);
    setLocalCache(LOCAL_STORAGE_KEYS.GRIEVANCES, cached);
    return record;
  }

  const { data, error } = await supabase
    .from('grievances')
    .insert([record])
    .select()
    .single();

  if (error) throw error;
  return data;
}

// =========================================================================
// FACULTY LEAVES SERVICE
// =========================================================================

export async function fetchFacultyLeaves(userId) {
  if (!isSupabaseConfigured) {
    return getLocalCache(LOCAL_STORAGE_KEYS.LEAVES, []);
  }

  try {
    const { data, error } = await supabase
      .from('faculty_leaves')
      .select('*')
      .order('created_at', { ascending: false });

    if (error) throw error;
    return data || [];
  } catch (err) {
    return getLocalCache(LOCAL_STORAGE_KEYS.LEAVES, []);
  }
}

export async function submitFacultyLeaveApplication(leave) {
  const record = {
    id: `leave_${Date.now()}`,
    user_id: leave.userId || 'usr_faculty',
    faculty_name: leave.facultyName || 'Faculty Member',
    type: leave.type,
    dates: leave.dates,
    days: leave.days || 1,
    reason: leave.reason,
    status: 'PENDING_HOD',
    created_at: new Date().toISOString()
  };

  if (!isSupabaseConfigured) {
    const cached = getLocalCache(LOCAL_STORAGE_KEYS.LEAVES, []);
    cached.unshift(record);
    setLocalCache(LOCAL_STORAGE_KEYS.LEAVES, cached);
    return record;
  }

  const { data, error } = await supabase
    .from('faculty_leaves')
    .insert([record])
    .select()
    .single();

  if (error) throw error;
  return data;
}

// =========================================================================
// NOTIFICATIONS SERVICE
// =========================================================================

export async function fetchNotifications() {
  if (!isSupabaseConfigured) {
    return getLocalCache(LOCAL_STORAGE_KEYS.NOTIFICATIONS, []);
  }

  try {
    const { data, error } = await supabase
      .from('notifications')
      .select('*')
      .order('created_at', { ascending: false });

    if (error) throw error;
    return data || [];
  } catch (err) {
    return getLocalCache(LOCAL_STORAGE_KEYS.NOTIFICATIONS, []);
  }
}

export async function markAllNotificationsAsRead() {
  if (!isSupabaseConfigured) {
    const cached = getLocalCache(LOCAL_STORAGE_KEYS.NOTIFICATIONS, []);
    cached.forEach(n => n.unread = false);
    setLocalCache(LOCAL_STORAGE_KEYS.NOTIFICATIONS, cached);
    return;
  }

  try {
    await supabase
      .from('notifications')
      .update({ unread: false })
      .neq('id', '___none___');
  } catch (err) {
    console.warn('markAllNotificationsAsRead error:', err);
  }
}

// =========================================================================
// REAL-TIME SUBSCRIPTION HELPERS
// =========================================================================

export function subscribeToTableChanges(tableName, onInsertOrUpdate) {
  if (!isSupabaseConfigured) return null;

  return supabase
    .channel(`public:${tableName}`)
    .on('postgres_changes', { event: '*', schema: 'public', table: tableName }, payload => {
      onInsertOrUpdate(payload);
    })
    .subscribe();
}
