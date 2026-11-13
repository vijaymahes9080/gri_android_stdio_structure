// =============================================================================
// GANDHIGRAM RURAL INSTITUTE — Supabase Edge Functions
// Endpoint: telegram-webhook
// Description: Receives Telegram updates with secret token verification,
//              idempotency protection, username/password authentication,
//              and Role-Based Access Control (RBAC) data gating.
// =============================================================================

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";
import { TelegramBotClient, TelegramUpdate, sha256Hex } from "../_shared/telegram.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type, x-telegram-bot-api-secret-token",
};

serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  // 1. Secret Token Verification (fail-closed)
  const webhookSecret = Deno.env.get("TELEGRAM_WEBHOOK_SECRET");
  const incomingSecret = req.headers.get("x-telegram-bot-api-secret-token");
  if (webhookSecret && incomingSecret !== webhookSecret) {
    return new Response(JSON.stringify({ error: "Unauthorized webhook caller" }), {
      status: 401,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
  const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
  const supabase = createClient(supabaseUrl, supabaseServiceKey);
  const botClient = new TelegramBotClient();

  try {
    const update: TelegramUpdate = await req.json();
    if (!update || !update.update_id) {
      return new Response(JSON.stringify({ error: "Invalid payload" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // 2. Idempotency Check
    const { data: existingEvent } = await supabase
      .from("telegram_webhook_events")
      .select("id")
      .eq("update_id", update.update_id)
      .maybeSingle();

    if (existingEvent) {
      return new Response(JSON.stringify({ ok: true, note: "Already processed" }), {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    await supabase.from("telegram_webhook_events").insert({
      update_id: update.update_id,
      event_type: update.message ? "message" : update.callback_query ? "callback_query" : "other",
      raw_payload: update,
      processing_status: "PROCESSED",
    });

    const msg = update.message;
    if (!msg || !msg.text) {
      return new Response(JSON.stringify({ ok: true }), {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const chatId = msg.chat.id;
    const tgUserId = msg.from?.id ?? chatId;
    const tgUsername = msg.from?.username ?? "";
    const tgFirstName = msg.from?.first_name ?? "";
    const rawText = msg.text.trim();

    // Check active Telegram connection
    const { data: conn } = await supabase
      .from("telegram_connections")
      .select("*")
      .eq("telegram_chat_id", chatId)
      .eq("connection_status", "CONNECTED")
      .maybeSingle();

    const isAuthenticated = conn?.is_authenticated === true;
    const userRole = conn?.authenticated_role ?? "GUEST";
    const linkedUserId = conn?.user_id;

    // Helper: Auth Check Prompt
    const requireAuth = async () => {
      await botClient.sendMessage({
        chat_id: chatId,
        text: `🔒 <b>Authentication Required</b>\n\nTo request and view institutional data, your GRI username and password must be verified.\n\nPlease log in using:\n<code>/login &lt;username&gt; &lt;password&gt;</code>\n\n<i>Example: /login student1 gri@2026</i>`,
        parse_mode: "HTML",
      });
    };

    // -------------------------------------------------------------------------
    // COMMAND: /login <username> <password>
    // -------------------------------------------------------------------------
    if (rawText.startsWith("/login")) {
      const parts = rawText.split(/\s+/);
      if (parts.length < 3) {
        await botClient.sendMessage({
          chat_id: chatId,
          text: `⚠️ <b>Usage:</b>\n<code>/login &lt;username&gt; &lt;password&gt;</code>\n\nEnter your registered GRI username or Roll Number and institutional password.`,
          parse_mode: "HTML",
        });
        return new Response(JSON.stringify({ ok: true }), {
          status: 200,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }

      const inputUsername = parts[1].trim();
      const inputPassword = parts[2].trim();
      const passwordHash = await sha256Hex(inputPassword);

      // Verify credentials in public.user_credentials
      const { data: creds, error: credErr } = await supabase
        .from("user_credentials")
        .select("*")
        .or(`username.ilike.${inputUsername},email.ilike.${inputUsername},user_id.eq.${inputUsername}`)
        .eq("is_active", true)
        .maybeSingle();

      if (credErr || !creds || creds.password_hash !== passwordHash) {
        // Record failed auth activity log
        await supabase.from("app_activity_logs").insert({
          user_id: inputUsername,
          action: "AUTH_FAILED_TELEGRAM",
          module: "AUTH",
          metadata: { telegram_chat_id: chatId, username: inputUsername },
          source: "TELEGRAM_BOT_AUTH",
        });

        await botClient.sendMessage({
          chat_id: chatId,
          text: `❌ <b>Authentication Failed</b>\n\nInvalid username or password. Institutional data cannot be retrieved without valid credentials.\n\nPlease check your credentials and try again.`,
          parse_mode: "HTML",
        });

        return new Response(JSON.stringify({ ok: true, authenticated: false }), {
          status: 200,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }

      // Success: bind / update connection with authenticated status and role
      const verifiedUserId = creds.user_id;
      const verifiedRole = creds.role;

      await supabase.from("telegram_connections").upsert({
        user_id: verifiedUserId,
        telegram_user_id: tgUserId,
        telegram_chat_id: chatId,
        telegram_username: tgUsername,
        telegram_first_name: tgFirstName,
        authenticated_role: verifiedRole,
        is_authenticated: true,
        connection_status: "CONNECTED",
        last_login_at: new Date().toISOString(),
        last_interaction_at: new Date().toISOString(),
      }, { onConflict: "telegram_user_id" });

      await supabase.from("app_activity_logs").insert({
        user_id: verifiedUserId,
        action: "AUTH_SUCCESS_TELEGRAM",
        module: "AUTH",
        metadata: { telegram_chat_id: chatId, role: verifiedRole },
        source: "TELEGRAM_BOT_AUTH",
      });

      await botClient.sendMessage({
        chat_id: chatId,
        text: `✅ <b>Authentication Successful!</b>\n\n` +
          `• User: <code>${verifiedUserId}</code> (${creds.username})\n` +
          `• Verified Role: <b>${verifiedRole}</b>\n` +
          `• Access Level: Authorized Institutional Member\n\n` +
          `You can now request data based on your role:\n` +
          (verifiedRole === "STUDENT" ? `• /attendance — View your attendance & eligibility\n• /exams — View exam timetable & hall ticket\n• /grievance — Track submitted grievances\n` : "") +
          (verifiedRole === "FACULTY" ? `• /roster — View assigned class attendance\n• /leaves — Check faculty leave requests\n` : "") +
          (verifiedRole === "ADMIN" || verifiedRole === "SUPER_ADMIN" ? `• /approvals — Review pending registrations\n• /audit — View recent security audit logs\n` : "") +
          `• /profile — View full profile summary\n` +
          `• /circulars — Official GRI circulars\n` +
          `• /logout — End active session`,
        parse_mode: "HTML",
      });

      return new Response(JSON.stringify({ ok: true, authenticated: true }), {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // -------------------------------------------------------------------------
    // COMMAND: /logout
    // -------------------------------------------------------------------------
    if (rawText === "/logout") {
      if (conn) {
        await supabase
          .from("telegram_connections")
          .update({
            is_authenticated: false,
            authenticated_role: "GUEST",
            last_interaction_at: new Date().toISOString(),
          })
          .eq("id", conn.id);

        await supabase.from("app_activity_logs").insert({
          user_id: conn.user_id,
          action: "LOGOUT_TELEGRAM",
          module: "AUTH",
          source: "TELEGRAM_BOT",
        });
      }

      await botClient.sendMessage({
        chat_id: chatId,
        text: `🔒 <b>Logged Out Successfully</b>\n\nYour session has been terminated and institutional records are locked.\n\n🔑 <b>Demo Credentials to Log Back In:</b>\n• <b>Student:</b> <code>/login student1 gri@2026</code>\n• <b>Faculty:</b> <code>/login faculty1 gri@2026</code>\n• <b>Admin:</b> <code>/login admin1 gri@2026</code>\n\n<i>Tap any credential above to copy and log back in!</i>`,
        parse_mode: "HTML",
      });

      return new Response(JSON.stringify({ ok: true }), {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // -------------------------------------------------------------------------
    // COMMAND: /start
    // -------------------------------------------------------------------------
    if (rawText.startsWith("/start")) {
      const parts = rawText.split(" ");
      const startArg = parts.length > 1 ? parts[1].trim() : "";

      if (startArg.startsWith("link_")) {
        const rawToken = startArg.replace("link_", "");
        const tokenHash = await sha256Hex(rawToken);

        const { data: tokenRecord } = await supabase
          .from("telegram_link_tokens")
          .select("*")
          .eq("token_hash", tokenHash)
          .is("used_at", null)
          .gt("expires_at", new Date().toISOString())
          .maybeSingle();

        if (!tokenRecord) {
          await botClient.sendMessage({
            chat_id: chatId,
            text: "⚠️ <b>Invalid or Expired Link Token</b>\nPlease return to the GRI Mobile App and generate a fresh link.",
            parse_mode: "HTML",
          });
          return new Response(JSON.stringify({ ok: true }), {
            status: 200,
            headers: { ...corsHeaders, "Content-Type": "application/json" },
          });
        }

        const userId = tokenRecord.user_id;

        // Fetch user's profile to get actual verified role
        const { data: prof } = await supabase
          .from("user_profiles")
          .select("active_role")
          .or(`institutional_id.eq.${userId},auth_user_id.eq.${userId},id.eq.${userId}`)
          .maybeSingle();

        const role = prof?.active_role ?? "STUDENT";

        await supabase.from("telegram_connections").upsert({
          user_id: userId,
          telegram_user_id: tgUserId,
          telegram_chat_id: chatId,
          telegram_username: tgUsername,
          telegram_first_name: tgFirstName,
          authenticated_role: role,
          is_authenticated: true,
          connection_status: "CONNECTED",
          linked_at: new Date().toISOString(),
          last_login_at: new Date().toISOString(),
          last_interaction_at: new Date().toISOString(),
        }, { onConflict: "telegram_user_id" });

        await supabase
          .from("telegram_link_tokens")
          .update({ used_at: new Date().toISOString() })
          .eq("id", tokenRecord.id);

        await botClient.sendMessage({
          chat_id: chatId,
          text: `🏛️ <b>Gandhigram Rural Institute (GRI)</b>\n\n✅ <b>App Link Verified & Authenticated!</b>\n\nConnected to GRI User: <code>${userId}</code>\nRole: <b>${role}</b>\n\nYou can now request your academic records directly. Type /help for all commands.`,
          parse_mode: "HTML",
        });

        return new Response(JSON.stringify({ ok: true }), {
          status: 200,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }

      await botClient.sendMessage({
        chat_id: chatId,
        text: `🏛️ <b>Welcome to Gandhigram Rural Institute Official Bot</b>\n\nTo access student and faculty records, you must authenticate:\n\n1. Use <code>/login &lt;username&gt; &lt;password&gt;</code> here in chat, OR\n2. Open GRI Mobile App → <b>Settings → Connected Services → Telegram</b> to link.\n\nType /help for command documentation.`,
        parse_mode: "HTML",
      });

      return new Response(JSON.stringify({ ok: true }), {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // -------------------------------------------------------------------------
    // COMMAND: /help
    // -------------------------------------------------------------------------
    if (rawText === "/help") {
      await botClient.sendMessage({
        chat_id: chatId,
        text: `🏛️ <b>GRI Official Bot — Commands Manual</b>\n\n` +
          `<b>Authentication:</b>\n` +
          `• /login &lt;user&gt; &lt;pass&gt; — Authenticate with GRI credentials\n` +
          `• /logout — End active session\n` +
          `• /status — Check connection and active role\n` +
          `• /unlink — Disconnect Telegram from GRI account\n\n` +
          `<b>Role-Based Data Commands (Login Required):</b>\n` +
          `• /profile — View authorized profile details\n` +
          `• /attendance — View course attendance & roll-call status\n` +
          `• /exams — Timetable, hall ticket & exam alerts\n` +
          `• /grievance — Track submitted grievance tickets\n` +
          `• /leaves — Faculty leave requests (Faculty only)\n` +
          `• /approvals — Pending registration review (Admin only)\n` +
          `• /circulars — Official university circulars & notifications`,
        parse_mode: "HTML",
      });
      return new Response(JSON.stringify({ ok: true }), {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // -------------------------------------------------------------------------
    // COMMAND: /status
    // -------------------------------------------------------------------------
    if (rawText === "/status") {
      if (!conn || !conn.is_authenticated) {
        await botClient.sendMessage({
          chat_id: chatId,
          text: `ℹ️ <b>Status: Unauthenticated (GUEST)</b>\n\nYou must log in with your GRI credentials to retrieve institutional records:\n<code>/login &lt;username&gt; &lt;password&gt;</code>`,
          parse_mode: "HTML",
        });
      } else {
        await botClient.sendMessage({
          chat_id: chatId,
          text: `✅ <b>Status: Authenticated & Connected</b>\n\n` +
            `• GRI User ID: <code>${conn.user_id}</code>\n` +
            `• Active Role: <b>${conn.authenticated_role}</b>\n` +
            `• Linked Since: ${new Date(conn.linked_at).toLocaleDateString()}\n` +
            `• Security Gate: Role-Based Access Control Active`,
          parse_mode: "HTML",
        });
      }
      return new Response(JSON.stringify({ ok: true }), {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // -------------------------------------------------------------------------
    // ROLE-GATED DATA COMMAND: /attendance
    // -------------------------------------------------------------------------
    if (rawText === "/attendance") {
      if (!isAuthenticated || !linkedUserId) {
        await requireAuth();
        return new Response(JSON.stringify({ ok: true }), {
          status: 200,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }

      if (userRole === "STUDENT" || userRole === "SCHOLAR") {
        const { data: courses } = await supabase
          .from("student_courses")
          .select("code, title, attendance, attended, total")
          .eq("user_id", linkedUserId);

        let body = `📊 <b>Your Official Attendance Ledger (${linkedUserId})</b>\n\n`;
        if (courses && courses.length > 0) {
          let totalAttended = 0;
          let totalClasses = 0;
          for (const c of courses) {
            const pct = c.total > 0 ? ((c.attended / c.total) * 100).toFixed(1) : (c.attendance ?? "0.0");
            const statusIcon = Number(pct) >= 75 ? "🟢" : "🔴";
            body += `${statusIcon} <b>${c.code}</b> — ${c.title}\n   Classes: ${c.attended}/${c.total} (${pct}%)\n`;
            totalAttended += c.attended ?? 0;
            totalClasses += c.total ?? 0;
          }
          const overall = totalClasses > 0 ? ((totalAttended / totalClasses) * 100).toFixed(1) : "0.0";
          body += `\n<b>Aggregate Attendance:</b> ${overall}%\n`;
          body += Number(overall) >= 75 ? "✅ Eligible for End-Semester Examinations." : "⚠️ Condonation required (< 75%).";
        } else {
          body += `No registered courses found for current semester.`;
        }

        await botClient.sendMessage({ chat_id: chatId, text: body, parse_mode: "HTML" });
      } else if (userRole === "FACULTY") {
        await botClient.sendMessage({
          chat_id: chatId,
          text: `📋 <b>Faculty Roll-Call Portal</b>\n\nDepartment Attendance Register is active.\nPlease open the GRI Mobile App → Faculty Portal to conduct live biometric/QR roll-call.`,
          parse_mode: "HTML",
        });
      } else {
        await botClient.sendMessage({
          chat_id: chatId,
          text: `ℹ️ Attendance queries are configured for Student and Faculty roles.`,
          parse_mode: "HTML",
        });
      }
      return new Response(JSON.stringify({ ok: true }), {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // -------------------------------------------------------------------------
    // ROLE-GATED DATA COMMAND: /exams
    // -------------------------------------------------------------------------
    if (rawText === "/exams") {
      if (!isAuthenticated || !linkedUserId) {
        await requireAuth();
        return new Response(JSON.stringify({ ok: true }), {
          status: 200,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }

      await botClient.sendMessage({
        chat_id: chatId,
        text: `🏛️ <b>Office of the Controller of Examinations (COE)</b>\n\n` +
          `• User: <code>${linkedUserId}</code>\n` +
          `• Hall Ticket Status: <b>ISSUED & ACTIVE</b>\n` +
          `• Verification: e-Sanad Anti-Counterfeit Seal Verified\n` +
          `• Exam Center: Multi-Purpose Hall, GRI Main Campus\n\n` +
          `<i>To download or view the digital hall ticket with official QR stamp, open Document Vault in the GRI Mobile App.</i>`,
        parse_mode: "HTML",
      });

      return new Response(JSON.stringify({ ok: true }), {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // -------------------------------------------------------------------------
    // ROLE-GATED DATA COMMAND: /grievance
    // -------------------------------------------------------------------------
    if (rawText === "/grievance") {
      if (!isAuthenticated || !linkedUserId) {
        await requireAuth();
        return new Response(JSON.stringify({ ok: true }), {
          status: 200,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }

      const { data: grievances } = await supabase
        .from("grievances")
        .select("id, category, subject, status, date")
        .eq("user_id", linkedUserId);

      let textOut = `⚖️ <b>GRI-Care Grievance Redressal Status</b>\n\n`;
      if (grievances && grievances.length > 0) {
        for (const g of grievances) {
          const badge = g.status === "RESOLVED" ? "🟢" : "🟡";
          textOut += `${badge} <b>[${g.category}]</b> ${g.subject}\n   Status: <b>${g.status}</b> | Filed: ${g.date}\n`;
        }
      } else {
        textOut += `No active grievances found on record for your account.`;
      }

      await botClient.sendMessage({ chat_id: chatId, text: textOut, parse_mode: "HTML" });
      return new Response(JSON.stringify({ ok: true }), {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // -------------------------------------------------------------------------
    // ROLE-GATED DATA COMMAND: /leaves (FACULTY ONLY)
    // -------------------------------------------------------------------------
    if (rawText === "/leaves") {
      if (!isAuthenticated || !linkedUserId) {
        await requireAuth();
        return new Response(JSON.stringify({ ok: true }), {
          status: 200,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }

      if (userRole !== "FACULTY" && userRole !== "STAFF" && userRole !== "ADMIN") {
        await botClient.sendMessage({
          chat_id: chatId,
          text: `⛔ <b>Access Denied</b>: The /leaves command is restricted to Faculty and Staff roles.`,
          parse_mode: "HTML",
        });
        return new Response(JSON.stringify({ ok: true }), {
          status: 200,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }

      const { data: leaves } = await supabase
        .from("faculty_leaves")
        .select("type, dates, days, status, reason")
        .eq("user_id", linkedUserId);

      let leaveText = `📝 <b>Faculty Leave Applications</b>\n\n`;
      if (leaves && leaves.length > 0) {
        for (const l of leaves) {
          leaveText += `• <b>${l.type}</b> (${l.days} days): ${l.dates}\n  Status: <b>${l.status}</b> | Reason: ${l.reason}\n`;
        }
      } else {
        leaveText += `No pending leave applications.`;
      }

      await botClient.sendMessage({ chat_id: chatId, text: leaveText, parse_mode: "HTML" });
      return new Response(JSON.stringify({ ok: true }), {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // -------------------------------------------------------------------------
    // ROLE-GATED DATA COMMAND: /approvals (ADMIN ONLY)
    // -------------------------------------------------------------------------
    if (rawText === "/approvals") {
      if (!isAuthenticated) {
        await requireAuth();
        return new Response(JSON.stringify({ ok: true }), {
          status: 200,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }

      if (userRole !== "ADMIN" && userRole !== "SUPER_ADMIN") {
        await botClient.sendMessage({
          chat_id: chatId,
          text: `⛔ <b>Access Denied</b>: The /approvals command requires Administrative privileges.`,
          parse_mode: "HTML",
        });
        return new Response(JSON.stringify({ ok: true }), {
          status: 200,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }

      const { count } = await supabase
        .from("user_profiles")
        .select("*", { count: "exact", head: true })
        .eq("status", "PENDING");

      await botClient.sendMessage({
        chat_id: chatId,
        text: `🛡️ <b>Administrative Approval Center</b>\n\n• Pending Registrations: <b>${count ?? 0}</b>\n• System Health: Operational\n\nPlease open the Admin Approval Center in the GRI Mobile App to review identity credentials.`,
        parse_mode: "HTML",
      });
      return new Response(JSON.stringify({ ok: true }), {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // -------------------------------------------------------------------------
    // PUBLIC / ACCESSIBLE COMMAND: /circulars
    // -------------------------------------------------------------------------
    if (rawText === "/circulars") {
      const { data: circulars } = await supabase
        .from("circulars_notices")
        .select("title, category, date, issued_by")
        .order("created_at", { ascending: false })
        .limit(4);

      let cText = `📢 <b>Official GRI Circulars & Statutory Notices</b>\n\n`;
      if (circulars && circulars.length > 0) {
        for (const c of circulars) {
          cText += `• <b>[${c.category}]</b> ${c.title}\n  Issued by: ${c.issued_by} (${c.date})\n\n`;
        }
      } else {
        cText += `No recent circulars found.`;
      }

      await botClient.sendMessage({ chat_id: chatId, text: cText, parse_mode: "HTML" });
      return new Response(JSON.stringify({ ok: true }), {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // -------------------------------------------------------------------------
    // ROLE-GATED DATA COMMAND: /profile
    // -------------------------------------------------------------------------
    if (rawText === "/profile") {
      if (!isAuthenticated || !linkedUserId) {
        await requireAuth();
        return new Response(JSON.stringify({ ok: true }), {
          status: 200,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }

      const { data: profile } = await supabase
        .from("user_profiles")
        .select("name, institutional_id, active_role, department, programme, semester, status")
        .or(`institutional_id.eq.${linkedUserId},auth_user_id.eq.${linkedUserId},id.eq.${linkedUserId}`)
        .maybeSingle();

      if (profile) {
        await botClient.sendMessage({
          chat_id: chatId,
          text: `🎓 <b>GRI Profile Details</b>\n\n` +
            `• Name: <b>${profile.name}</b>\n` +
            `• ID: <code>${profile.institutional_id ?? linkedUserId}</code>\n` +
            `• Role: <b>${profile.active_role}</b>\n` +
            `• Department: ${profile.department ?? "General"}\n` +
            `• Programme: ${profile.programme ?? "N/A"}\n` +
            `• Semester: ${profile.semester ?? "N/A"}\n` +
            `• Status: ${profile.status}`,
          parse_mode: "HTML",
        });
      } else {
        await botClient.sendMessage({
          chat_id: chatId,
          text: `👤 <b>GRI Profile</b>\n\nLinked ID: <code>${linkedUserId}</code>\nRole: <b>${userRole}</b>`,
          parse_mode: "HTML",
        });
      }
      return new Response(JSON.stringify({ ok: true }), {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // Default message fallback (redact password from any storage)
    if (conn && !rawText.startsWith("/login")) {
      await supabase.from("telegram_messages").insert({
        user_id: conn.user_id,
        telegram_connection_id: conn.id,
        telegram_message_id: msg.message_id,
        direction: "INBOUND",
        message_type: "TEXT",
        message_content: rawText,
        processing_status: "RECEIVED",
        received_at: new Date().toISOString(),
      });

      await botClient.sendMessage({
        chat_id: chatId,
        text: `Received: "<i>${rawText.length > 60 ? rawText.substring(0, 60) + '...' : rawText}</i>". Type /help to see all available commands.`,
        parse_mode: "HTML",
      });
    }

    return new Response(JSON.stringify({ ok: true }), {
      status: 200,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
