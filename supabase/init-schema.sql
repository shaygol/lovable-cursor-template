-- ==============================================
-- <TITLE> - Full Database Schema
-- Run this in Supabase SQL Editor after creating a new project
-- ==============================================

-- -----------------------------------------------
-- STEP 1: Custom enum type for roles
-- -----------------------------------------------
DO $$ BEGIN
  CREATE TYPE public.app_role AS ENUM ('admin', 'user');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- -----------------------------------------------
-- STEP 2: User roles table
-- -----------------------------------------------
CREATE TABLE IF NOT EXISTS public.user_roles (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role       public.app_role NOT NULL DEFAULT 'user',
  created_at timestamptz DEFAULT now(),
  UNIQUE (user_id, role)
);

ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own role"
  ON public.user_roles FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "Admins can manage roles"
  ON public.user_roles
  FOR ALL
  USING (public.has_role(auth.uid(), 'admin'::public.app_role));

-- -----------------------------------------------
-- STEP 3: has_role helper function
-- IMPORTANT: Always call with public. prefix inside storage policies.
-- -----------------------------------------------
CREATE OR REPLACE FUNCTION public.has_role(
  _user_id uuid,
  _role    public.app_role
)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_roles
    WHERE user_id = _user_id
      AND role    = _role
  );
$$;

-- -----------------------------------------------
-- STEP 4: Profiles table (linked to auth.users)
-- -----------------------------------------------
CREATE TABLE IF NOT EXISTS public.profiles (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE,
  name       text,
  phone      text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own profile"
  ON public.profiles
  FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Admins can manage all profiles"
  ON public.profiles
  FOR ALL
  USING (public.has_role(auth.uid(), 'admin'::public.app_role));

-- -----------------------------------------------
-- STEP 5: Storage bucket (images)
-- Folder structure: products/ | articles/ | branding/
-- -----------------------------------------------
-- Run in Supabase Dashboard > Storage, or via SQL:
-- INSERT INTO storage.buckets (id, name, public) VALUES ('images', 'images', true);

-- Storage RLS policies — NOTE:
--   1. Always use public.has_role() with the schema prefix.
--   2. Never use upsert:true in client uploads (triggers UPDATE path with separate USING policy).
CREATE POLICY "Public read access"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'images');

CREATE POLICY "Admins can upload images"
  ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'images'
    AND public.has_role(auth.uid(), 'admin'::public.app_role)
  );

CREATE POLICY "Admins can update images"
  ON storage.objects FOR UPDATE
  USING (
    bucket_id = 'images'
    AND public.has_role(auth.uid(), 'admin'::public.app_role)
  );

CREATE POLICY "Admins can delete images"
  ON storage.objects FOR DELETE
  USING (
    bucket_id = 'images'
    AND public.has_role(auth.uid(), 'admin'::public.app_role)
  );

-- -----------------------------------------------
-- STEP 6: Settings table (key/value store)
-- -----------------------------------------------
CREATE TABLE IF NOT EXISTS public.settings (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  key        text NOT NULL UNIQUE,
  value      jsonb NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE public.settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read settings"
  ON public.settings FOR SELECT
  USING (true);

CREATE POLICY "Admins can manage settings"
  ON public.settings FOR ALL
  USING (public.has_role(auth.uid(), 'admin'::public.app_role));

-- -----------------------------------------------
-- STEP 7: Paste your project-specific schema below
-- -----------------------------------------------

-- Example: products table
-- CREATE TABLE IF NOT EXISTS public.products (
--   id                    uuid PRIMARY KEY DEFAULT gen_random_uuid(),
--   name                  text NOT NULL,
--   price                 numeric(10,2) NOT NULL,
--   image_url             text,
--   category              text,
--   available             boolean DEFAULT true,
--   max_quantity_per_order integer DEFAULT 10,
--   display_order         integer DEFAULT 0,
--   created_at            timestamptz DEFAULT now(),
--   updated_at            timestamptz DEFAULT now()
-- );
-- ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
-- CREATE POLICY "Public read products" ON public.products FOR SELECT USING (true);
-- CREATE POLICY "Admins can manage products" ON public.products FOR ALL
--   USING (public.has_role(auth.uid(), 'admin'::public.app_role));
