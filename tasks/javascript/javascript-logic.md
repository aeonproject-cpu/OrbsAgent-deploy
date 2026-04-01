# Task: JavaScript Logic & Interactivity

**Type:** javascript  
**Priority:** P1  
**Status:** completed (implemented di index.html `<script>`)  
**Ukuran JS:** ~150 baris Vanilla JavaScript  
**Estimasi:** referensi dokumentasi

---

## Tujuan

Mendokumentasikan semua JavaScript yang digunakan di Orbs Agent: fungsi, cara kerja, dan alasan teknis di balik setiap implementasi.

---

## Overview

**Tidak ada framework.** Semua ditulis dalam Vanilla JavaScript ES6+. Tidak ada jQuery, tidak ada React, tidak ada build step.

**API Browser yang digunakan:**
- `document.addEventListener`
- `document.querySelector` / `querySelectorAll`
- `requestAnimationFrame`
- `IntersectionObserver`
- `navigator.clipboard`
- `window.addEventListener`

---

## 1. Custom Cursor

```js
const cursor    = document.getElementById('cursor');
const cursorGlow = document.getElementById('cursorGlow');
let mouseX = 0, mouseY = 0;
let glowX  = 0, glowY  = 0;

// Update posisi cursor utama secara langsung (tanpa lag)
document.addEventListener('mousemove', (e) => {
  mouseX = e.clientX;
  mouseY = e.clientY;
  cursor.style.left = mouseX + 'px';
  cursor.style.top  = mouseY + 'px';
});

// Update posisi glow dengan lag (smooth follow)
(function animateGlow() {
  glowX += (mouseX - glowX) * 0.08;
  glowY += (mouseY - glowY) * 0.08;
  cursorGlow.style.left = glowX + 'px';
  cursorGlow.style.top  = glowY + 'px';
  requestAnimationFrame(animateGlow);
})();
```

**Cara kerja lag effect:**
- Setiap frame, glow bergerak 8% dari jarak antara posisi saat ini dan target
- `glowX += (mouseX - glowX) * 0.08` = lerp (linear interpolation)
- Semakin jauh dari target → gerakan lebih cepat. Semakin dekat → makin lambat
- Faktor `0.08` mengontrol kecepatan. Nilai lebih besar = lebih responsif, lebih kecil = lebih lag

**Kenapa `requestAnimationFrame`?**
- Sinkron dengan refresh rate monitor (60fps/120fps/dll)
- Browser bisa pause saat tab tidak aktif (optimasi battery)
- Lebih smooth dari `setInterval`

---

### Cursor Scale pada Hover

```js
document.querySelectorAll('a, button, .how-card').forEach(el => {
  el.addEventListener('mouseenter', () => {
    cursor.style.width   = '20px';
    cursor.style.height  = '20px';
    cursor.style.opacity = '0.5';
  });
  el.addEventListener('mouseleave', () => {
    cursor.style.width   = '12px';
    cursor.style.height  = '12px';
    cursor.style.opacity = '1';
  });
});
```

Cursor membesar dari 12px → 20px dan jadi semi-transparan saat hover di atas elemen interaktif.

---

## 2. Scroll Fade-In (IntersectionObserver)

```js
const fadeEls = document.querySelectorAll('.fade-in');

const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) entry.target.classList.add('visible');
  });
}, {
  threshold: 0.1,           // trigger saat 10% elemen terlihat
  rootMargin: '0px 0px -60px 0px'  // offset 60px dari bawah viewport
});

fadeEls.forEach(el => observer.observe(el));
```

**Cara kerja:**
- `IntersectionObserver` memantau setiap elemen `.fade-in`
- Ketika elemen masuk viewport (minimal 10% terlihat + 60px offset dari bawah), class `.visible` ditambahkan
- CSS transition pada `.fade-in` + `.visible` menjalankan animasi fade+slide

**Kenapa `rootMargin: '0px 0px -60px 0px'`?**  
Tanpa offset, elemen di bagian paling bawah viewport langsung trigger saat baru muncul. Offset `-60px` membuat elemen harus sudah masuk 60px ke dalam viewport sebelum animasi mulai → terasa lebih natural.

**Kenapa tidak pakai CSS `animation-play-state`?**  
`IntersectionObserver` lebih fleksibel, tidak memerlukan `animation-fill-mode`, dan bisa dikontrol per-elemen.

---

### Hero Trigger (DOMContentLoaded)

```js
window.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.hero .fade-in').forEach((el, i) => {
    setTimeout(() => el.classList.add('visible'), 100 + i * 150);
  });
});
```

**Kenapa terpisah dari IntersectionObserver?**  
Hero ada di `position: fixed`-aware area — selalu terlihat saat halaman load. `IntersectionObserver` akan langsung trigger semua sekaligus. Kode ini membuat stagger manual dengan `setTimeout`:
- Elemen 0: delay 100ms
- Elemen 1: delay 250ms  
- Elemen 2: delay 400ms

---

## 3. Whitepaper Modal

```js
const wpOverlay = document.getElementById('wpOverlay');
const docsBtn   = document.getElementById('docsBtn');
const wpClose   = document.getElementById('wpClose');

// Buka
docsBtn.addEventListener('click', (e) => {
  e.preventDefault();
  wpOverlay.classList.add('open');
  document.body.style.overflow = 'hidden'; // cegah scroll background
});

// Tutup via tombol
wpClose.addEventListener('click', () => {
  wpOverlay.classList.remove('open');
  document.body.style.overflow = '';
});

// Tutup via keyboard Esc
document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape') {
    wpOverlay.classList.remove('open');
    document.body.style.overflow = '';
  }
});
```

**Pattern modal:**
1. Toggle class `.open` pada overlay (`display:none` → `display:flex`)
2. `document.body.style.overflow = 'hidden'` mencegah halaman di belakang bisa di-scroll
3. Reset overflow saat tutup

---

### TOC Smooth Scroll (Whitepaper)

```js
document.querySelectorAll('.wp-toc a').forEach(a => {
  a.addEventListener('click', (e) => {
    e.preventDefault();
    const target = document.querySelector(a.getAttribute('href'));
    if (target) {
      document.getElementById('wpBody').scrollTo({
        top: target.offsetTop - 24,
        behavior: 'smooth'
      });
    }
  });
});
```

**Kenapa tidak pakai `html { scroll-behavior: smooth }` saja?**  
`scroll-behavior: smooth` pada `<html>` hanya berlaku untuk scroll elemen `<html>/<body>`. Whitepaper scroll terjadi di dalam `div#wpBody` (overflow: auto), bukan di `<body>`. Perlu manual `scrollTo` pada element yang benar.

**`target.offsetTop - 24`:** offset 24px agar konten tidak menempel di tepi atas saat di-scroll-to.

---

## 4. API Reference Modal

```js
const apiOverlay = document.getElementById('apiOverlay');
const apiBtn     = document.getElementById('apiBtn');
const apiClose   = document.getElementById('apiClose');

apiBtn.addEventListener('click', (e) => {
  e.preventDefault();
  apiOverlay.classList.add('open');
  document.body.style.overflow = 'hidden';
});

apiClose.addEventListener('click', () => {
  apiOverlay.classList.remove('open');
  document.body.style.overflow = '';
});
```

Sama dengan whitepaper modal. Catatan: dua event listener `keydown` untuk `Escape` — saat ini keduanya akan trigger jika dua modal terbuka bersamaan (tidak mungkin di UX normal, tapi bisa di-refactor).

---

### Endpoint Sidebar Switching

```js
document.querySelectorAll('.api-endpoint-btn').forEach(btn => {
  btn.addEventListener('click', () => {
    const panelId = btn.dataset.panel; // dari data-panel="ep-agent-get"

    // Reset semua tombol sidebar
    document.querySelectorAll('.api-endpoint-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');

    // Reset semua panel
    document.querySelectorAll('.api-panel').forEach(p => p.classList.remove('active'));
    const panel = document.getElementById(panelId);
    if (panel) {
      panel.classList.add('active');
      document.querySelector('.api-main').scrollTop = 0; // scroll ke atas
    }
  });
});
```

**Data attribute pattern:** `data-panel="ep-agent-get"` pada button → `id="ep-agent-get"` pada panel. Menghindari hardcode ID di JavaScript.

---

### Response Tab Switching

```js
document.querySelectorAll('.api-resp-tab').forEach(tab => {
  tab.addEventListener('click', () => {
    const respId = tab.dataset.resp;

    // Reset tab siblings (hanya dalam parent yang sama)
    const siblings = tab.parentElement.querySelectorAll('.api-resp-tab');
    siblings.forEach(t => t.classList.remove('active'));
    tab.classList.add('active');

    // Cari code-block tepat setelah tab bar
    const codeBlock = tab.closest('.api-response-tabs').nextElementSibling;
    codeBlock.querySelectorAll('.resp-panel').forEach(p => p.classList.remove('active'));
    document.getElementById(respId).classList.add('active');
  });
});
```

**`tab.parentElement.querySelectorAll`:** scope ke parent → tidak reset tab di panel lain.  
**`tab.closest('.api-response-tabs').nextElementSibling`:** navigasi DOM untuk menemukan code block yang tepat berelasi dengan tab bar ini.

---

## 5. Copy to Clipboard

```js
document.querySelectorAll('.code-copy-btn').forEach(btn => {
  btn.addEventListener('click', () => {
    const pre = btn.closest('.code-block').querySelector('pre');
    navigator.clipboard.writeText(pre.innerText).then(() => {
      const orig = btn.textContent;
      btn.textContent = 'Copied';
      btn.style.color = '#00c864';
      setTimeout(() => {
        btn.textContent = orig;
        btn.style.color = '';
      }, 1500);
    });
  });
});
```

**`navigator.clipboard.writeText()`:**
- API modern untuk copy ke clipboard
- Returns Promise → gunakan `.then()` untuk feedback visual
- Hanya berfungsi di HTTPS atau localhost (browser security requirement)
- Fallback: bisa tambahkan `document.execCommand('copy')` untuk browser lama

**`pre.innerText` vs `pre.textContent`:**
- `innerText` mematuhi rendering CSS → teks yang terlihat
- `textContent` mengambil semua text node termasuk yang tersembunyi
- `innerText` lebih tepat karena mengabaikan `<span>` HTML highlight tags

---

## Dependency & Browser Support

| Fitur | Browser Support |
|---|---|
| `IntersectionObserver` | Chrome 51+, Firefox 55+, Safari 12.1+ |
| `requestAnimationFrame` | Chrome 10+, Firefox 4+, Safari 6+ |
| `navigator.clipboard` | Chrome 66+, Firefox 63+, Safari 13.1+ (HTTPS only) |
| `backdrop-filter` | Chrome 76+, Firefox 103+, Safari 9+ |
| CSS `clamp()` | Chrome 79+, Firefox 75+, Safari 13.1+ |
| CSS Custom Properties | Chrome 49+, Firefox 31+, Safari 9.1+ |
| CSS Grid | Chrome 57+, Firefox 52+, Safari 10.1+ |
| CSS `column-count` | Chrome 4+, Firefox 2+, Safari 3.1+ |

**Target browser:** Chrome/Edge/Firefox/Safari terbaru. IE tidak didukung.

---

## Potential Improvements

- [ ] Refactor dua keydown listener menjadi satu (cek kedua modal)
- [ ] Tambahkan `navigator.clipboard` fallback untuk browser lama
- [ ] Tambahkan `prefers-reduced-motion` check untuk disable animasi
- [ ] Extract JS ke file terpisah `app.js` jika project berkembang
- [ ] Tambahkan event delegation untuk cursor hover (lebih efisien dari forEach)
- [ ] Tambahkan `aria-expanded` pada modal buttons untuk aksesibilitas
