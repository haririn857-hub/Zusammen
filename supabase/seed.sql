-- ==============================================================================
-- SEED DATA: supabase/seed.sql
-- Project: Zusammen (Für Immer) — Harikrishnan & Rinta Maria
-- ==============================================================================

DO $$
DECLARE
    v_couple_id UUID := '11111111-1111-1111-1111-111111111111';
BEGIN

    -- 1. Insert Couple Record
    INSERT INTO public.couples (
        id,
        couple_name,
        passcode_hash,
        target_germany_date,
        target_savings_eur,
        target_savings_inr,
        first_date,
        flowers_bloomed
    ) VALUES (
        v_couple_id,
        'Harimon & Rintamol',
        crypt('our_secret_2028', gen_salt('bf')),
        '2028-10-01',
        11904.00,
        1350000.00,
        '2024-01-01',
        14
    ) ON CONFLICT (id) DO NOTHING;

    -- 2. Insert Core Germany Milestones (2026 -> 2028)
    INSERT INTO public.germany_milestones (
        couple_id, title, description, category, target_date, order_index, is_completed
    ) VALUES
    (v_couple_id, 'Goethe German A1 Certification', 'Complete first level German exam together with 80%+ score', 'language', '2027-01-15', 1, false),
    (v_couple_id, 'APS Certification (India)', 'Submit university degree transcripts & verify education with APS India', 'aps', '2027-04-01', 2, false),
    (v_couple_id, 'Special Marriage Act (SMA) Legal Locker', 'Compile 10th certificates, PAN, witness list & safe registrar file', 'documents', '2027-06-01', 3, false),
    (v_couple_id, 'Goethe German B1 Certification', 'Reach conversational fluency for daily German work & life', 'language', '2027-09-30', 4, false),
    (v_couple_id, 'Sperrkonto Blocked Account Funded (€11,904)', 'Total blocked account deposit completed in Expatrio / Fintiba', 'finance', '2028-03-31', 5, false),
    (v_couple_id, 'German National Visa Appointment (VFS)', 'Submit passport and spouse/student visa application', 'visa', '2028-06-15', 6, false),
    (v_couple_id, 'Our Flight to Frankfurt / Munich!', 'Take off hand in hand — start our lifetime dream together in Germany!', 'flight', '2028-10-01', 7, false)
    ON CONFLICT DO NOTHING;

    -- 3. Insert Savings Goals
    INSERT INTO public.savings_goals (
        couple_id, title, target_amount, currency, category, priority
    ) VALUES
    (v_couple_id, 'Sperrkonto (Blocked Account)', 11904.00, 'EUR', 'blocked_account', 1),
    (v_couple_id, 'Flight Tickets to Frankfurt', 120000.00, 'INR', 'flights', 2),
    (v_couple_id, 'Goethe Exam & APS Fees', 45000.00, 'INR', 'exam', 3),
    (v_couple_id, 'First Apartment Deposit in Germany', 1800.00, 'EUR', 'emergency_fund', 4)
    ON CONFLICT DO NOTHING;

    -- 4. Insert Rintamol's Comfort Coupon Book
    INSERT INTO public.comfort_coupons (
        couple_id, title, description, icon_name, is_redeemed
    ) VALUES
    (v_couple_id, 'Win Any Silly Argument Instantly', 'Harimon must surrender immediately with a smile & chocolate!', 'crown', false),
    (v_couple_id, 'Midnight Maggi / Hot Chai Made by Harimon', 'Prepared lovingly by Harimon whenever Rintamol craves it.', 'ramen_dining', true),
    (v_couple_id, '30 Minutes of Hair Oiling & Head Massage', 'Complete relaxation without complaints.', 'spa', false),
    (v_couple_id, 'Unlimited Venting Session', 'Harimon listens quietly with zero advice, just hugs and understanding.', 'favorite', false),
    (v_couple_id, '1 Sweet Pastry / Ice Cream Treat', 'Paid from Harimon’s pocket with love.', 'icecream', false)
    ON CONFLICT DO NOTHING;

    -- 5. Insert Germany Dream Date Bucket List
    INSERT INTO public.germany_dream_dates (
        couple_id, title, location
    ) VALUES
    (v_couple_id, 'Making our first snowman in the Bavarian snow', 'Bavarian Alps'),
    (v_couple_id, 'Visiting Neuschwanstein Fairytale Castle holding hands', 'Schwangau, Germany'),
    (v_couple_id, 'Eating warm Apfelstrudel in a cozy wooden cafe', 'Munich Old Town'),
    (v_couple_id, 'Renting bicycles and riding through English Garden in spring', 'Munich, Germany'),
    (v_couple_id, 'Walking through Christmas Markets drinking hot spiced cider', 'Nuremberg / Munich')
    ON CONFLICT DO NOTHING;

    -- 6. Insert Initial Love Deck Cards (author_id is NULL for starter system templates)
    INSERT INTO public.love_deck_cards (
        couple_id, author_id, card_number, reason_text
    ) VALUES
    (v_couple_id, NULL, 1, 'Because when you laugh, all the stress of my work and low salary disappears into peace.'),
    (v_couple_id, NULL, 2, 'Because you stood beside me and believed in our Germany dream when everyone else doubted us.'),
    (v_couple_id, NULL, 3, 'Because in your eyes, I see my home, my strength, and my forever wife.')
    ON CONFLICT DO NOTHING;

    -- 7. Insert Morning Sticky Note (author_id is NULL for starter system templates)
    INSERT INTO public.sticky_notes (
        couple_id, author_id, note_text, color_hex, is_active
    ) VALUES
    (v_couple_id, NULL, 'Good morning Rintamol! Drink warm water, don’t skip lunch, and remember: today is one step closer to Munich! ❤️ — Your Hari', '#FFF3B0', true)
    ON CONFLICT DO NOTHING;

END $$;
