# Task: Deployment & Hosting

**Type:** deployment  
**Priority:** P2  
**Status:** pending  
**Estimasi:** 1–2 jam (tergantung platform pilihan)

---

## Tujuan

Men-deploy landing page Orbs Agent ke internet agar bisa diakses publik. Project ini adalah static site (satu file HTML) sehingga pilihan hosting sangat luas dan murah.

---

## Opsi Deployment

### Opsi 1 — GitHub Pages (Recommended, Gratis)

**Kelebihan:**
- Gratis selamanya
- Deploy otomatis dari push ke `main`
- URL: `username.github.io/orbs-agent`
- Custom domain didukung

**Cara setup:**

```bash
# Pastikan sudah push ke GitHub (Task setup)
# Buka repo di GitHub → Settings → Pages
# Source: Deploy from a branch
# Branch: main
# Folder: / (root)
# Save
```

URL akan aktif dalam 1–2 menit: `https://username.github.io/orbs-agent`

**Untuk custom domain (contoh: orbsagent.xyz):**
1. Beli domain di Namecheap/Cloudflare/dll
2. Settings → Pages → Custom domain → masukkan domain
3. Di DNS provider, tambahkan:
   ```
   CNAME  www  username.github.io
   A      @    185.199.108.153
   A      @    185.199.109.153
   A      @    185.199.110.153
   A      @    185.199.111.153
   ```
4. Centang "Enforce HTTPS"

---

### Opsi 2 — Vercel (Gratis, Lebih Cepat)

**Kelebihan:**
- Deploy dalam hitungan detik
- Edge network global (CDN otomatis)
- Preview URL untuk setiap commit
- Analytics gratis
- URL: `orbs-agent.vercel.app`

**Cara setup:**
```bash
# Install Vercel CLI
npm i -g vercel

# Deploy dari folder project
cd "/Users/indralesmana/Documents/projects/orbs agent"
vercel

# Ikuti wizard:
# - Set up and deploy: Y
# - Project name: orbs-agent
# - Directory: ./
# - Override settings: N
```

Atau via web: vercel.com → Import Git Repository → pilih repo GitHub.

---

### Opsi 3 — Netlify (Gratis, Drag & Drop)

**Cara paling cepat:**
1. Buka netlify.com
2. Drag & drop folder project ke dashboard
3. Selesai — URL langsung aktif

**Via Git (auto-deploy):**
1. netlify.com → New site from Git
2. Connect GitHub → pilih repo
3. Build command: (kosong — tidak ada build)
4. Publish directory: `.` (root)
5. Deploy

---

### Opsi 4 — Cloudflare Pages (Gratis, Tercepat)

**Kelebihan:**
- CDN Cloudflare — tercepat secara global
- Gratis unlimited bandwidth
- Deploy dari GitHub

**Cara setup:**
1. dash.cloudflare.com → Pages → Create a project
2. Connect to Git → pilih repo
3. Build settings: semua kosong (static site)
4. Deploy

---

## Persiapan Pre-Deployment

### 1. Update Link Real di HTML

Sebelum deploy, ganti placeholder `#` dengan URL real:

```html
<!-- Footer -->
<li><a href="https://twitter.com/orbsagent">Twitter</a></li>
<li><a href="https://github.com/USERNAME/orbs-agent">Github</a></li>

<!-- Navbar -->
<a href="https://github.com/USERNAME/orbs-agent" target="_blank" rel="noopener">Github</a>

<!-- BUY ORBS buttons -->
<a href="https://[exchange-url]" class="btn-pink">BUY ORBS</a>

<!-- FOLLOW THE BUILD -->
<a href="https://twitter.com/orbsagent" class="btn-outline">FOLLOW THE BUILD</a>
```

---

### 2. Tambahkan Meta Tags SEO

```html
<head>
  <!-- Existing tags... -->

  <!-- SEO -->
  <meta name="description" content="Orbs Agent — On-chain identity and reputation layer for AI agents. Verify before you trust. Stake against behavior. Make trust programmable." />
  <meta name="keywords" content="AI agents, blockchain, reputation, identity, ORBS, crypto, DeFi" />
  <meta name="author" content="Orbs Agent" />

  <!-- Open Graph (social sharing) -->
  <meta property="og:type" content="website" />
  <meta property="og:url" content="https://orbsagent.xyz/" />
  <meta property="og:title" content="ORBS AGENT — The Reputation Protocol" />
  <meta property="og:description" content="On-chain identity and reputation layer for AI agents." />
  <meta property="og:image" content="https://orbsagent.xyz/og-image.png" />

  <!-- Twitter Card -->
  <meta name="twitter:card" content="summary_large_image" />
  <meta name="twitter:site" content="@orbsagent" />
  <meta name="twitter:title" content="ORBS AGENT — The Reputation Protocol" />
  <meta name="twitter:description" content="On-chain identity and reputation layer for AI agents." />
  <meta name="twitter:image" content="https://orbsagent.xyz/og-image.png" />

  <!-- Canonical -->
  <link rel="canonical" href="https://orbsagent.xyz/" />
</head>
```

---

### 3. Buat Favicon

```html
<head>
  <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
  <link rel="icon" type="image/png" href="/favicon.png" />
  <link rel="apple-touch-icon" href="/apple-touch-icon.png" />
</head>
```

**Favicon minimal (SVG inline):**
```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32">
  <rect width="32" height="32" fill="#050505"/>
  <circle cx="16" cy="16" r="8" fill="#ff007a"/>
</svg>
```

---

### 4. Optimasi Performance

#### Self-host Google Fonts (opsional)
Saat ini menggunakan Google Fonts CDN. Untuk performa lebih baik:
1. Download font files dari fonts.google.com
2. Simpan di `/fonts/`
3. Gunakan `@font-face` lokal

```css
@font-face {
  font-family: 'Playfair Display';
  font-style: normal;
  font-weight: 900;
  font-display: swap;
  src: url('/fonts/playfair-display-900.woff2') format('woff2');
}
```

#### Build Tailwind CSS (opsional, production)
Saat ini Tailwind di-load dari CDN dan di-generate di browser. Untuk production:

```bash
npm init -y
npm install -D tailwindcss

# Pisahkan CSS ke file terpisah
npx tailwindcss init

# tailwind.config.js
module.exports = {
  content: ['./index.html'],
  // custom theme...
}

# Build
npx tailwindcss -i ./src/input.css -o ./dist/output.css --minify
```

Hasil: CSS file kecil hanya berisi utility yang benar-benar dipakai.

---

### 5. Buat `robots.txt`

```txt
User-agent: *
Allow: /

Sitemap: https://orbsagent.xyz/sitemap.xml
```

---

### 6. Buat `sitemap.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://orbsagent.xyz/</loc>
    <lastmod>2026-04-01</lastmod>
    <changefreq>monthly</changefreq>
    <priority>1.0</priority>
  </url>
</urlset>
```

---

## Checklist Pre-Deploy

- [ ] Semua link placeholder `#` diganti URL real
- [ ] Meta description ditambahkan
- [ ] Open Graph tags ditambahkan
- [ ] Favicon dibuat
- [ ] `robots.txt` dibuat
- [ ] Test di Chrome, Firefox, Safari
- [ ] Test di mobile (375px, 768px)
- [ ] Test keyboard navigation (Tab, Enter, Esc)
- [ ] `navigator.clipboard` test di HTTPS

## Checklist Post-Deploy

- [ ] URL bisa diakses publik
- [ ] HTTPS aktif
- [ ] Fonts load dengan benar
- [ ] Marquee animasi berjalan
- [ ] Modal API dan Whitepaper buka/tutup
- [ ] Smooth scroll berfungsi
- [ ] Custom cursor tampil
- [ ] Tidak ada console error

---

## Performance Target

| Metrik | Target |
|---|---|
| First Contentful Paint | < 1.5s |
| Largest Contentful Paint | < 2.5s |
| Total Blocking Time | < 200ms |
| Cumulative Layout Shift | < 0.1 |
| Lighthouse Score | > 85 |

**Cara test:** Chrome DevTools → Lighthouse → Generate report
