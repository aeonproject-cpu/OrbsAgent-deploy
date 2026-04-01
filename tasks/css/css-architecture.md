# Task: CSS Architecture & Animations

**Type:** css  
**Priority:** P1  
**Status:** completed (implemented di index.html `<style>`)  
**Ukuran CSS:** ~1100 baris custom CSS + TailwindCSS CDN  
**Estimasi:** referensi dokumentasi

---

## Tujuan

Mendokumentasikan arsitektur CSS project Orbs Agent: struktur, metodologi, animasi, dan pattern yang digunakan.

---

## Teknologi CSS

### 1. TailwindCSS (CDN)

```html
<script src="https://cdn.tailwindcss.com"></script>
```

**Versi:** CDN latest (auto-update)  
**Cara kerja:** Tailwind CDN men-scan HTML dan men-generate CSS on-the-fly di browser.

**Custom config yang di-extend:**
```js
tailwind.config = {
  theme: {
    extend: {
      colors: {
        'black-deep':      '#050505',
        'black-secondary': '#0a0a0a',
        'neon-pink':       '#ff007a',
        'text-primary':    '#eaeaea',
        'text-secondary':  '#888',
      },
      fontFamily: {
        serif: ['"Playfair Display"', 'Georgia', 'serif'],
        sans: ['Inter', 'system-ui', 'sans-serif'],
      },
    },
  },
}
```

**Limitasi CDN:** Tidak mendukung `purge/content` config → semua utility Tailwind tersedia tapi tidak ada tree-shaking. Untuk production optimal, sebaiknya build dengan Tailwind CLI (lihat task deployment).

---

### 2. Custom CSS

Ditulis inline dalam `<style>` tag. Tidak menggunakan metodologi BEM, SMACSS, atau CSS Modules secara formal — tapi mengikuti konvensi naming yang konsisten:

```
.section-title    → komponen section
.hero-headline    → komponen hero, elemen headline
.how-card         → komponen how-it-works, elemen card
.api-sidebar      → komponen modal API, elemen sidebar
.wp-masthead      → komponen whitepaper (wp prefix), elemen masthead
```

---

## Struktur CSS (urutan di file)

```
1. Reset & box-sizing
2. CSS Custom Properties (:root)
3. html/body base styles
4. Custom cursor
5. Custom scrollbar
6. Navigation
7. Buttons (btn-pink, btn-outline)
8. Hero section
9. Section utilities (section-label, section-title, hr-pink, dot-accent)
10. Background grid
11. Marquee ticker
12. Problem section
13. How It Works section
14. Roadmap section
15. CTA section
16. Footer
17. Fade-in animation classes
18. Noise overlay (body::after)
19. Responsive media queries
20. API Modal styles
21. Whitepaper/Newspaper styles
22. Whitepaper responsive
```

---

## CSS Custom Properties

```css
:root {
  --pink:      #ff007a;
  --pink-glow: rgba(255,0,122,0.3);
  --border:    rgba(255,255,255,0.08);
}
```

Hanya 3 variable global. Sisanya hardcoded langsung (kesempatan improvement: tambahkan lebih banyak tokens).

---

## Animasi

### 1. Fade-In Scroll Animation

```css
.fade-in {
  opacity: 0;
  transform: translateY(24px);
  transition: opacity 0.7s ease, transform 0.7s ease;
}

.fade-in.visible {
  opacity: 1;
  transform: translateY(0);
}

/* Stagger delays */
.fade-in-delay-1 { transition-delay: 0.1s; }
.fade-in-delay-2 { transition-delay: 0.2s; }
.fade-in-delay-3 { transition-delay: 0.3s; }
.fade-in-delay-4 { transition-delay: 0.4s; }
```

**Cara kerja:**
- Elemen mulai dengan `opacity: 0` dan sedikit geser ke bawah (`translateY(24px)`)
- JavaScript `IntersectionObserver` menambah class `.visible` saat elemen masuk viewport
- Transisi berjalan 0.7s dengan easing `ease`
- Delay kelas memungkinkan animasi staggered (tidak serentak)

---

### 2. Marquee Ticker

```css
.marquee-track {
  display: flex;
  animation: marquee 30s linear infinite;
  white-space: nowrap;
}

@keyframes marquee {
  0%   { transform: translateX(0); }
  100% { transform: translateX(-50%); }
}
```

**Kenapa -50%?**  
Konten diduplikat 2x. Pada 0% semua konten di posisi awal. Pada 100% sudah bergeser `-50%` (setengah dari total lebar) — tepat di posisi yang identik secara visual dengan posisi 0%, sehingga loop seamless.

---

### 3. Card Hover — Pink Top Line

```css
.how-card::before {
  content: '';
  position: absolute;
  top: 0; left: 0; right: 0;
  height: 1px;
  background: var(--pink);
  transform: scaleX(0);
  transform-origin: left;
  transition: transform 0.4s ease;
}

.how-card:hover::before {
  transform: scaleX(1);
}
```

**Cara kerja:**
- Line merah muda (`::before`) ada secara CSS tapi `scaleX(0)` → tidak terlihat
- Pada hover, `scaleX(1)` → line muncul dari kiri ke kanan dalam 0.4s
- `transform-origin: left` memastikan animasi dimulai dari kiri

---

### 4. Card Hover — Lift Effect

```css
.how-card:hover {
  background: #0d0d0d;
  transform: translateY(-4px);
}
```

Kartu bergerak 4px ke atas saat hover — efek "mengangkat" yang halus.

---

### 5. Button Glow Hover

```css
.btn-pink:hover {
  box-shadow: 0 0 32px rgba(255,0,122,0.3), 0 0 8px #ff007a;
  transform: translateY(-1px);
}
```

Dua layer `box-shadow`:
- Layer luar: glow besar (32px) transparan 30%
- Layer dalam: glow kecil (8px) solid pink

---

### 6. Roadmap Dot Pulse

```css
.roadmap-item::before {
  /* dot bulat */
  background: #444;
  transition: background 0.3s ease, box-shadow 0.3s ease;
}

.roadmap-item:hover::before,
.roadmap-item.active::before {
  background: var(--pink);
  box-shadow: 0 0 16px var(--pink);
}
```

---

### 7. CSS Noise Texture

```css
body::after {
  content: '';
  position: fixed;
  inset: 0;
  opacity: 0.025;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='300' height='300'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.75' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='300' height='300' filter='url(%23n)'/%3E%3C/svg%3E");
  pointer-events: none;
  z-index: 500;
}
```

**Cara kerja:**
- SVG inline dengan filter `feTurbulence` dan `fractalNoise`
- Di-encode sebagai Data URI
- Opacity sangat rendah (2.5%) → efek grain halus
- `pointer-events: none` → tidak mengganggu interaksi
- `z-index: 500` → di atas konten tapi di bawah modal (z-index: 200+) dan cursor (9999)

---

## Glassmorphism (Navbar & Modal)

```css
nav {
  background: rgba(5,5,5,0.92);
  backdrop-filter: blur(20px);
}

.api-overlay {
  background: rgba(5,5,5,0.98);
  backdrop-filter: blur(24px);
}
```

`backdrop-filter: blur()` membutuhkan browser modern (Chrome 76+, Firefox 103+, Safari 9+).  
Fallback: background solid semi-transparan tetap terbaca.

---

## Layout Techniques

### CSS Grid

```css
/* Hero — 2 kolom equal */
.hero { grid-template-columns: 1fr 1fr; }

/* Problem — 2 kolom equal */
.problem-section { grid-template-columns: 1fr 1fr; }

/* Problem sub-columns — 3 kolom equal */
.problem-columns { grid-template-columns: 1fr 1fr 1fr; }

/* How it works — 4 kolom equal */
.how-grid { grid-template-columns: repeat(4, 1fr); }

/* Roadmap — fixed + fluid */
.roadmap-item { grid-template-columns: 200px 1fr; }

/* API Modal body — fixed sidebar + fluid main */
.api-body { grid-template-columns: 280px 1fr; }

/* Whitepaper lede — proportional */
.wp-lede-row { grid-template-columns: 1fr 2px 2fr; }
```

### CSS Columns (Newspaper)

```css
.wp-columns-2 {
  column-count: 2;
  column-gap: 40px;
  column-rule: 1px solid rgba(255,255,255,0.06);
}

.wp-columns-3 {
  column-count: 3;
  column-gap: 32px;
  column-rule: 1px solid rgba(255,255,255,0.06);
}
```

`column-rule` menggambar garis pemisah antar kolom — seperti newspaper.

### CSS Clamp (Fluid Typography)

```css
font-size: clamp(72px, 7vw, 112px);  /* Hero headline */
font-size: clamp(40px, 4vw, 64px);   /* Section title */
font-size: clamp(40px, 5vw, 80px);   /* CTA title */
```

`clamp(min, preferred, max)`:
- Di layar kecil: font tidak kurang dari `min`
- Di layar besar: font tidak lebih dari `max`
- Di antaranya: scale dengan `vw` (viewport width)

---

## Z-Index Stack

```
9999  → .cursor (titik pink)
9998  → .cursor-glow
 500  → body::after (noise overlay)
 210  → .wp-overlay (whitepaper modal)
 200  → .api-overlay (api modal)
 100  → nav (sticky navbar)
   0  → konten halaman
```

---

## Responsive Strategy

**Mobile-first:** Tidak. Project ini desktop-first karena target audience adalah developer/crypto enthusiast yang umumnya di desktop.

**Breakpoints:**

```css
@media (max-width: 1024px) {
  /* Hero, Problem: 2 kolom → 1 kolom */
  /* How grid: 4 kolom → 2 kolom */
  /* Roadmap item: 2 kolom → 1 kolom */
}

@media (max-width: 768px) {
  /* Nav: sembunyikan semua link kecuali BUY ORBS */
  /* Padding dikurangi 48px → 24px */
  /* How grid: 2 kolom → 1 kolom */
  /* Problem columns: 3 → 1 */
  /* CTA buttons: horizontal → vertikal */
  /* Footer: horizontal → vertikal center */
}

@media (max-width: 900px) {
  /* API Modal: sembunyikan sidebar */
  /* Whitepaper: columns → 1 kolom */
}
```

---

## Potential Improvements

- [ ] Tambahkan lebih banyak CSS custom properties (spacing, font-size tokens)
- [ ] Pisahkan CSS ke file terpisah jika project berkembang
- [ ] Tambahkan `prefers-reduced-motion` media query untuk disable animasi
- [ ] `backdrop-filter` fallback untuk browser lama
- [ ] Tailwind CSS build step untuk tree-shaking dan production optimization
