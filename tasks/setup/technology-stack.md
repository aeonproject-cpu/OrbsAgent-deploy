# Task: Technology Stack Research

**Type:** setup  
**Priority:** P0  
**Status:** completed (research & dokumentasi)  
**Estimasi:** referensi

---

## Overview

Orbs Agent adalah **static single-file web application**. Semua kode — HTML, CSS, JavaScript — ada dalam satu file `index.html`. Tidak ada backend, tidak ada build step wajib, tidak ada dependency lokal.

---

## 1. HTML5

**Versi:** HTML5 (DOCTYPE `<!DOCTYPE html>`)  
**Fungsi:** Struktur dan konten seluruh aplikasi

### Fitur HTML5 yang digunakan:
| Fitur | Penggunaan di Project |
|---|---|
| Semantic elements | `<nav>`, `<section>`, `<footer>` |
| `data-*` attributes | `data-panel`, `data-resp` untuk JS selectors |
| SVG inline (Data URI) | Noise texture di `body::after` |
| `<details>/<summary>` | Tidak digunakan |
| `<dialog>` | Tidak digunakan — modal dibuat manual |

### Kenapa tidak pakai `<dialog>` untuk modal?
`<dialog>` adalah elemen HTML5 native untuk modal. Lebih aksesibel (built-in `aria-modal`, focus trap, backdrop). Implementasi saat ini menggunakan `div` manual — ini adalah **technical debt** yang bisa diperbaiki ke depan.

---

## 2. TailwindCSS

**Versi:** CDN latest (`cdn.tailwindcss.com`)  
**Fungsi:** Utility-first CSS framework  
**Cara load:** Via `<script src>` CDN, bukan npm package

### Cara kerja CDN Tailwind:
1. Browser load script Tailwind dari CDN
2. Script scan seluruh HTML di browser
3. Generate CSS classes yang dibutuhkan secara real-time
4. Inject `<style>` tag ke dokumen

### Custom config yang di-extend:
```js
tailwind.config = {
  theme: {
    extend: {
      colors: { ... },      // 5 warna custom
      fontFamily: { ... },  // 2 font family custom
    },
  },
}
```

### Utility classes yang digunakan:
Di project ini, Tailwind **hampir tidak digunakan** untuk styling utama — sebagian besar CSS ditulis custom. Tailwind digunakan untuk:
- `style="..."` inline pada beberapa elemen (quick overrides)
- Potensi penggunaan lebih besar jika dikembangkan

### Production consideration:
CDN Tailwind tidak di-tree-shake. Seluruh ~3000+ utility class tersedia tapi tidak semua dipakai. Untuk production yang optimal, gunakan Tailwind CLI build.

---

## 3. Google Fonts

**Service:** fonts.googleapis.com  
**Fonts:**

### Playfair Display
- **Kategori:** Serif display
- **Weights loaded:** 400, 700, 900 (normal + italic)
- **Penggunaan:** Semua headline, section titles, card titles, whitepaper body
- **Karakter:** Elegant, high-contrast stroke, cocok untuk editorial/luxury branding
- **Alternatif lokal:** Georgia (fallback di CSS)

### Inter
- **Kategori:** Sans-serif humanist
- **Weights loaded:** 300, 400, 500, 600, 700
- **Penggunaan:** Body text, nav links, labels, buttons, metadata
- **Karakter:** Highly legible, modern, dirancang khusus untuk layar
- **Dibuat oleh:** Rasmus Andersson (mantan Figma designer)
- **Alternatif lokal:** system-ui (fallback di CSS)

### Courier New
- **Kategori:** Monospace
- **Sumber:** System font (tidak di-load dari Google Fonts)
- **Penggunaan:** Code blocks, URL bars, API path
- **Alternatif:** Fira Code, JetBrains Mono (lebih modern, bisa ditambahkan)

### Performance:
```html
<!-- Preconnect untuk performa -->
<link rel="preconnect" href="https://fonts.googleapis.com" />
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />

<!-- display=swap mencegah FOIT (Flash of Invisible Text) -->
<link href="...&display=swap" rel="stylesheet" />
```

`display=swap`: Browser menampilkan fallback font dulu sambil load font utama. Saat font selesai load, swap ke font yang benar. Tidak ada invisible text.

---

## 4. Vanilla JavaScript (ES6+)

**Framework:** Tidak ada  
**Library:** Tidak ada  
**Ukuran:** ~150 baris

### ES6+ features yang digunakan:
| Feature | Digunakan untuk |
|---|---|
| `const` / `let` | Variable declarations |
| Arrow functions `() => {}` | Event handlers |
| Template literals | Tidak digunakan |
| Destructuring | Tidak digunakan |
| `forEach` | Iterasi elemen |
| IIFE `(function(){})()` | `animateGlow` loop |
| Optional chaining `?.` | Tidak digunakan |
| `async/await` | Tidak digunakan |

### Web APIs yang digunakan:
| API | Browser Support | Penggunaan |
|---|---|---|
| `IntersectionObserver` | Chrome 51+, FF 55+, Safari 12.1+ | Scroll animations |
| `requestAnimationFrame` | Chrome 10+, FF 4+, Safari 6+ | Cursor glow animation |
| `navigator.clipboard` | Chrome 66+, FF 63+, Safari 13.1+ | Copy button (HTTPS only) |
| `addEventListener` | Universal | Event handling |
| `classList` | IE 10+ | Toggle classes |
| `dataset` | IE 11+ | Read `data-*` attributes |
| `scrollTo` | Chrome 45+, FF 36+, Safari 10.1+ | Smooth scroll di modal |

---

## 5. CSS3 & Modern CSS

### Modern CSS features:
| Feature | Browser Support | Penggunaan |
|---|---|---|
| CSS Custom Properties | Chrome 49+, FF 31+, Safari 9.1+ | `--pink`, `--border`, `--pink-glow` |
| CSS Grid | Chrome 57+, FF 52+, Safari 10.1+ | Semua layout utama |
| CSS Flexbox | Chrome 21+, FF 22+, Safari 6.1+ | Nav, buttons, footer |
| `clamp()` | Chrome 79+, FF 75+, Safari 13.1+ | Fluid typography |
| `backdrop-filter` | Chrome 76+, FF 103+, Safari 9+ | Glassmorphism nav & modal |
| CSS `column-count` | Chrome 4+, FF 2+, Safari 3.1+ | Newspaper columns |
| SVG Data URI | Universal | Noise texture |
| `@keyframes` | Chrome 43+, FF 16+, Safari 9+ | Marquee animation |
| CSS `transform` | Chrome 36+, FF 16+, Safari 9+ | Fade-in, hover effects |
| `mix-blend-mode` | Chrome 41+, FF 32+, Safari 8+ | Cursor blend mode |
| `hyphens: auto` | Chrome 55+, FF 43+, Safari 5.1+ | Justified text dalam columns |

---

## 6. SVG (Inline Data URI)

**Penggunaan:** Noise texture overlay di `body::after`

```css
background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='300' height='300'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.75' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='300' height='300' filter='url(%23n)'/%3E%3C/svg%3E");
```

**SVG Filter yang digunakan:**
- `<feTurbulence>`: Menghasilkan pola noise/turbulence fractal
- `type="fractalNoise"`: Jenis noise yang lebih halus (vs turbulence)
- `baseFrequency="0.75"`: Frekuensi noise (lebih tinggi = grain lebih halus)
- `numOctaves="4"`: Jumlah layer detail
- `stitchTiles="stitch"`: Tiles menyambung seamlessly

---

## 7. Git & GitHub

**Git version:** 2.x  
**Hosting:** GitHub  

### Workflow yang direncanakan:
```
local development
     ↓ git add + git commit
  main branch
     ↓ git push
  GitHub remote
     ↓ auto-deploy
  GitHub Pages / Vercel / Netlify
```

### Commit convention: Conventional Commits
```
feat:      fitur baru
fix:       bug fix
docs:      perubahan dokumentasi
style:     perubahan visual (tidak mengubah logika)
refactor:  refactor kode
perf:      optimasi performa
chore:     maintenance (deps, config)
```

---

## Dependency Graph

```
index.html
  ├── Google Fonts CDN (external)
  │   ├── Playfair Display
  │   └── Inter
  ├── TailwindCSS CDN (external)
  └── (all else: inline)
      ├── Custom CSS (~1100 lines)
      └── Vanilla JS (~150 lines)
```

**Zero local dependencies.** Untuk menjalankan: buka `index.html` di browser.

---

## Potential Tech Upgrades

| Upgrade | Benefit | Effort |
|---|---|---|
| Self-host fonts | Faster load, no Google dependency | Medium |
| Tailwind CLI build | Smaller CSS, tree-shaking | Medium |
| Extract ke `app.js` | Separation of concerns | Low |
| Extract ke `style.css` | Separation of concerns | Low |
| Vite bundler | HMR dev server, build optimization | High |
| Add `highlight.js` | Better code syntax highlighting | Low |
| Replace `<div>` modals with `<dialog>` | Better accessibility | Medium |
