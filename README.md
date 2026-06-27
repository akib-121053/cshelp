# 🛡️ CyberSec Dictionary — PWA

> ৮০/২০ নীতিতে A–Z সাইবার সিকিউরিটি শব্দভাণ্ডার | Supabase Real-time | PWA

## ⚡ DEPLOY করার ধাপ (১৫ মিনিট)

### ধাপ ১ — Supabase সেটআপ

1. [supabase.com](https://supabase.com) → **New Project** তৈরি করুন
2. **SQL Editor** → `supabase_setup.sql` paste করুন → **Run**
3. **SQL Editor** → `supabase_additional_terms.sql` paste করুন → **Run** (৫৭টি নতুন টার্ম)
3. **Project Settings → API** থেকে নিন:
   - `Project URL` → `REACT_APP_SUPABASE_URL`
   - `anon public key` → `REACT_APP_SUPABASE_ANON_KEY`

### ধাপ ২ — GitHub-এ Push

```bash
git init
git add .
git commit -m "🛡️ CyberSec Dictionary PWA"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/cybersec-dict.git
git push -u origin main
```

### ধাপ ৩ — Vercel Deploy

1. [vercel.com](https://vercel.com) → **Add New Project** → GitHub repo import
2. **Settings → Environment Variables** → দুটো variable যোগ করুন:
   ```
   REACT_APP_SUPABASE_URL     = https://xxxx.supabase.co
   REACT_APP_SUPABASE_ANON_KEY = eyJhbGc...
   ```
3. **Deploy** বাটনে ক্লিক করুন ✅

### ধাপ ৪ — PWA Install (Optional)

Chrome/Edge-এ URL-এ গিয়ে address bar-এর ⊕ বোতামে ক্লিক করুন।

---

## 🏗️ Project Structure

```
cybersec-dict/
├── public/
│   ├── index.html          # PWA HTML
│   ├── manifest.json       # PWA manifest
│   └── sw.js               # Service Worker (offline)
├── src/
│   ├── App.js              # Main app + Supabase real-time
│   ├── index.js            # Entry point
│   ├── index.css           # Tailwind + custom styles
│   ├── lib/
│   │   └── supabase.js     # Supabase client
│   ├── data/
│   │   └── terms.js        # Seed data (fallback)
│   └── components/
│       ├── Header.js       # Search + A-Z filter
│       ├── StatsBar.js     # Stats dashboard
│       ├── TermCard.js     # Grid/List card
│       ├── TermModal.js    # Detail modal (4 tabs)
│       └── constants.js    # Colors/gradients
├── supabase_setup.sql      # DB schema + seed data
├── vercel.json             # Vercel config
├── tailwind.config.js
├── package.json
└── .env.example
```

## ✨ ফিচার

- 🔴 **Real-time** — Supabase Realtime subscription (INSERT/UPDATE/DELETE instantly)
- 📱 **PWA** — Install করুন, offline কাজ করে
- 🔍 **Smart Search** — term, tag, category, definition সব খোঁজে
- 🔤 **A–Z Filter** — অক্ষর দিয়ে ফিল্টার
- ⭐ **Favorites** — localStorage-এ persist
- 💻 **4-Tab Detail** — সংজ্ঞা, অ্যানালজি, ব্যবহার, কোড
- 🌐 **Online/Offline** indicator
- 📊 **Stats Dashboard**
- 🎨 **Dark Cyberpunk** theme

## 📦 Dependencies

```bash
npm install
```

Main: `react`, `react-dom`, `@supabase/supabase-js`  
Dev: `tailwindcss`, `autoprefixer`, `postcss`

## 🔧 Local Development

```bash
cp .env.example .env.local
# .env.local-এ আপনার Supabase keys বসান

npm install
npm start
```
