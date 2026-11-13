// =============================================================================
// GANDHIGRAM RURAL INSTITUTE — Supabase Edge Functions
// Endpoint: telegram-connection-status
// Description: Returns active Telegram integration details, authenticated role,
//              and recent interaction statistics for a user.
// =============================================================================

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";

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

    const url = new URL(req.url);
    const userId = url.searchParams.get("userId") || url.searchParams.get("user_id");

    if (!userId) {
      return new Response(JSON.stringify({ error: "Missing userId query parameter" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const { data: conn, error: connErr } = await supabase
      .from("telegram_connections")
      .select("*")
      .eq("user_id", userId)
      .eq("connection_status", "CONNECTED")
      .maybeSingle();

    if (connErr) {
      return new Response(JSON.stringify({ error: connErr.message }), {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const { data: messages } = await supabase
      .from("telegram_messages")
      .select("*")
      .eq("user_id", userId)
      .order("created_at", { ascending: false })
      .limit(20);

    const { data: prefs } = await supabase
      .from("notification_preferences")
      .select("*")
      .eq("user_id", userId)
      .maybeSingle();

    return new Response(
      JSON.stringify({
        ok: true,
        is_connected: !!conn,
        connection: conn ?? null,
        messages: messages ?? [],
        preferences: prefs ?? {
          telegram_enabled: true,
          circulars_enabled: true,
          exam_alerts_enabled: true,
          grievance_alerts_enabled: true,
          administrative_alerts_enabled: true,
        },
      }),
      {
        status: 200,
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

