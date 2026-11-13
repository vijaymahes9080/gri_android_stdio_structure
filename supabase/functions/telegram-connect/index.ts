// =============================================================================
// GANDHIGRAM RURAL INSTITUTE — Supabase Edge Functions
// Endpoint: telegram-connect
// Description: Generates a single-use cryptographically secure linking token
//              and deep link for associating a GRI user with Telegram bot.
// =============================================================================

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";
import { generateSecureToken, sha256Hex } from "../_shared/telegram.ts";

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

    const body = await req.json().catch(() => ({}));
    const userId = body.user_id || body.userId;

    if (!userId) {
      return new Response(JSON.stringify({ error: "Missing user_id parameter" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // Generate random 32-byte hex token (64 characters)
    const rawToken = generateSecureToken(32);
    const tokenHash = await sha256Hex(rawToken);

    // 15-minute token expiry
    const expiresAt = new Date(Date.now() + 15 * 60 * 1000).toISOString();

    // Invalidate existing unused tokens for this user
    await supabase
      .from("telegram_link_tokens")
      .delete()
      .eq("user_id", userId)
      .is("used_at", null);

    // Save hashed token
    const { error: insertErr } = await supabase.from("telegram_link_tokens").insert({
      user_id: userId,
      token_hash: tokenHash,
      expires_at: expiresAt,
    });

    if (insertErr) {
      return new Response(JSON.stringify({ error: insertErr.message }), {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // Bot username for Gandhigram Rural Institute
    const botUsername = Deno.env.get("TELEGRAM_BOT_USERNAME") || "Gandhigram_rural_institutebot";
    const deepLink = `https://t.me/${botUsername}?start=link_${rawToken}`;

    // Record activity log
    await supabase.from("app_activity_logs").insert({
      user_id: userId,
      action: "TELEGRAM_LINK_INITIATED",
      module: "TELEGRAM",
      metadata: { expires_at: expiresAt },
      source: "FLUTTER_MOBILE",
    });

    return new Response(
      JSON.stringify({
        ok: true,
        deep_link: deepLink,
        expires_at: expiresAt,
        bot_username: botUsername,
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

