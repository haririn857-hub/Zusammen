-- ==============================================================================
-- MIGRATION: 20261011000000_create_zusammen_schema.sql
-- Project: Zusammen (Für Immer) - Hari & Rintamol
-- Architecture: Supabase PostgreSQL with RLS, Realtime & Ephemeral Channels
-- ==============================================================================

-- 1. Enable Required Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ==============================================================================
-- 2. CORE COUPLE TABLES
-- ==============================================================================

CREATE TABLE IF NOT EXISTS public.couples (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    couple_name TEXT NOT NULL DEFAULT 'Hari & Rintamol',
    passcode_hash TEXT NOT NULL,
    target_germany_date DATE NOT NULL DEFAULT '2028-10-01',
    target_savings_eur NUMERIC(10, 2) NOT NULL DEFAULT 11904.00,
    target_savings_inr NUMERIC(12, 2) NOT NULL DEFAULT 1350000.00,
    first_date DATE DEFAULT '2024-01-01',
    flowers_bloomed INT DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now())
);

CREATE TABLE IF NOT EXISTS public.couple_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    couple_id UUID NOT NULL REFERENCES public.couples(id) ON DELETE CASCADE,
    display_name TEXT NOT NULL, -- 'Harikrishnan' or 'Rinta Maria'
    pet_name TEXT NOT NULL,     -- 'Hari' or 'Rintamol'
    partner_role TEXT NOT NULL CHECK (partner_role IN ('hari', 'rinta')),
    avatar_url TEXT,
    battery_level INT DEFAULT 100,
    is_sleeping BOOLEAN DEFAULT false,
    current_mood TEXT DEFAULT 'peaceful', -- 'craving_sweets', 'cramps_tired', 'happy', 'stressed_family'
    last_active TIMESTAMPTZ DEFAULT timezone('utc', now()),
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now()),
    UNIQUE(user_id),
    UNIQUE(couple_id, partner_role)
);

-- ==============================================================================
-- 3. SAVINGS, SPERRKONTO & MICRO-SACRIFICE JAR
-- ==============================================================================

CREATE TABLE IF NOT EXISTS public.savings_goals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    couple_id UUID NOT NULL REFERENCES public.couples(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    target_amount NUMERIC(12, 2) NOT NULL,
    currency TEXT NOT NULL DEFAULT 'INR' CHECK (currency IN ('INR', 'EUR')),
    category TEXT NOT NULL CHECK (category IN ('blocked_account', 'flights', 'exam', 'emergency_fund', 'marriage_legal')),
    priority INT NOT NULL DEFAULT 1,
    is_completed BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now())
);

CREATE TABLE IF NOT EXISTS public.savings_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    couple_id UUID NOT NULL REFERENCES public.couples(id) ON DELETE CASCADE,
    user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    goal_id UUID REFERENCES public.savings_goals(id) ON DELETE SET NULL,
    amount NUMERIC(12, 2) NOT NULL,
    currency TEXT NOT NULL DEFAULT 'INR' CHECK (currency IN ('INR', 'EUR')),
    title TEXT NOT NULL,
    note TEXT,
    log_type TEXT NOT NULL DEFAULT 'deposit' CHECK (log_type IN ('deposit', 'micro_sacrifice_coin', 'gift')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now())
);

-- ==============================================================================
-- 4. HAPPINESS FEATURES: RINTAMOL'S COUPONS & GERMANY DATE BUCKET LIST
-- ==============================================================================

CREATE TABLE IF NOT EXISTS public.comfort_coupons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    couple_id UUID NOT NULL REFERENCES public.couples(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    icon_name TEXT DEFAULT 'gift',
    is_redeemed BOOLEAN DEFAULT false,
    redeemed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now())
);

CREATE TABLE IF NOT EXISTS public.germany_dream_dates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    couple_id UUID NOT NULL REFERENCES public.couples(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    location TEXT DEFAULT 'Germany',
    is_achieved BOOLEAN DEFAULT false,
    photo_storage_path TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now())
);

CREATE TABLE IF NOT EXISTS public.balcony_flowers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    couple_id UUID NOT NULL REFERENCES public.couples(id) ON DELETE CASCADE,
    sender_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    flower_type TEXT NOT NULL DEFAULT 'rose',
    message TEXT,
    bloomed_at DATE NOT NULL DEFAULT CURRENT_DATE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now())
);

-- ==============================================================================
-- 5. GERMANY ROADMAP & COURAGE VAULT
-- ==============================================================================

CREATE TABLE IF NOT EXISTS public.germany_milestones (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    couple_id UUID NOT NULL REFERENCES public.couples(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    category TEXT NOT NULL CHECK (category IN ('language', 'aps', 'documents', 'finance', 'visa', 'flight', 'housing')),
    target_date DATE NOT NULL,
    order_index INT NOT NULL DEFAULT 0,
    is_completed BOOLEAN NOT NULL DEFAULT false,
    completed_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    completed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now())
);

-- author_id is nullable to allow starter template seed cards
CREATE TABLE IF NOT EXISTS public.love_deck_cards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    couple_id UUID NOT NULL REFERENCES public.couples(id) ON DELETE CASCADE,
    author_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    card_number INT NOT NULL,
    reason_text TEXT NOT NULL,
    revealed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now())
);

-- author_id is nullable to allow starter fridge sticky notes
CREATE TABLE IF NOT EXISTS public.sticky_notes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    couple_id UUID NOT NULL REFERENCES public.couples(id) ON DELETE CASCADE,
    author_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    note_text TEXT NOT NULL,
    color_hex TEXT DEFAULT '#FFF3B0',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now())
);

CREATE TABLE IF NOT EXISTS public.courage_vault_entries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    couple_id UUID NOT NULL REFERENCES public.couples(id) ON DELETE CASCADE,
    author_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    title TEXT NOT NULL,
    category TEXT NOT NULL CHECK (category IN (
        'crisis_support',
        'sacred_vow',
        'time_locked_envelope',
        'voice_love_pill',
        'sma_legal_plan',
        'scratch_date_card'
    )),
    content_encrypted TEXT NOT NULL,
    audio_storage_path TEXT,
    is_scratched BOOLEAN DEFAULT false,
    unlock_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now())
);

-- ==============================================================================
-- 6. DAILY CAPSULE & MEMORY QUESTIONS
-- ==============================================================================

CREATE TABLE IF NOT EXISTS public.daily_capsule_answers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    couple_id UUID NOT NULL REFERENCES public.couples(id) ON DELETE CASCADE,
    author_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    prompt_date DATE NOT NULL DEFAULT CURRENT_DATE,
    prompt_question TEXT NOT NULL,
    answer TEXT NOT NULL,
    photo_storage_path TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now()),
    UNIQUE(couple_id, author_id, prompt_date)
);

CREATE TABLE IF NOT EXISTS public.firsts_chronicle (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    couple_id UUID NOT NULL REFERENCES public.couples(id) ON DELETE CASCADE,
    event_title TEXT NOT NULL,
    event_date DATE NOT NULL,
    story TEXT,
    photo_storage_path TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now())
);

-- ==============================================================================
-- 7. ROW LEVEL SECURITY (RLS) POLICIES
-- ==============================================================================

ALTER TABLE public.couples ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.couple_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.savings_goals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.savings_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.comfort_coupons ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.germany_dream_dates ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.balcony_flowers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.germany_milestones ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.love_deck_cards ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sticky_notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.courage_vault_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.daily_capsule_answers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.firsts_chronicle ENABLE ROW LEVEL SECURITY;

CREATE OR REPLACE FUNCTION public.get_current_couple_id()
RETURNS UUID AS $$
    SELECT couple_id FROM public.couple_members WHERE user_id = auth.uid() LIMIT 1;
$$ LANGUAGE sql SECURITY DEFINER STABLE;

CREATE POLICY "couple_members_access" ON public.couple_members FOR ALL USING (couple_id = public.get_current_couple_id() OR user_id = auth.uid());
CREATE POLICY "couples_access" ON public.couples FOR ALL USING (id = public.get_current_couple_id());
CREATE POLICY "savings_goals_access" ON public.savings_goals FOR ALL USING (couple_id = public.get_current_couple_id());
CREATE POLICY "savings_logs_access" ON public.savings_logs FOR ALL USING (couple_id = public.get_current_couple_id());
CREATE POLICY "comfort_coupons_access" ON public.comfort_coupons FOR ALL USING (couple_id = public.get_current_couple_id());
CREATE POLICY "germany_dream_dates_access" ON public.germany_dream_dates FOR ALL USING (couple_id = public.get_current_couple_id());
CREATE POLICY "balcony_flowers_access" ON public.balcony_flowers FOR ALL USING (couple_id = public.get_current_couple_id());
CREATE POLICY "germany_milestones_access" ON public.germany_milestones FOR ALL USING (couple_id = public.get_current_couple_id());
CREATE POLICY "love_deck_cards_access" ON public.love_deck_cards FOR ALL USING (couple_id = public.get_current_couple_id());
CREATE POLICY "sticky_notes_access" ON public.sticky_notes FOR ALL USING (couple_id = public.get_current_couple_id());
CREATE POLICY "courage_vault_access" ON public.courage_vault_entries FOR ALL USING (couple_id = public.get_current_couple_id());
CREATE POLICY "daily_capsule_answers_access" ON public.daily_capsule_answers FOR ALL USING (couple_id = public.get_current_couple_id());
CREATE POLICY "firsts_chronicle_access" ON public.firsts_chronicle FOR ALL USING (couple_id = public.get_current_couple_id());

-- ==============================================================================
-- 8. REALTIME CONFIGURATION
-- ==============================================================================

ALTER PUBLICATION supabase_realtime ADD TABLE public.comfort_coupons;
ALTER PUBLICATION supabase_realtime ADD TABLE public.balcony_flowers;
ALTER PUBLICATION supabase_realtime ADD TABLE public.sticky_notes;
ALTER PUBLICATION supabase_realtime ADD TABLE public.daily_capsule_answers;
ALTER PUBLICATION supabase_realtime ADD TABLE public.savings_logs;
ALTER PUBLICATION supabase_realtime ADD TABLE public.couple_members;
