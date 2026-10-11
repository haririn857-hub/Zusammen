# 05. Step-by-Step GitHub & Multiplatform Deployment Procedure
## Complete Practical Guide for Android (Hari), iOS (Rintamol), and Web

---

## Phase 1: GitHub Repository Setup

### Step 1.1: Initialize Git and Create Local Project
Open PowerShell on your computer and run:
```powershell
# Navigate to your GitHub development directory
cd C:\Users\harik\Documents\GitHub\zusammen

# Initialize Git
git init
git checkout -b main
```

### Step 1.2: Connect to your GitHub Repository
```powershell
git remote add origin https://github.com/harikrishnananish0/germany-dream-app.git
git add .
git commit -m "feat: initial commit - our lifetime zusammen germany dream app"
git push -u origin main
```

---

## Phase 2: Supabase Backend Setup (100% Free Tier)

### Step 2.1: Create your Supabase Project
1. Log in to [Supabase](https://supabase.com).
2. Click **New Project**:
   - **Name**: `zusammen`
   - **Database Password**: Choose a strong password and save it safely.
   - **Region**: Select `Frankfurt (eu-central-1)` (since you are moving to Germany!) or `Mumbai (ap-south-1)`.
3. Once provisioned, navigate to **Project Settings → API**:
   - Copy **Project URL** (`https://xyzcompany.supabase.co`)
   - Copy **anon public key** (`eyJhbGci...`)

### Step 2.2: Execute Database Schema
1. In the Supabase Dashboard, open **SQL Editor** from the left navigation.
2. Click **New Query**.
3. Copy the entire contents of [**`03_SUPABASE_DATABASE_SCHEMA.sql`**](file:///C:/Users/harik/Documents/GitHub/zusammen/docs/03_SUPABASE_DATABASE_SCHEMA.sql) and paste it into the editor.
4. Click **Run**. All tables, security policies, and Realtime channels are now active!

---

## Phase 3: Android Deployment (For Harikrishnan's Phone)

### Option A: Direct USB Run
1. Enable **Developer Options & USB Debugging** on your Android device.
2. Connect your phone via USB cable and run:
```powershell
flutter run -d android
```

### Option B: Build Release APK
```powershell
flutter build apk --release
```
Your compiled APK will be at:
`build\app\outputs\flutter-apk\app-release.apk`  
Transfer this to your phone via USB or WhatsApp and install it directly!

---

## Phase 4: iOS Deployment Guide (For Rintamol's iPhone)

Because you develop on a Windows PC and Rinta uses an iPhone, here are the **two exact options**:

### 🌟 Option 1: The Instant Safari PWA (Recommended for Day 1 — ₹0 & Zero Effort)
Flutter compiles directly to Web, and on iOS Safari it transforms into a full-screen app:
1. Deploy the Web build to Vercel or GitHub Pages (see Phase 5 below).
2. Open the URL on **Safari** on Rinta's iPhone.
3. Tap the **Share** button (box with upward arrow at the bottom of Safari).
4. Tap **"Add to Home Screen"**.
5. **How it behaves on her iPhone**:
   - Opens as a standalone app with its own custom icon.
   - **No browser address bar or bottom navigation** (looks 100% native).
   - Realtime balance, coin drop jar, countdown, scratch cards, audio voice notes, and touch coordinates work instantly.
   - *Note on vibration*: Apple restricts web vibration API on Safari, so while sound effects and glows work, physical vibrations require Option 2.

---

### 🚀 Option 2: Full Native iOS Build (With Apple Taptic Engine Vibration) for ₹0 Without a Mac!
If you want Rinta to feel the **actual physical haptic heartbeat vibration** on her iPhone, you can build a native iOS `.ipa` for free without buying a Mac or paying Apple's $99/year fee:

1. **Cloud Compilation via GitHub Actions (Free macOS Runner)**:
   - GitHub Actions provides free macOS virtual machines that compile your Flutter app into an iOS `.ipa` automatically on every git commit.
2. **Installation via Sideloadly or AltStore (Free on Windows)**:
   - Install **Sideloadly** (free tool for Windows) on your computer.
   - Connect Rinta’s iPhone to your Windows PC with a Lightning/USB-C cable.
   - Sign the generated `.ipa` with her regular, free personal Apple ID.
   - Sideloadly installs the real native iOS app onto her iPhone!
   - Now her iPhone has full access to the Apple Taptic Engine (vibrates with your exact heartbeat).

---

## Phase 5: Web Deployment (Instant Shared Access on Any Browser)

### Deploying to Vercel for Free in 2 Minutes:
```powershell
flutter build web --release
npx vercel build/web --prod
```
Now both of you have an instant, private `https://zusammen-app.vercel.app` URL accessible from your phones, laptops, and tablets 24/7.

---

## Phase 6: Automated GitHub Actions CI/CD Pipeline

Create `.github/workflows/deploy.yml` in your repository:

```yaml
name: Build & Deploy Zusammen

on:
  push:
    branches: [ main ]

jobs:
  build_android_and_web:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Java
        uses: actions/setup-java@v4
        with:
          distribution: 'zulu'
          java-version: '17'

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.3'
          channel: 'stable'

      - name: Install Dependencies
        run: flutter pub get

      - name: Build Android APK
        run: flutter build apk --release

      - name: Build Web
        run: flutter build web --release

      - name: Upload Android APK
        uses: actions/upload-artifact@v4
        with:
          name: zusammen-android-apk
          path: build/app/outputs/flutter-apk/app-release.apk

      - name: Deploy Web to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./build/web
```

Every push automatically updates your Web app and generates a fresh Android APK!
