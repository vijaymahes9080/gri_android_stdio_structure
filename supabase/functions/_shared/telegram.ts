// =============================================================================
// GANDHIGRAM RURAL INSTITUTE — Supabase Edge Functions
// Shared Telegram Bot API Client, Crypto Utilities & Types
// =============================================================================

export interface TelegramUser {
  id: number;
  is_bot: boolean;
  first_name: string;
  last_name?: string;
  username?: string;
  language_code?: string;
}

export interface TelegramChat {
  id: number;
  type: 'private' | 'group' | 'supergroup' | 'channel';
  title?: string;
  username?: string;
  first_name?: string;
  last_name?: string;
}

export interface TelegramMessage {
  message_id: number;
  from?: TelegramUser;
  chat: TelegramChat;
  date: number;
  text?: string;
  entities?: Array<{
    type: string;
    offset: number;
    length: number;
  }>;
}

export interface TelegramUpdate {
  update_id: number;
  message?: TelegramMessage;
  edited_message?: TelegramMessage;
  callback_query?: {
    id: string;
    from: TelegramUser;
    message?: TelegramMessage;
    data?: string;
  };
}

export interface TelegramSendResponse {
  ok: boolean;
  result?: TelegramMessage;
  description?: string;
  error_code?: number;
}

export class TelegramBotClient {
  private readonly token: string;
  private readonly baseUrl: string;

  constructor(token?: string) {
    this.token = token || Deno.env.get('TELEGRAM_BOT_TOKEN') || '';
    if (!this.token) {
      throw new Error('TELEGRAM_BOT_TOKEN environment secret is not configured.');
    }
    this.baseUrl = `https://api.telegram.org/bot${this.token}`;
  }

  async getMe(): Promise<TelegramUser> {
    const res = await fetch(`${this.baseUrl}/getMe`);
    const data = await res.json();
    if (!data.ok) {
      throw new Error(`Telegram getMe failed: ${data.description}`);
    }
    return data.result;
  }

  async sendMessage(params: {
    chat_id: number | string;
    text: string;
    parse_mode?: 'HTML' | 'MarkdownV2' | 'Markdown';
    reply_markup?: unknown;
  }): Promise<TelegramSendResponse> {
    const res = await fetch(`${this.baseUrl}/sendMessage`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(params),
    });
    return await res.json();
  }

  async setWebhook(params: {
    url: string;
    secret_token?: string;
    drop_pending_updates?: boolean;
    allowed_updates?: string[];
  }): Promise<{ ok: boolean; description?: string }> {
    const res = await fetch(`${this.baseUrl}/setWebhook`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(params),
    });
    return await res.json();
  }
}

/**
 * Computes SHA-256 hash of a plain string.
 */
export async function sha256Hex(input: string): Promise<string> {
  const data = new TextEncoder().encode(input);
  const hashBuffer = await crypto.subtle.digest('SHA-256', data);
  const hashArray = Array.from(new Uint8Array(hashBuffer));
  return hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
}

/**
 * Generates a cryptographically secure random token in hexadecimal format.
 */
export function generateSecureToken(byteLength: number = 32): string {
  const bytes = new Uint8Array(byteLength);
  crypto.getRandomValues(bytes);
  return Array.from(bytes).map(b => b.toString(16).padStart(2, '0')).join('');
}

