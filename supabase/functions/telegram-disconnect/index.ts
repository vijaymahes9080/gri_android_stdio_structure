// =============================================================================
// GANDHIGRAM RURAL INSTITUTE — Supabase Edge Functions
// Endpoint: telegram-disconnect
// Description: Revokes Telegram connection for a user, invalidates active sessions,
//              and notifies user via bot that the link has been terminated.
// =============================================================================

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";
import { TelegramBotClient } from "../_shared/telegram.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
    const supabase = createClient(supabaseUrl, supabaseServiceKey);
    const botClient = new TelegramBotClient();

    const body = await req.json().catch(() => ({}));
    const userId = body.user_id || body.userId;

    if (!userId) {
      return new Response(JSON.stringify({ error: "Missing user_id parameter" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const { data: conn } = await supabase
      .from("telegram_connections")
      .select("*")
      .eq("user_id", userId)
      .eq("connection_status", "CONNECTED")
      .maybeSingle();

    if (conn) {
      await supabase
        .from("telegram_connections")
        .update({
          connection_status: "DISCONNECTED",
          is_authenticated: false,
          authenticated_role: "GUEST",
          disconnected_at: new Date().toISOString(),
          last_interaction_at: new Date().toISOString(),
        })
        .eq("id", conn.id);

      // Notify Telegram chat that the account was unlinked from mobile app
      await botClient.sendMessage({
        chat_id: conn.telegram_chat_id,
        text: `🔌 <b>Account Disconnected</b>\n\nYour GRI Mobile Portal association for user <code>${userId}</code> has been disconnected from the mobile application. Alerts and data requests are now deactivated.`,
        parse_mode: "HTML",
      });

      // Audit log
      await supabase.from("app_activity_logs").insert({
        user_id: userId,
        action: "TELEGRAM_ACCOUNT_DISCONNECTED",
        module: "TELEGRAM",
        entity_type: "telegram_connections",
        metadata: { telegram_chat_id: conn.telegram_chat_id },
        source: "FLUTTER_MOBILE",
      });
    }

    return new Response(JSON.stringify({ ok: true, disconnected: true }), {
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
