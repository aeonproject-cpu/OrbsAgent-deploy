# Task: Design System

**Type:** design  
**Priority:** P1 — fondasi visual seluruh project  
**Status:** completed (implemented di index.html)  
**Estimasi:** referensi dokumentasi

---

## Tujuan

Mendokumentasikan dan memahami design system yang diimplementasikan di Orbs Agent. Bisa digunakan sebagai referensi saat menambah fitur atau halaman baru.

---

## Design Philosophy

> "Dark luxury. Cyberpunk editorial. AI + Crypto infrastructure narrative."

Tiga prinsip utama:
1. **Minimalist** — tidak ada dekorasi yang tidak bermakna
2. **High contrast** — teks terang di atas latar sangat gelap
3. **Editorial** — tipografi seperti majalah luxury / broadsheet

---

## Color Tokens

Didefinisikan di `:root` CSS dan Tailwind config:

```css
:root {
  --pink:      #ff007a;               /* Neon pink — accent utama */
  --pink-glow: rgba(255,0,122,0.3);  /* Pink transparan untuk glow effects */
  --border:    rgba(255,255,255,0.08); /* Border ultra-tipis */
}
```

```js
// tailwind.config (extend.colors)
'black-deep':      '#050505'   // Background utama
'black-secondary': '#0a0a0a'   // Background sekunder (sections alternating)
'neon-pink':       '#ff007a'   // Accent
'text-primary':    '#eaeaea'   // Teks utama
'text-secondary':  '#888888'   // Teks sekunder / deskripsi
```

### Penggunaan Warna per Konteks

| Konteks | Warna |
|---|---|
| Background halaman | `#050505` |
| Background section alternating | `#0a0a0a` |
| Heading / teks utama | `#eaeaea` |
| Body text / deskripsi | `#888` |
| Label tersembunyi / metadata | `#555`, `#444` |
| Accent / highlight / CTA | `#ff007a` |
| Border semua elemen | `rgba(255,255,255,0.08)` |
| Kode (key) | `#6482ff` (biru) |
| Kode (string) | `#a8d8a8` (hijau muda) |
| Kode (number) | `#ffb400` (kuning) |
| Kode (boolean) | `#ff007a` (pink) |

---

## Typography

### Font Families

```css
font-family: 'Playfair Display', Georgia, serif;   /* Untuk semua headline */
font-family: 'Inter', system-ui, sans-serif;        /* Untuk semua body text */
font-family: 'Courier New', monospace;              /* Untuk kode dan URL */
```

**Loaded via Google Fonts:**
```html
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;0,900;1,400;1,700;1,900&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
```

### Type Scale

| Elemen | Font | Size | Weight | Style |
|---|---|---|---|---|
| Hero headline | Playfair Display | `clamp(72px, 7vw, 112px)` | 900 | normal |
| Accent word headline | Playfair Display | (sama) | 900 | **italic** + pink |
| Section title | Playfair Display | `clamp(40px, 4vw, 64px)` | 900 | normal |
| Card title (How) | Playfair Display | 28px | 700 | normal |
| Roadmap title | Playfair Display | 32px | 700 | normal |
| CTA title | Playfair Display | `clamp(40px, 5vw, 80px)` | 900 | normal |
| Body text | Inter | 14–17px | 400 | normal |
| Nav links | Inter | 12px | 500 | uppercase |
| Labels / eyebrows | Inter | 9–10px | 600–700 | uppercase + letter-spacing |
| Logo | Inter | 14px | 700 | uppercase |

### Letter Spacing Rules

```css
/* Label / eyebrow kecil */
letter-spacing: 0.25em–0.3em;

/* Nav links */
letter-spacing: 0.12em;

/* Button text */
letter-spacing: 0.15em;

/* Headline */
letter-spacing: -0.02em; /* negatif untuk tight display */
```

---

## Spacing System

Menggunakan skala 8px:

```
8px   → micro spacing
16px  → gap antar tombol
24px  → margin bawah label
32px  → gap kolom kecil
40px  → padding kiri panel, gap nav
48px  → padding card, padding horizontal halaman
56px  → padding vertikal modal
64px  → tinggi navbar
80px  → gap hero, padding vertikal hero
120px → padding vertikal section utama
140px → padding vertikal CTA
```

---

## Component Tokens

### Buttons

```css
/* Primary */
.btn-pink {
  background: #ff007a;
  color: #050505;
  padding: 10px 24px;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.15em;
  text-transform: uppercase;
}
.btn-pink:hover {
  box-shadow: 0 0 32px rgba(255,0,122,0.3), 0 0 8px #ff007a;
  transform: translateY(-1px);
}

/* Secondary */
.btn-outline {
  border: 1px solid rgba(255,255,255,0.2);
  color: #eaeaea;
  /* sama lainnya */
}
.btn-outline:hover {
  border-color: #ff007a;
  color: #ff007a;
  box-shadow: 0 0 20px rgba(255,0,122,0.1);
}
```

### Cards (How It Works)

```css
background: #050505;
padding: 48px 36px;
/* Hover: */
background: #0d0d0d;
transform: translateY(-4px);
/* ::before top line */
height: 1px;
background: #ff007a;
transform: scaleX(0 → 1) on hover; /* kiri ke kanan */
```

### Borders

```css
/* Standard */
border: 1px solid rgba(255,255,255,0.08);

/* Separator vertikal */
border-left: 1px solid rgba(255,255,255,0.08);

/* Pink accent line */
background: linear-gradient(90deg, #ff007a, transparent);
height: 1px;
width: 60px;
```

---

## Visual Effects

### CSS Noise Overlay

```css
body::after {
  content: '';
  position: fixed;
  inset: 0;
  opacity: 0.025;
  background-image: url("data:image/svg+xml, ... feTurbulence ...");
  pointer-events: none;
  z-index: 500;
}
```
Memberikan tekstur grain seperti kertas/film. Opacity sangat rendah (2.5%).

### Dot Grid Background

```css
.bg-grid {
  background-image:
    linear-gradient(rgba(255,255,255,0.02) 1px, transparent 1px),
    linear-gradient(90deg, rgba(255,255,255,0.02) 1px, transparent 1px);
  background-size: 60px 60px;
}
```

### Pink Glow Radial

```css
/* Di hero section */
background: radial-gradient(circle, rgba(255,0,122,0.05) 0%, transparent 70%);
width: 700px; height: 700px;
```

---

## Responsive Breakpoints

```css
@media (max-width: 1024px) { /* Tablet landscape */ }
@media (max-width: 900px)  { /* Modal API/Whitepaper */ }
@media (max-width: 768px)  { /* Tablet portrait / mobile */ }
```

---

## Referensi Desain

Inspirasi visual dari:
- Linear.app — dark UI, tipografi presisi
- Vercel — minimal dark landing page
- Stripe Press — editorial typography
- Cyberpunk editorial magazines — neon accent, serif display
