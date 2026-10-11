# 06. Supabase 100% Free Tier 2-Year Survival Plan
## Running *Zusammen* on ₹0 / $0 Cost for Harikrishnan & Rinta Maria

---

## 1. The Financial Reality & The Zero-Dollar Commitment

You are currently working on modest salaries and saving every hard-earned rupee for your **Germany Blocked Account (Sperrkonto)**, visa fees, and flight tickets. 
**You must NOT spend $25/month (₹2,100+/month) on paid cloud servers.** That money belongs in your Germany savings!

Because there are **only 2 users (Hari & Rintamol)**, Supabase's Free Tier is more than sufficient for 2 years (and beyond) **if we engineer it smartly**.

---

## 2. Supabase Free Tier Limits vs. Our 2-User Usage

| Resource | Supabase Free Limit | Our 2-User Usage (2 Years) | Safe? |
|---|---|---|---|
| **Database Space** | 500 MB | ~15 - 25 MB (Text, savings logs, daily answers) | 🟢 **95% Free Space Left** |
| **Active Users (MAU)** | 50,000 users | **2 users** (Hari & Rinta) | 🟢 **100% Safe** |
| **File Storage** | 1 GB (1,000 MB) | ~300 MB (With client compression: ~2,000 photos) | 🟢 **Safe with Compression** |
| **Bandwidth (Egress)** | 5 GB / month | ~150 MB / month (Because Drift caches locally!) | 🟢 **97% Free Bandwidth Left** |
| **Realtime Connections** | 200 concurrent | **2 concurrent connections** | 🟢 **100% Safe** |
| **Edge Functions** | 500,000 invocations | ~1,000 / month | 🟢 **100% Safe** |

---

## 3. The 3 Golden Rules to Keep Supabase 100% Free for 2+ Years

### 🛡️ Rule 1: Prevent Inactivity Pausing (The "Never-Sleep" Ping)
> **The Gotcha**: Supabase Free Tier projects automatically pause if there are 0 API requests for 7 consecutive days. While you two will use it almost daily, you might travel, face a family emergency, or have no internet for a week.

**The ₹0 Fix**: A free GitHub Actions Cron workflow that pings your Supabase REST endpoint once every 3 days. Your project will **never pause**, even if you don’t open the app for a month!

Create `.github/workflows/keep_alive.yml`:
```yaml
name: Supabase Keep-Alive Ping

on:
  schedule:
    # Runs every 3 days at midnight UTC
    - cron: '0 0 */3 * *'
  workflow_dispatch: # Allows manual trigger anytime

jobs:
  ping:
    runs-on: ubuntu-latest
    steps:
      - name: Ping Supabase Health Check
        run: |
          curl -s -o /dev/null -w "%{http_code}" \
          -H "apikey: ${{ secrets.SUPABASE_ANON_KEY }}" \
          "${{ secrets.SUPABASE_URL }}/rest/v1/couples?select=id&limit=1"
```

---

### 📸 Rule 2: Client-Side Image Compression (Make 1 GB Last 5 Years)
> **The Gotcha**: Modern phone cameras (especially Rinta’s iPhone) take 5MB–10MB photos. If uploaded directly, 100 photos would exhaust the 1 GB free storage.

**The ₹0 Fix**: In Flutter, before uploading any scrapbook photo or memory picture, compress it on-device to **under 200 KB** using WebP/JPEG compression.
- 1,000 MB ÷ 0.2 MB = **5,000 photos!**
- That is **almost 7 photos every single day for 2 years** without spending a single paisa.

```dart
// Client-side compression before Supabase Storage upload
Future<Uint8List> compressPhotoForVault(Uint8List rawBytes) async {
  return await FlutterImageCompress.compressWithList(
    rawBytes,
    minWidth: 1080,
    minHeight: 1080,
    quality: 75, // Visually indistinguishable on mobile, but file drops from 6MB to 180KB!
    format: CompressFormat.webp,
  );
}
```

---

### ⚡ Rule 3: Local-First Caching via Drift (Save 99% Bandwidth)
Because your app follows your company's `zeldin-flutter-hari` architecture:
1. All savings logs, daily answers, and milestones are stored in your phone’s local SQLite database (Drift).
2. The app **only** asks Supabase for rows that changed since the last sync.
3. Your monthly egress will stay under **150 MB / month** (out of the 5,000 MB free quota).

---

## 4. Disaster Recovery & Zero-Cost Backup (Your Memories are Sacred)

Because these memories, courage notes, and savings logs are irreplaceable:
We set up an automated weekly GitHub Action that exports a private backup of your Supabase database into a private encrypted repository artifact.

Even if Supabase ever had a server hiccup, you will **never lose a single rupee’s record or a single memory with Rintamol**.

---

## 5. Summary: What You Pay
- **Hosting / Supabase Backend**: **₹0.00**
- **Web App Hosting (Vercel / GitHub Pages)**: **₹0.00**
- **Android APK Build**: **₹0.00**
- **iOS Usage (Safari PWA on Rinta's iPhone)**: **₹0.00**
- **Total Monthly Cost**: **₹0.00**

*Every single rupee you earn stays in your pocket and goes straight toward your Germany dream.*
