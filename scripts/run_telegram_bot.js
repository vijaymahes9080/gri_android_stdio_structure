/**
 * Gandhigram Rural Institute — Live Telegram Bot Runner (Polling Mode)
 *
 * This daemon runs locally and connects directly to Telegram Bot API.
 * It polls for updates and immediately responds to /start, /login, /attendance,
 * /exams, /grievance, etc. in real time!
 *
 * Usage:
 *   node scripts/run_telegram_bot.js <BOT_TOKEN>
 */

const https = require('https');
const crypto = require('crypto');

const token = process.argv[2] || process.env.TELEGRAM_BOT_TOKEN;

if (!token) {
  console.error("❌ Error: Please provide the bot token. Example:");
  console.error("   node scripts/run_telegram_bot.js <YOUR_BOT_TOKEN>");
  process.exit(1);
}

function sha256(str) {
  return crypto.createHash('sha256').update(str).digest('hex');
}

// In-memory demo sessions & credentials for live bot testing
const USERS = {
  'student1': { id: '2026GRI001', passHash: sha256('gri@2026'), role: 'STUDENT', name: 'Vijay Pradhap' },
  'faculty1': { id: '2026FAC012', passHash: sha256('gri@2026'), role: 'FACULTY', name: 'Dr. S. Ramanathan' },
  'admin1': { id: '2026ADM001', passHash: sha256('gri@2026'), role: 'ADMIN', name: 'Registrar Office' },
};

const SESSIONS = new Map(); // chatId -> { userId, role, name, authenticated }

function telegramApi(method, body = {}) {
  return new Promise((resolve, reject) => {
    const data = JSON.stringify(body);
    const req = https.request(`https://api.telegram.org/bot${token}/${method}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(data),
      },
    }, (res) => {
      let buf = '';
      res.on('data', chunk => buf += chunk);
      res.on('end', () => {
        try {
          resolve(JSON.parse(buf));
        } catch (e) {
          reject(e);
        }
      });
    });
    req.on('error', reject);
    req.write(data);
    req.end();
  });
}

async function sendMessage(chatId, text) {
  return telegramApi('sendMessage', {
    chat_id: chatId,
    text: text,
    parse_mode: 'HTML',
  });
}

async function handleMessage(msg) {
  if (!msg || !msg.text) return;
  const chatId = msg.chat.id;
  const text = msg.text.trim();
  const session = SESSIONS.get(chatId);
  const isAuth = session && session.authenticated;
  const role = session ? session.role : 'GUEST';

  console.log(`[Message from Chat ${chatId}]: ${text}`);

  if (text.startsWith('/start')) {
    await sendMessage(chatId,
      `🏛️ <b>Gandhigram Rural Institute (GRI) Official Bot</b>\n\n` +
      `Welcome to the official GRI Telegram service!\n\n` +
      `🔒 <b>Authentication Required:</b>\n` +
      `To view your student or faculty records, please log in:\n` +
      `<code>/login &lt;username&gt; &lt;password&gt;</code>\n\n` +
      `<i>Demo Credentials:</i>\n` +
      `• Student: <code>/login student1 gri@2026</code>\n` +
      `• Faculty: <code>/login faculty1 gri@2026</code>\n` +
      `• Admin: <code>/login admin1 gri@2026</code>\n\n` +
      `Type /help to see all available commands.`
    );
    return;
  }

  if (text.startsWith('/login')) {
    const parts = text.split(/\s+/);
    if (parts.length < 3) {
      await sendMessage(chatId, `⚠️ <b>Usage:</b> <code>/login &lt;username&gt; &lt;password&gt;</code>`);
      return;
    }
    const u = parts[1].trim();
    const p = parts[2].trim();
    const user = USERS[u];

    if (!user || user.passHash !== sha256(p)) {
      await sendMessage(chatId, `❌ <b>Authentication Failed:</b> Invalid username or password.`);
      return;
    }

    SESSIONS.set(chatId, {
      userId: user.id,
      username: u,
      role: user.role,
      name: user.name,
      authenticated: true,
    });

    await sendMessage(chatId,
      `✅ <b>Authentication Successful!</b>\n\n` +
      `• Name: <b>${user.name}</b>\n` +
      `• Institutional ID: <code>${user.id}</code>\n` +
      `• Verified Role: <b>${user.role}</b>\n\n` +
      `Available Role Commands:\n` +
      (user.role === 'STUDENT' ? `• /attendance — Course attendance ledger\n• /exams — Hall ticket & timetable\n• /grievance — Track submitted grievances\n` : '') +
      (user.role === 'FACULTY' ? `• /leaves — Faculty leave requests\n• /roster — Class attendance overview\n` : '') +
      (user.role === 'ADMIN' ? `• /approvals — Review pending registrations\n` : '') +
      `• /circulars — Official university circulars\n` +
      `• /logout — End active session`
    );
    return;
  }

  if (text === '/logout') {
    SESSIONS.delete(chatId);
    await sendMessage(chatId,
      `🔒 <b>Logged Out Successfully</b>\n\n` +
      `Your session has been terminated and institutional records are locked.\n\n` +
      `🔑 <b>Demo Credentials to Log Back In:</b>\n` +
      `• <b>Student:</b> <code>/login student1 gri@2026</code>\n` +
      `• <b>Faculty:</b> <code>/login faculty1 gri@2026</code>\n` +
      `• <b>Admin:</b> <code>/login admin1 gri@2026</code>\n\n` +
      `<i>Tap any credential above to copy and log back in!</i>`
    );
    return;
  }

  if (text === '/help') {
    await sendMessage(chatId,
      `🏛️ <b>GRI Bot Commands:</b>\n\n` +
      `• /login &lt;user&gt; &lt;pass&gt; — Log in to your GRI account\n` +
      `• /logout — End active session\n` +
      `• /attendance — View attendance ledger (Student/Faculty)\n` +
      `• /exams — Timetable and hall ticket status\n` +
      `• /grievance — Grievance redressal status\n` +
      `• /circulars — Official campus circulars\n` +
      `• /help — Show this menu`
    );
    return;
  }

  if (text === '/attendance') {
    if (!isAuth) {
      await sendMessage(chatId, `🔒 Please authenticate first: <code>/login &lt;username&gt; &lt;password&gt;</code>`);
      return;
    }
    await sendMessage(chatId,
      `📊 <b>Official Attendance Ledger (${session.userId})</b>\n\n` +
      `🟢 <b>MCA-401</b> — Cloud Native Computing: 32/36 (88.9%)\n` +
      `🟢 <b>MCA-402</b> — Mobile Application Engineering: 30/36 (83.3%)\n` +
      `🟢 <b>MCA-403</b> — Enterprise Database Systems: 34/38 (89.5%)\n` +
      `🟢 <b>GRI-VAP</b> — Gandhian Values: 18/20 (90.0%)\n\n` +
      `<b>Aggregate Attendance: 87.7%</b>\n` +
      `✅ Eligible for End-Semester Examinations.`
    );
    return;
  }

  if (text === '/exams') {
    if (!isAuth) {
      await sendMessage(chatId, `🔒 Please authenticate first: <code>/login &lt;username&gt; &lt;password&gt;</code>`);
      return;
    }
    await sendMessage(chatId,
      `🏛️ <b>Office of the Controller of Examinations (COE)</b>\n\n` +
      `• Candidate: <b>${session.name}</b> (${session.userId})\n` +
      `• Hall Ticket Status: <b>ISSUED & ACTIVE</b>\n` +
      `• Anti-Counterfeit Seal: Verified e-SANAD QR\n` +
      `• Center: Multi-Purpose Hall, GRI Main Campus\n\n` +
      `Timetable:\n` +
      `• 16 Nov 2026 (10 AM): MCA-401 Cloud Native Computing\n` +
      `• 19 Nov 2026 (10 AM): MCA-402 Mobile Engineering\n` +
      `• 23 Nov 2026 (10 AM): MCA-403 Enterprise Database\n` +
      `• 26 Nov 2026 (10 AM): GRI-VAP Gandhian Philosophy`
    );
    return;
  }

  if (text === '/grievance') {
    if (!isAuth) {
      await sendMessage(chatId, `🔒 Please authenticate first: <code>/login &lt;username&gt; &lt;password&gt;</code>`);
      return;
    }
    await sendMessage(chatId,
      `⚖️ <b>GRI-Care Grievance Status</b>\n\n` +
      `🟢 <b>[Academics]</b> Ticket GRV-2026-1061: Lab timing conflict — RESOLVED\n` +
      `🟡 <b>[Hostel]</b> Ticket GRV-2026-1062: Wi-Fi router speed — IN_PROGRESS`
    );
    return;
  }

  if (text === '/circulars') {
    await sendMessage(chatId,
      `📢 <b>Official Circulars & Notices</b>\n\n` +
      `• <b>[COE]</b> End Semester Examinations Nov 2026 Schedule Published\n` +
      `• <b>[Dean]</b> NAAC A++ Peer Review Extension Commemoration\n` +
      `• <b>[Registrar]</b> Special Bus Route Timings for Rural Camp`
    );
    return;
  }

  // Fallback for unhandled text
  await sendMessage(chatId, `Received: "${text}". Type /help to see all available commands.`);
}

let offset = 0;

async function poll() {
  try {
    const res = await telegramApi('getUpdates', {
      offset: offset,
      timeout: 30,
      allowed_updates: ['message'],
    });

    if (res.ok && Array.isArray(res.result)) {
      for (const update of res.result) {
        offset = update.update_id + 1;
        if (update.message) {
          await handleMessage(update.message);
        }
      }
    }
  } catch (err) {
    console.error("Polling error:", err.message);
    await new Promise(r => setTimeout(r, 3000));
  }
  setImmediate(poll);
}

// Start
async function start() {
  console.log("Connecting to Telegram Bot API...");
  const me = await telegramApi('getMe');
  if (!me.ok) {
    console.error("❌ getMe failed:", me.description);
    process.exit(1);
  }
  console.log(`✅ Connected successfully to @${me.result.username} (ID: ${me.result.id})!`);
  console.log("Deleting old webhook to enable direct polling...");
  await telegramApi('deleteWebhook', { drop_pending_updates: false });
  console.log("🚀 Bot is now LIVE and listening for messages. Send /start on Telegram!");
  poll();
}

start();

