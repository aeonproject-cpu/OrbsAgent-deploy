# Task: HTML Structure & Semantics

**Type:** html  
**Priority:** P1  
**Status:** completed (implemented di index.html)  
**File:** `index.html` — 2809 baris total  
**Estimasi:** referensi dokumentasi

---

## Tujuan

Mendokumentasikan struktur HTML lengkap project Orbs Agent: hierarki elemen, semantik, dan pola yang digunakan.

---

## Struktur Dokumen

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <!-- Meta, Fonts, Tailwind, Custom CSS -->
</head>
<body>
  <!-- Cursor elements -->
  <!-- Navigation -->
  <!-- Hero Section -->
  <!-- Marquee Ticker -->
  <!-- Problem Section -->
  <!-- How It Works Section -->
  <!-- Roadmap Section -->
  <!-- CTA Section -->
  <!-- Footer -->
  <!-- Whitepaper Modal -->
  <!-- API Reference Modal -->
  <!-- Script -->
</body>
</html>
```

---

## Head

```html
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>ORB.S AGENT — The Reputation Protocol</title>

  <!-- Google Fonts preconnect (performance) -->
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display...&family=Inter...&display=swap" rel="stylesheet" />

  <!-- TailwindCSS CDN -->
  <script src="https://cdn.tailwindcss.com"></script>

  <!-- Tailwind custom config -->
  <script>tailwind.config = { theme: { extend: { ... } } }</script>

  <!-- Custom CSS (~1100 baris) -->
  <style> ... </style>
</head>
```

**Catatan penting:**
- `rel="preconnect"` pada Google Fonts: mengurangi latency koneksi awal
- `display=swap` pada font URL: mencegah flash of invisible text (FOIT)
- Tailwind diload dari CDN (tidak di-build lokal) — cocok untuk static site

---

## Body — Elemen per Elemen

### 1. Custom Cursor
```html
<div class="cursor" id="cursor"></div>
<div class="cursor-glow" id="cursorGlow"></div>
```
- Dua `div` kosong, diposisikan `fixed` via CSS
- Digerakkan oleh JavaScript via `style.left/top`
- `cursor-glow` mengikuti mouse dengan lag (easing via RAF)

---

### 2. Navigation
```html
<nav>
  <div class="nav-inner">
    <a href="#" class="logo">ORBS &nbsp;&nbsp;AGENT</a>
    <ul class="nav-links">
      <li><a href="#how">Explorer</a></li>
      <li><a href="#" id="docsBtn">Docs</a></li>
      <li><a href="#problem">Manifesto</a></li>
      <li><a href="https://github.com" target="_blank" rel="noopener">Github</a></li>
      <li><a href="#" id="apiBtn" class="btn-outline">API</a></li>
      <li><a href="#cta" class="btn-pink">BUY ORBS</a></li>
    </ul>
  </div>
</nav>
```

**Poin semantik:**
- `<nav>` untuk navigasi utama (landmark HTML5)
- `<ul>` + `<li>` untuk list navigasi (screen reader friendly)
- `target="_blank"` + `rel="noopener"` pada link eksternal (security best practice)
- `id="docsBtn"` dan `id="apiBtn"` untuk JS event listener

---

### 3. Hero Section
```html
<section style="background:#050505; position:relative; overflow:hidden;">
  <div class="bg-grid"></div>            <!-- dot grid background -->
  <div style="...radial gradient..."></div>  <!-- pink glow blob -->

  <div class="hero">
    <!-- LEFT -->
    <div class="hero-left">
      <p class="hero-eyebrow fade-in">
        <span class="dot-accent"></span>
        EST. 2026 — THE REPUTATION PROTOCOL
      </p>
      <h1 class="hero-headline fade-in fade-in-delay-1">
        ORBS<br/>
        <span class="pink-italic">AGENT</span>
      </h1>
    </div>

    <!-- RIGHT -->
    <div class="hero-right fade-in fade-in-delay-2">
      <hr class="hr-pink" />
      <p class="hero-body"> ... </p>
      <div class="hero-buttons">
        <a href="#cta" class="btn-pink">BUY ORBS</a>
        <a href="#problem" class="btn-outline">READ MORE</a>
      </div>
    </div>
  </div>
</section>
```

**Poin penting:**
- `<h1>` hanya ada SATU di halaman — SEO best practice
- `fade-in` + `fade-in-delay-N` classes untuk staggered animation
- `<hr class="hr-pink">` sebagai dekorasi separator

---

### 4. Marquee Ticker
```html
<div class="marquee-wrapper">
  <div class="marquee-track">
    <!-- 16 item (8 duplikat untuk seamless loop) -->
    <span class="marquee-item">On-Chain Identity <span class="marquee-sep">✦</span></span>
    ...
  </div>
</div>
```

**Pola duplikasi:**  
Konten diulang 2x (8 item × 2 = 16). CSS animation menggeser `-50%` sehingga saat elemen pertama habis, elemen duplikat sudah di posisi yang sama → loop seamless tanpa JavaScript.

---

### 5. Problem Section
```html
<section id="problem" style="background:#050505;">
  <div class="problem-section">
    <!-- LEFT: Judul + 3 kolom teks -->
    <div class="problem-left">
      <p class="section-label fade-in">01 — The Problem</p>
      <h2 class="section-title fade-in fade-in-delay-1">
        The Agent Economy Is Running on <span class="pink-italic">Blind Faith</span>
      </h2>
      <div class="problem-columns">
        <div>Anonymous ...</div>
        <div>Disposable ...</div>
        <div>Unverifiable ...</div>
      </div>
    </div>

    <!-- RIGHT: Stat block -->
    <div class="problem-right fade-in fade-in-delay-2">
      <div class="stat-item"> 0 — agent identity standards </div>
      <div class="stat-item"> $0 — accountability </div>
      <div class="stat-item"> ∞ — agents operating daily </div>
    </div>
  </div>
</section>
```

**Semantik:** `<h2>` untuk section heading (hierarki di bawah `<h1>`)

---

### 6. How It Works
```html
<section id="how" class="how-section">
  <div class="how-inner">
    <div class="how-header">
      <p class="section-label">02 — The Protocol</p>
      <h2 class="how-title">Not a dashboard. Not a whitepaper. Infrastructure.</h2>
    </div>
    <div class="how-grid">
      <div class="how-card fade-in">
        <p class="how-number">01 — Register</p>
        <h3 class="how-card-title">Register</h3>
        <p class="how-card-text">...</p>
      </div>
      <!-- × 4 cards -->
    </div>
  </div>
</section>
```

**Semantik:** `<h3>` untuk card titles (satu level di bawah `<h2>`)

---

### 7. Roadmap
```html
<section id="roadmap" style="...">
  <div class="roadmap-section">
    <div class="roadmap-header">...</div>
    <div class="roadmap-timeline">
      <div class="roadmap-item active fade-in">
        <div><p class="roadmap-phase active">Phase 1</p></div>
        <div>
          <h3 class="roadmap-title">Launch</h3>
          <p class="roadmap-desc">...</p>
        </div>
      </div>
      <!-- × 4 phases -->
    </div>
  </div>
</section>
```

**Pola active state:** Class `.active` pada `.roadmap-item` dan `.roadmap-phase` untuk fase yang sedang berjalan (Phase 1).

---

### 8. CTA Section
```html
<section id="cta" class="cta-section">
  <div class="cta-inner">
    <p class="cta-label fade-in">
      <span class="dot-accent"></span>Join The Protocol
    </p>
    <h2 class="cta-title fade-in fade-in-delay-1">
      The agent economy needs <span class="pink-italic">accountability.</span>
    </h2>
    <div class="cta-buttons fade-in fade-in-delay-2">
      <a href="#" class="btn-pink">BUY ORBS</a>
      <a href="#" class="btn-outline">FOLLOW THE BUILD</a>
    </div>
  </div>
</section>
```

---

### 9. Footer
```html
<footer>
  <div class="footer-inner">
    <p class="footer-copy">&copy; 2026 Orbs Agent. All rights reserved.</p>
    <ul class="footer-links">
      <li><a href="#">Twitter</a></li>
      <li><a href="#">Github</a></li>
    </ul>
  </div>
</footer>
```

**Semantik:** `<footer>` landmark HTML5, `<ul>` untuk list link footer.

---

## Pola HTML yang Digunakan

### Fade-in dengan Delay

```html
<el class="fade-in">              <!-- delay 0 -->
<el class="fade-in fade-in-delay-1"> <!-- delay 0.1s -->
<el class="fade-in fade-in-delay-2"> <!-- delay 0.2s -->
<el class="fade-in fade-in-delay-3"> <!-- delay 0.3s -->
```

### Pink Italic Accent

```html
<span class="pink-italic">kata</span>
```

Digunakan untuk highlight kata kunci di headline (accent warna pink + italic serif).

### Section IDs untuk Navigasi

```html
<section id="problem">
<section id="how">
<section id="roadmap">
<section id="cta">
```

Navbar menggunakan `href="#problem"` dll untuk smooth scroll.

---

## Checklist Semantik

- [x] Satu `<h1>` per halaman
- [x] Hierarki heading: h1 → h2 → h3
- [x] `<nav>` dengan `<ul>/<li>` untuk navigasi
- [x] `<footer>` landmark
- [x] `lang="en"` pada `<html>`
- [x] `charset="UTF-8"` pada `<meta>`
- [x] `viewport` meta untuk responsif
- [x] `rel="noopener"` pada `target="_blank"`
- [ ] Meta description (belum ada — bisa ditambahkan)
- [ ] Open Graph tags (belum ada — untuk social sharing)
- [ ] Alt text pada gambar (tidak ada gambar saat ini)
