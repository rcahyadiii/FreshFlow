// @ts-nocheck
import { serve } from "https://deno.land/std/http/mod.ts";

// Supabase Edge Function: chat
// Accepts JSON { text: string, messages?: Array<{ role: 'user'|'assistant'|'system', content: string }> }
// Returns JSON { reply: string }
// Calls Google AI Studio (Gemini) using the server-side secret GOOGLE_API_KEY

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response("Method Not Allowed", { status: 405 });
  }

  const apiKey = Deno.env.get("GOOGLE_API_KEY");
  if (!apiKey) {
    return new Response("Missing GOOGLE_API_KEY", { status: 500 });
  }

  let text = "";
  let messages: Array<{ role: string; content: string }> = [];
  try {
    const body = await req.json();
    text = String(body?.text ?? "").trim();
    if (Array.isArray(body?.messages)) {
      messages = body.messages
        .filter((m: any) => m && typeof m.role === "string" && typeof m.content === "string")
        .slice(-10); // keep last 10 for context
    }
  } catch (_) {
    // ignore parse errors
  }

  if (!text) {
    return new Response(JSON.stringify({ reply: "Please provide a message." }), {
      headers: { "Content-Type": "application/json" },
    });
  }

  // Call Google Generative AI (Gemini 1.5 Flash) - use stable v1 endpoint
  // You can switch to gemini-1.5-flash-latest or a specific variant if desired
  const model = Deno.env.get("GEMINI_MODEL") ?? "gemini-2.5-flash";
  const geminiUrl =
    `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${apiKey}`;

  // Optional: system profile to ground the assistant in your app
  const appProfile = Deno.env.get("APP_PROFILE") ??
    "You are FreshFlow Assistance, a helpful assistant for the FreshFlow mobile app."
    + " Help users with water information, flood alerts, heavy rain, notifications, reports, and profile settings."
    + " Be concise, actionable, and avoid claiming to see the user's screen.";

  const historyContents = messages.map((m) => ({
    role: m.role === "assistant" || m.role === "system" ? "model" : "user",
    parts: [{ text: String(m.content) }],
  }));

  const resp = await fetch(geminiUrl, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      systemInstruction: { role: "system", parts: [{ text: appProfile }] },
      contents: [
        ...historyContents,
        { role: "user", parts: [{ text }] },
      ],
    }),
  });

  if (!resp.ok) {
    const errText = await resp.text();
    return new Response(JSON.stringify({ reply: "Sorry, I’m having trouble right now.", error: errText }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  }

  const data = await resp.json();
  const reply = data?.candidates?.[0]?.content?.parts?.[0]?.text ?? "I’m here to help.";

  return new Response(JSON.stringify({ reply }), {
    headers: { "Content-Type": "application/json" },
  });
});
