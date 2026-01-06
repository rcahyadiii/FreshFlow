# Supabase Edge Function: chat

This function accepts `{ text }` and returns `{ reply }` by calling Google AI Studio (Gemini).

## Prerequisites
- Supabase CLI installed (`brew install supabase` on macOS)
- Logged in to Supabase and linked to your project
- Google AI Studio API key (server-side only)

## Set up secrets
```bash
supabase login
supabase link --project-ref prwmwkadvuzxwmkurhjw
supabase secrets set GOOGLE_API_KEY=YOUR_GOOGLE_AI_STUDIO_KEY
supabase secrets set GEMINI_MODEL=gemini-2.5-flash
supabase secrets set APP_PROFILE="You are FreshFlow Assistance, a helpful assistant for the FreshFlow mobile app. Help users with water information, flood alerts, heavy rain, notifications, reports, and profile settings. Be concise, actionable, and avoid claiming to see the user's screen."
```

## Deploy the function
```bash
supabase functions deploy chat
```

## Test invocation
Invoke locally from CLI (no JWT verification):
```bash
supabase functions invoke chat --no-verify-jwt --data '{"text":"Hello FreshFlow","messages":[{"role":"user","content":"Hi"}]}'
```
Expect JSON:
```json
{ "reply": "..." }
```

## Flutter client
The app calls this function via `SupabaseChatRepository`:
- `lib/features/chat/data/supabase_chat_repository.dart`
- It sends `{ text }` and expects `{ reply }`.

## Notes
- Do not store the `GOOGLE_API_KEY` in the app; keep it server-side.
- For streaming replies, create a separate `chat-stream` function using SSE.
