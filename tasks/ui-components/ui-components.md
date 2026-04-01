# Task: UI Components

**Type:** ui-components  
**Priority:** P1  
**Status:** completed  
**Estimasi:** referensi dokumentasi

---

## Tujuan

Mendokumentasikan setiap komponen UI yang ada di landing page utama Orbs Agent: struktur HTML, CSS yang relevan, dan behavior interaktif.

---

## Komponen Index

1. [Navbar](#1-navbar)
2. [Custom Cursor](#2-custom-cursor)
3. [Hero Section](#3-hero-section)
4. [Marquee Ticker](#4-marquee-ticker)
5. [Problem Section](#5-problem-section)
6. [How It Works Cards](#6-how-it-works-cards)
7. [Roadmap Timeline](#7-roadmap-timeline)
8. [CTA Section](#8-cta-section)
9. [Footer](#9-footer)

---

## 1. Navbar

**File location:** `index.html` — `<nav>` element

### Struktur
```html
<nav>
  <div class="nav-inner">
    Logo | Links | Buttons
  </div>
</nav>
```

### Properties
| Property | Value |
|---|---|
| Position | `fixed` — sticky di atas |
| Height | `64px` |
| Background | `rgba(5,5,5,0.92)` + `backdrop-filter: blur(20px)` |
| Border | `1px solid rgba(255,255,255,0.08)` bottom |
| Max-width | `1440px` centered |
| Z-index | `100` |

### Items
| Item | Href | Type |
|---|---|---|
| ORBS AGENT (logo) | `#` (top) | Text link |
| Explorer | `#how` | Anchor scroll |
| Docs | `#` (opens whitepaper modal) | JS trigger |
| Manifesto | `#problem` | Anchor scroll |
| Github | External URL | `target="_blank"` |
| API | `#` (opens API modal) | JS trigger, `.btn-outline` style |
| BUY ORBS | `#cta` | `.btn-pink` style |

### Responsive
- `≤ 768px`: Semua link kecuali BUY ORBS disembunyikan (`display:none`)
- Masalah: tidak ada hamburger menu — perlu ditambahkan untuk mobile UX yang lebih baik

---

## 2. Custom Cursor

**File location:** `index.html` — dua `div` awal + `<script>`

### Struktur
```html
<div class="cursor" id="cursor"></div>
<div class="cursor-glow" id="cursorGlow"></div>
```

### Properties

| Layer | Size | Style |
|---|---|---|
| `.cursor` | 12px × 12px | Pink solid, `border-radius: 50%`, `mix-blend-mode: screen` |
| `.cursor-glow` | 40px × 40px | Pink transparan 15%, `filter: blur(8px)` |

### Behavior
- `.cursor` mengikuti mouse langsung (no lag)
- `.cursor-glow` mengikuti dengan lag (lerp factor 0.08)
- Saat hover elemen interaktif: `.cursor` membesar ke 20px, opacity 50%
- `body { cursor: none }` menyembunyikan cursor default browser

---

## 3. Hero Section

**File location:** `index.html` — `<section>` pertama setelah nav

### Layout
```
[dot grid bg] [pink glow blob]
┌─────────────────┬──────────────────────────────┐
│ eyebrow text    │                              │
│                 │  ─── pink hr line            │
│ ORBS            │  AI agents are already...    │
│ AGENT (pink)    │  ...                         │
│                 │  [BUY ORBS] [READ MORE]      │
└─────────────────┴──────────────────────────────┘
```

### Key CSS
```css
.hero {
  min-height: 100vh;        /* full screen */
  grid-template-columns: 1fr 1fr;
  gap: 80px;
  padding: 64px 48px 0;     /* offset navbar height */
}

.hero-headline {
  font-size: clamp(72px, 7vw, 112px);
  line-height: 0.92;        /* sangat tight */
}

.hero-right {
  border-left: 1px solid rgba(255,255,255,0.08);
  padding-left: 40px;
}
```

### Background effects
1. **Dot grid:** `linear-gradient` diagonal 60×60px grid
2. **Pink glow blob:** `radial-gradient` 700×700px semi-transparan, absolute positioned

### Animasi
- Eyebrow: fade-in, delay 0
- Headline: fade-in, delay 0.1s
- Right panel: fade-in, delay 0.2s
- Trigger: `DOMContentLoaded` dengan manual `setTimeout` stagger

---

## 4. Marquee Ticker

**File location:** `index.html` — `div.marquee-wrapper`

### Struktur
```html
<div class="marquee-wrapper">
  <div class="marquee-track">
    [8 items] × [duplikat 8 items] = 16 total
  </div>
</div>
```

### Items
```
On-Chain Identity ✦ Reputation Protocol ✦ Stake Against Behavior ✦
Verify Before You Trust ✦ Agent Registry ✦ Trust Infrastructure ✦
ORBS Token ✦ Programmable Trust ✦
```

### CSS
```css
animation: marquee 30s linear infinite;

@keyframes marquee {
  0%   { transform: translateX(0); }
  100% { transform: translateX(-50%); }  /* -50% = lebar satu set konten */
}
```

### Properties
| Property | Value |
|---|---|
| Speed | 30 detik per siklus |
| Direction | Kanan → kiri |
| Background | `#0a0a0a` |
| Text | 11px, 600 weight, uppercase, `letter-spacing: 0.2em` |
| Separator ✦ | Warna pink |

---

## 5. Problem Section

**File location:** `index.html` — `section#problem`

### Layout
```
┌──────────────────────────┬──────────────────────────┐
│ Section label            │                          │
│ Section title            │  Stat 1: 0               │
│   "Blind Faith" (pink)   │  agent identity standards│
│                          │ ─────────────────────────│
│ ┌──────┬──────┬────────┐ │  Stat 2: $0              │
│ │Anon  │Dispos│Unverif.│ │  accountability          │
│ └──────┴──────┴────────┘ │ ─────────────────────────│
│                          │  Stat 3: ∞               │
│                          │  agents daily            │
└──────────────────────────┴──────────────────────────┘
```

### Key Stats
```html
<div class="stat-value">0</div>  <!-- 56px Playfair Display pink -->
<div class="stat-value">$0</div>
<div class="stat-value">∞</div>
```

Font size stat: **56px** Playfair Display 900 weight, pink.

---

## 6. How It Works Cards

**File location:** `index.html` — `section#how`

### Layout
```
┌────────────┬────────────┬────────────┬────────────┐
│ 01 Register│ 02 Track   │ 03 Stake   │ 04 Query   │
│ Register   │ Track      │ Stake      │ Query      │
│            │            │            │            │
│ Agents     │ Every      │ Agents     │ Any app    │
│ claim...   │ transaction│ stake ORBS │ can query  │
└────────────┴────────────┴────────────┴────────────┘
```

### Hover Animation
1. Card naik 4px (`translateY(-4px)`)
2. Background: `#050505` → `#0d0d0d`
3. Pink line muncul di atas dari kiri ke kanan (`scaleX(0 → 1)`)

### Grid trick
```css
.how-grid {
  gap: 1px;
  background: var(--border); /* gap terisi warna border */
}
.how-card {
  background: #050505;       /* card menutupi background */
}
```
Grid gap 1px dengan background warna border = efek "garis pemisah" antar card tanpa perlu border pada setiap card.

---

## 7. Roadmap Timeline

**File location:** `index.html` — `section#roadmap`

### Layout
```
│
●─── Phase 1 │ Launch
│            │ Token live...
│
○─── Phase 2 │ Registry
│            │ Agent identity system...
│
○─── Phase 3 │ Reputation
│            │ Scoring engine...
│
○─── Phase 4 │ Standard
             │ Cross-protocol...
```

### Garis Vertikal
```css
.roadmap-timeline::before {
  content: '';
  position: absolute;
  left: 0;
  top: 8px; bottom: 8px;
  width: 1px;
  background: rgba(255,255,255,0.08);
}
```

### Dot Indicator
```css
.roadmap-item::before {
  content: '';
  position: absolute;
  left: -4px; top: 56px; /* -4px = center di garis */
  width: 8px; height: 8px;
  border-radius: 50%;
  background: #444;
}

.roadmap-item.active::before {
  background: #ff007a;
  box-shadow: 0 0 16px #ff007a;
}
```

### Status
- Phase 1: `.active` class → pink dot + pink phase label
- Phase 2–4: tidak active → dot abu-abu

---

## 8. CTA Section

**File location:** `index.html` — `section#cta`

### Layout
```
         ● Join The Protocol

   The agent economy needs
        accountability.    ← pink italic

   [BUY ORBS]  [FOLLOW THE BUILD]
```

### Key CSS
```css
.cta-inner {
  text-align: center;
  padding: 140px 48px;
}

.cta-title {
  font-size: clamp(40px, 5vw, 80px);
  max-width: 900px;
  margin: 0 auto 56px;
}
```

---

## 9. Footer

**File location:** `index.html` — `<footer>`

### Layout
```
© 2026 Orbs Agent. All rights reserved.     Twitter   Github
```

### Properties
| Property | Value |
|---|---|
| Background | Inherit (`#050505`) |
| Border | `1px solid rgba(255,255,255,0.08)` top |
| Padding | `40px 48px` |
| Layout | Flexbox, `justify-content: space-between` |

### Links
- Twitter → `#` (placeholder)
- Github → `#` (placeholder, seharusnya link repo)

---

## Button Component

Digunakan di seluruh halaman.

### `.btn-pink`
```css
background: #ff007a;
color: #050505;
padding: 10px 24px;
font: 700 11px Inter;
letter-spacing: 0.15em;
text-transform: uppercase;
/* hover: */
box-shadow: 0 0 32px rgba(255,0,122,0.3), 0 0 8px #ff007a;
transform: translateY(-1px);
```

### `.btn-outline`
```css
border: 1px solid rgba(255,255,255,0.2);
color: #eaeaea;
/* hover: */
border-color: #ff007a;
color: #ff007a;
box-shadow: 0 0 20px rgba(255,0,122,0.1);
```

---

## Potential Component Improvements

- [ ] Hamburger menu untuk mobile navbar
- [ ] Toast notification saat copy clipboard berhasil
- [ ] Loading state pada BUY ORBS button (jika dihubungkan ke wallet)
- [ ] Counter animasi pada stat numbers (0 → nilai akhir)
- [ ] Active state indicator pada nav link saat scroll
- [ ] Tambahkan link real pada Twitter dan Github footer
