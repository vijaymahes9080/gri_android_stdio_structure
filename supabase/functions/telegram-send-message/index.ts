// =============================================================================
// GANDHIGRAM RURAL INSTITUTE — Supabase Edge Functions
// Endpoint: telegram-send-message
// Description: Sends an outbound Telegram notification to a linked GRI user,
//              respecting user notification preferences and logging delivery results.
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
    const message = body.message;
    const notificationType = body.notification_type || "TEST_ALERT";

    if (!userId || !message) {
      return new Response(JSON.stringify({ error: "Missing userId or message" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // 1. Check connection
    const { data: conn } = await supabase
      .from("telegram_connections")
      .select("*")
      .eq("user_id", userId)
      .eq("connection_status", "CONNECTED")
      .maybeSingle();

    if (!conn) {
      return new Response(
        JSON.stringify({
          ok: false,
          error: "User does not have an active Telegram connection.",
        }),
        {
          status: 404,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    // 2. Check notification preferences
    const { data: prefs } = await supabase
      .from("notification_preferences")
      .select("*")
      .eq("user_id", userId)
      .maybeSingle();

    if (prefs && prefs.telegram_enabled === false) {
      return new Response(
        JSON.stringify({
          ok: false,
          error: "User has disabled Telegram notifications in preferences.",
        }),
        {
          status: 403,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    // 3. Send message via Telegram Bot API
    const formattedText = `🔔 <b>Gandhigram Rural Institute Alert</b>\n\n${message}\n\n<i>Delivered: ${new Date().toLocaleTimeString()}</i>`;
    const tgRes = await botClient.sendMessage({
      chat_id: conn.telegram_chat_id,
      text: formattedText,
      parse_mode: "HTML",
    });

    const isSuccess = tgRes.ok === true;
    const tgMessageId = tgRes.result?.message_id;

    // 4. Log message record
    await supabase.from("telegram_messages").insert({
      user_id: userId,
      telegram_connection_id: conn.id,
      telegram_message_id: tgMessageId,
      direction: "OUTBOUND",
      message_type: "NOTIFICATION",
      message_content: message,
      processing_status: isSuccess ? "DELIVERED" : "FAILED",
      error_message: isSuccess ? null : tgRes.description,
      sent_at: new Date().toISOString(),
    });

    // 5. Update last interaction
    await supabase
      .from("telegram_connections")
      .update({ last_interaction_at: new Date().toISOString() })
      .eq("id", conn.id);

    // 6. Record app activity log
    await supabase.from("app_activity_logs").insert({
      user_id: userId,
      action: "TELEGRAM_NOTIFICATION_SENT",
      module: "TELEGRAM",
      entity_type: "telegram_messages",
      metadata: {
        notification_type: notificationType,
        success: isSuccess,
        telegram_message_id: tgMessageId,
      },
      source: "FLUTTER_MOBILE",
    });

    return new Response(
      JSON.stringify({
        ok: isSuccess,
        message_id: tgMessageId,
        description: tgRes.description,
      }),
      {
        status: isSuccess ? 200 : 502,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});

