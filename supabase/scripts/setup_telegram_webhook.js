/**
 * Gandhigram Rural Institute (GRI) — Telegram Webhook Setup Script
 *
 * Usage:
 *   node supabase/scripts/setup_telegram_webhook.js --url <SUPABASE_EDGE_FUNCTION_URL> --token <TELEGRAM_BOT_TOKEN> --secret <SECRET_TOKEN>
 */

const https = require('https');

const args = process.argv.slice(2);
function getArg(name, def = '') {
  const idx = args.indexOf(`--${name}`);
  if (idx !== -1 && idx + 1 < args.length) return args[idx + 1];
  return def;
}

const botToken = getArg('token', process.env.TELEGRAM_BOT_TOKEN || '9037258166:AAFVK0qyhE96WSwaZpx1TrcWH7-ideg1NCY');
const webhookUrl = getArg('url', process.env.TELEGRAM_WEBHOOK_URL);
const secretToken = getArg('secret', process.env.TELEGRAM_WEBHOOK_SECRET);

if (!botToken) {
  console.error("Error: Telegram bot token must be provided via --token or TELEGRAM_BOT_TOKEN");
  process.exit(1);
}

if (!webhookUrl) {
  console.log("Checking current webhook info...");
  https.get(`https://api.telegram.org/bot${botToken}/getWebhookInfo`, (res) => {
    let data = '';
    res.on('data', chunk => data += chunk);
    res.on('end', () => {
      console.log("Current Webhook Info:", JSON.parse(data));
      console.log("\nTo set a new webhook, run:");
      console.log("node supabase/scripts/setup_telegram_webhook.js --url https://<project>.supabase.co/functions/v1/telegram-webhook --secret <secret>");
    });
  });
} else {
  console.log(`Setting webhook to: ${webhookUrl}`);
  const payload = JSON.stringify({
    url: webhookUrl,
    secret_token: secretToken || undefined,
    allowed_updates: ["message", "edited_message", "callback_query"],
    drop_pending_updates: false,
  });

  const req = https.request(`https://api.telegram.org/bot${botToken}/setWebhook`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Content-Length': Buffer.byteLength(payload),
    },
  }, (res) => {
    let data = '';
    res.on('data', chunk => data += chunk);
    res.on('end', () => {
      console.log("Result:", JSON.parse(data));
    });
  });

  req.on('error', (e) => console.error("Request Error:", e));
  req.write(payload);
  req.end();
}

