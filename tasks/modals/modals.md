# Task: Modals — API Reference & Whitepaper

**Type:** modals  
**Priority:** P1  
**Status:** completed  
**Estimasi:** referensi dokumentasi

---

## Tujuan

Mendokumentasikan dua modal full-screen di Orbs Agent: API Reference dan Whitepaper. Keduanya menggunakan pattern yang sama tapi dengan konten dan layout yang sangat berbeda.

---

## Pattern Modal Umum

### HTML Structure
```html
<div class="[type]-overlay" id="[type]Overlay">
  <!-- Header bar -->
  <div class="[type]-topbar / nav">
    ...metadata...
    <button class="[type]-close" id="[type]Close">✕</button>
  </div>
  <!-- Body -->
  <div class="[type]-body">
    ...content...
  </div>
</div>
```

### CSS Toggle
```css
.overlay       { display: none; }
.overlay.open  { display: flex; }
```

### JS Open/Close
```js
// Buka
btn.addEventListener('click', (e) => {
  e.preventDefault();
  overlay.classList.add('open');
  document.body.style.overflow = 'hidden';
});

// Tutup
closeBtn.addEventListener('click', () => {
  overlay.classList.remove('open');
  document.body.style.overflow = '';
});

// Keyboard Esc
document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape') {
    overlay.classList.remove('open');
    document.body.style.overflow = '';
  }
});
```

---

## Modal 1 — API Reference

**Trigger:** `#apiBtn` (tombol API di navbar)  
**ID:** `#apiOverlay`  
**Z-index:** `200`

### Layout
```
┌─────────────────────────────────────────────────────────────┐
│ ORBS AGENT  [API Reference v1.0]  base URL...        [✕]  │  ← topbar 64px
├──────────────────┬──────────────────────────────────────────┤
│                  │                                          │
│  AGENTS          │  [Method] Endpoint Title                 │
│  GET /agents/id  │                                          │
│  GET /agents     │  Description                             │
│  POST /register  │                                          │
│  PATCH /{id}     │  [URL Bar]                               │
│  DELETE /{id}    │                                          │
│                  │  [Auth Card] [Rate Limit Card]           │
│  REPUTATION      │                                          │
│  GET /reputation │  Path Parameters Table                   │
│  GET /history    │  Query Parameters Table                  │
│                  │                                          │
│  STAKING         │  ┌─ cURL ──────────────────────┐        │
│  POST /stake     │  │ curl https://...            │        │
│  GET /stake      │  └─────────────────────────────┘        │
│                  │                                          │
│  TRUST           │  [200 OK] [404] [401]  ← response tabs  │
│  GET /query      │  ┌─ JSON ──────────────────────┐        │
│  POST /verify    │  │ { "id": "...", ... }        │        │
│                  │  └─────────────────────────────┘        │
│  SYSTEM          │                                          │
│  GET /health     │                                          │
└──────────────────┴──────────────────────────────────────────┘
  ↑ 280px sidebar    ↑ flex: 1 main content
```

---

### Sidebar (API)

```html
<div class="api-sidebar">
  <div class="api-sidebar-section">
    <p class="api-sidebar-label">Agents</p>
    <button class="api-endpoint-btn active" data-panel="ep-agent-get">
      <span class="method-badge method-get">GET</span>
      <span class="api-ep-path">/agents/{id}</span>
    </button>
    ...
  </div>
  ...5 groups...
</div>
```

**Method badge colors:**
| Method | Background | Color |
|---|---|---|
| GET | `rgba(0,200,100,0.12)` | `#00c864` |
| POST | `rgba(100,130,255,0.12)` | `#6482ff` |
| PATCH | `rgba(255,180,0,0.12)` | `#ffb400` |
| DELETE | `rgba(255,80,80,0.12)` | `#ff5050` |

**Switching logic:**
```js
document.querySelectorAll('.api-endpoint-btn').forEach(btn => {
  btn.addEventListener('click', () => {
    // 1. Remove active dari semua button
    // 2. Add active ke button yang diklik
    // 3. Remove active dari semua panel
    // 4. Add active ke panel dengan id = btn.dataset.panel
    // 5. Reset scroll ke atas
  });
});
```

---

### Endpoints Lengkap

| # | Method | Path | Name |
|---|---|---|---|
| 1 | GET | `/agents/{id}` | Get Agent |
| 2 | GET | `/agents` | List Agents |
| 3 | POST | `/agents/register` | Register Agent |
| 4 | PATCH | `/agents/{id}` | Update Agent |
| 5 | DELETE | `/agents/{id}` | Revoke Agent |
| 6 | GET | `/agents/{id}/reputation` | Get Reputation Score |
| 7 | GET | `/agents/{id}/history` | Get Behavior History |
| 8 | POST | `/agents/{id}/stake` | Add Stake |
| 9 | GET | `/agents/{id}/stake` | Get Stake Position |
| 10 | GET | `/trust/query` | Query Trust |
| 11 | POST | `/trust/verify` | Batch Verify Trust |
| 12 | GET | `/health` | Health Check |

---

### Anatomy Setiap Endpoint Panel

```html
<div class="api-panel" id="ep-[name]">
  <!-- 1. Header: method badge + title -->
  <div class="api-endpoint-header">
    <span class="method-badge method-[get/post/...]">GET</span>
    <h2 class="api-endpoint-title">Endpoint Name</h2>
  </div>

  <!-- 2. Description -->
  <p class="api-endpoint-desc">...</p>

  <!-- 3. URL Bar -->
  <div class="api-url-bar">
    <span class="api-url-method">GET</span>
    <span class="api-url-text">
      <span class="base">https://api.orbsagent.xyz/v1</span>
      /path/<span class="param">{agent_id}</span>
    </span>
  </div>

  <!-- 4. Info cards (opsional) -->
  <div class="api-two-col">
    <div class="api-info-card">Auth ...</div>
    <div class="api-info-card">Rate Limit ...</div>
  </div>

  <!-- 5. Parameter tables -->
  <p class="api-section-title">Path Parameters</p>
  <table class="api-table">...</table>

  <p class="api-section-title">Query Parameters</p>
  <table class="api-table">...</table>

  <!-- 6. Request example (cURL) -->
  <p class="api-section-title">Request Example</p>
  <div class="code-block">
    <div class="code-block-header">
      <span class="code-block-lang">cURL</span>
      <button class="code-copy-btn">Copy</button>
    </div>
    <pre>curl ...</pre>
  </div>

  <!-- 7. Response tabs + JSON -->
  <div class="api-response-tabs">
    <button class="api-resp-tab active" data-resp="resp-200-...">200 OK</button>
    <button class="api-resp-tab" data-resp="resp-404-...">404 Not Found</button>
    <button class="api-resp-tab" data-resp="resp-401-...">401 Unauthorized</button>
  </div>
  <div class="code-block">
    <div class="resp-panel active" id="resp-200-..."><pre>{ ... }</pre></div>
    <div class="resp-panel" id="resp-404-..."><pre>{ ... }</pre></div>
    <div class="resp-panel" id="resp-401-..."><pre>{ ... }</pre></div>
  </div>
</div>
```

---

### Syntax Coloring (Manual)

Karena tidak ada library highlight.js, warna diterapkan manual dengan `<span>`:

```html
<pre>
{
  <span class="key">"id"</span>: <span class="str">"orbs_ag_..."</span>,
  <span class="key">"score"</span>: <span class="num">847</span>,
  <span class="key">"active"</span>: <span class="bool">true</span>
}
</pre>
```

```css
.code-block pre .key  { color: #6482ff; }  /* biru — keys */
.code-block pre .str  { color: #a8d8a8; }  /* hijau muda — strings */
.code-block pre .num  { color: #ffb400; }  /* kuning — numbers */
.code-block pre .bool { color: #ff007a; }  /* pink — boolean */
```

---

## Modal 2 — Whitepaper

**Trigger:** `#docsBtn` (link Docs di navbar)  
**ID:** `#wpOverlay`  
**Z-index:** `210` (lebih tinggi dari API modal)

### Layout
```
┌─────────────────────────────────────────────────────────────┐
│ Whitepaper · v1.0  Abstract Problem Solution Arch Token Gov [✕]│  ← sticky nav 56px
├─────────────────────────────────────────────────────────────┤
│ (scrollable body)                                           │
│                                                             │
│  VOL. I · ISSUE NO. 1           EST. 2026   ORBSAGENT      │
│  ══════════════════════════════════════════════════════════ │
│           THE ORBS                                          │
│           AGENT                                             │  ← Masthead
│     A Reputation & Identity Protocol...                     │
│  ────────────────────────────────────────────────────────  │
│  WHITEPAPER · APRIL 2026 · VERSION 1.0                      │
│  ══════════════════════════════════════════════════════════ │
│                                                             │
│  ┌─────────────────┬─┬─────────────────────────────────┐   │
│  │ "Trust is the   │ │ A AI agents are no longer...    │   │  ← Lede row
│  │  missing        │ │ Orbs Agent proposes...          │   │
│  │  primitive..."  │ │                                 │   │
│  └─────────────────┴─┴─────────────────────────────────┘   │
│                                                             │
│  ┌────┬────┬────┬────┐                                      │
│  │ 0  │ $0 │ ∞  │2026│  ← Stats strip                       │
│  └────┴────┴────┴────┘                                      │
│                                                             │
│  ══ Section I: The Anonymous Agent Economy ════════════════ │
│  ┌──────────────────────┬───────────────────────────────┐  │
│  │ The proliferation... │ The consequences...           │  │  ← 2-col
│  │                      │                               │  │
│  │   "An agent fails — │ ┌─ Callout ─────────────────┐ │  │
│  │   it disappears."   │ │ 3 structural failures...  │ │  │
│  │   (pull quote)      │ └───────────────────────────┘ │  │
│  └──────────────────────┴───────────────────────────────┘  │
│  ... Section II, III, IV, V ...                             │
│  Orbs Agent Whitepaper · v1.0              APRIL 2026       │
└─────────────────────────────────────────────────────────────┘
```

---

### Sections Whitepaper

| ID | Section | Content |
|---|---|---|
| `#wp-abstract` | Abstract | Thesis utama protocol, drop cap |
| `#wp-problem` | I — The Problem | 2-kolom, pull quote, callout box |
| `#wp-solution` | II — The Solution | 3-kolom intro + 2-kolom primitives |
| `#wp-arch` | III — Architecture | ASCII diagram system architecture |
| `#wp-token` | IV — Tokenomics | ORBS supply, allocation table |
| `#wp-gov` | V — Governance | 3-kolom + pull quote + roadmap fases |

---

### Newspaper Elements

#### Drop Cap
```css
.wp-dropcap::first-letter {
  font-family: 'Playfair Display', serif;
  font-size: 4.8em;
  font-weight: 900;
  float: left;
  line-height: 0.75;
  margin-right: 8px;
  margin-top: 6px;
  color: var(--pink);
}
```

#### Pull Quote
```html
<div class="wp-pullquote">
  <p>"An agent fails — it disappears. No history. No reputation."</p>
</div>
```
```css
.wp-pullquote {
  border-top: 2px solid rgba(255,255,255,0.15);
  border-bottom: 2px solid rgba(255,255,255,0.15);
  padding: 20px 0;
}
.wp-pullquote p {
  font-family: 'Playfair Display', serif;
  font-style: italic;
  font-size: 19px;
  text-align: center;
}
```

#### Multi-column Body
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

.wp-body-text {
  text-align: justify;
  hyphens: auto;  /* auto hyphenation untuk justified text */
}
```

#### Callout Box
```css
.wp-callout {
  border-left: 2px solid var(--pink);
  padding: 16px 20px;
  background: rgba(255,0,122,0.04);
}
```

#### ASCII Architecture Diagram
```html
<div class="wp-arch-block">
  <span class="arch-title">ORBS AGENT PROTOCOL — SYSTEM ARCHITECTURE</span>
  ┌─────────────────────────────────────────┐
  │  CONSUMER LAYER  Wallets · DeFi...     │
  └─────────────────┬───────────────────────┘
                    │ Trust Query API
  ┌─────────────────▼───────────────────────┐
  │  TRUST RESOLVER                         │
  ...
</div>
```

---

### TOC Smooth Scroll

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

Scroll target adalah `#wpBody` (div yang overflow:auto), bukan `<body>`.

---

## Potential Improvements

### API Modal
- [ ] Tambahkan search/filter di sidebar
- [ ] Keyboard navigation antar endpoint (arrow keys)
- [ ] "Try it" button dengan form input parameter
- [ ] Highlight active endpoint di sidebar saat main content di-scroll
- [ ] Dark/light code theme toggle

### Whitepaper Modal
- [ ] Progress indicator scroll (reading progress bar)
- [ ] Print/PDF export button
- [ ] Highlight active section di TOC saat scroll
- [ ] Estimasi waktu baca
- [ ] Table of contents yang expand/collapse
