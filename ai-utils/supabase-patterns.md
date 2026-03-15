# Supabase Patterns & Known Pitfalls

Hard-won lessons from real projects. Read this before writing any Supabase integration.

---

## 1. API Key — Use the Supabase Anon JWT, not a publishable key

**Wrong:** `sb_publishable_xxxxxxxxxxxx` (a platform/vendor key — silently fails all auth)

**Correct:** `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...` (the Supabase anon JWT)

Find it in: Supabase Dashboard → Project Settings → API → `anon public` key.

```env
# .env
VITE_SUPABASE_URL=https://xxxxxxxxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

---

## 2. RLS Policies — Always cast enum types explicitly

If your project uses a custom `app_role` enum, every RLS policy that references it must cast the string literal:

**Wrong (causes "function does not exist" error at runtime):**
```sql
USING (has_role(auth.uid(), 'admin'))
```

**Correct:**
```sql
USING (public.has_role(auth.uid(), 'admin'::app_role))
```

The function signature is `has_role(uuid, app_role)`. Passing a plain string `'admin'` does not match `app_role` — PostgreSQL will not auto-cast it.

---

## 3. RLS in Storage — Always use the `public.` schema prefix

Storage policies run inside the `storage` schema context. A bare `has_role(...)` call will not resolve to `public.has_role` automatically.

**Wrong:**
```sql
WITH CHECK (bucket_id = 'images' AND has_role(auth.uid(), 'admin'::app_role))
```

**Correct:**
```sql
WITH CHECK (bucket_id = 'images' AND public.has_role(auth.uid(), 'admin'::app_role))
```

---

## 4. Storage Upload — Never use `upsert: true`

When you pass `{ upsert: true }` to `supabase.storage.upload()`, Supabase internally attempts an UPDATE first. This requires a separate `USING` policy on `storage.objects FOR UPDATE`. If that policy is missing or misconfigured, the upload fails with a cryptic RLS error — even if your INSERT policy is correct.

**Wrong:**
```ts
await supabase.storage.from('images').upload(path, file, { upsert: true });
```

**Correct:**
```ts
await supabase.storage.from('images').upload(path, file);
// If the file already exists, generate a unique filename instead of upsert.
```

---

## 5. `has_role` function must exist before RLS policies that use it

If you run `CREATE POLICY ... USING (public.has_role(...))` before the function is created, PostgreSQL accepts the policy but it will fail at query time. Always run `init-schema.sql` from top to bottom — function first, policies after.

---

## 6. Data queries — Always filter by the current user

Never fetch unbounded data. A query like `supabase.from('orders').select('*')` will return all rows to anyone whose RLS `SELECT` policy allows it (or silently return everything if RLS is misconfigured). Always add a client-side `.eq()` filter as a second layer of defense:

```ts
// Show only the current user's own orders
supabase.from('orders')
  .select('...')
  .eq('customer_phone', currentUserPhone)
```

Pair this with an RLS policy:
```sql
CREATE POLICY "Customers can view own orders"
ON public.orders FOR SELECT TO authenticated
USING (
  customer_phone = (
    SELECT phone FROM public.profiles WHERE user_id = auth.uid()
  )
);
```

---

## 7. Storage bucket folder structure

Organize uploads into subfolders inside a single bucket. This avoids needing multiple buckets and keeps policies simple.

Recommended structure:
```
images/
  products/      ← product photos
  articles/      ← article cover images
  branding/      ← logo, hero images
```

Generate unique filenames to avoid collisions:
```ts
const ext = file.name.split('.').pop();
const path = `products/${Date.now()}-${Math.random().toString(36).slice(2)}.${ext}`;
await supabase.storage.from('images').upload(path, file);
```

---

## 8. Auto-delete orphaned uploads

If a user uploads an image but then cancels the form, the file remains in storage. Track the uploaded path in component state and delete it on cancel:

```ts
const [uploadedPath, setUploadedPath] = useState<string | null>(null);

const handleCancel = async () => {
  if (uploadedPath) {
    await supabase.storage.from('images').remove([uploadedPath]);
    setUploadedPath(null);
  }
};
```
