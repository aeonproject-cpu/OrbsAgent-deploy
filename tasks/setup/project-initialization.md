# Task: Project Initialization & Git Setup

**Type:** setup  
**Priority:** P0 — harus selesai sebelum task lain  
**Status:** pending  
**Estimasi:** 30 menit

---

## Tujuan

Menyiapkan repository Git lokal dan remote GitHub untuk project Orbs Agent agar dapat di-version control, di-share, dan di-deploy.

---

## Konteks Teknis

Project ini adalah **static single-file HTML** (tidak ada package.json, node_modules, atau build step). Struktur sangat sederhana:

```
orbs-agent/
├── index.html     # Seluruh aplikasi (2809 baris)
├── README.md      # Dokumentasi GitHub
└── tasks/         # Task documentation (folder ini)
```

Tidak membutuhkan `.nvmrc`, `package.json`, atau CI pipeline yang kompleks di tahap awal.

---

## Sub-tasks

### 1. Inisialisasi Git Lokal

```bash
cd "/Users/indralesmana/Documents/projects/orbs agent"
git init
```

**Yang dihasilkan:** folder `.git/` tersembunyi di root project.

---

### 2. Buat `.gitignore`

Buat file `.gitignore` dengan isi berikut:

```gitignore
# OS files
.DS_Store
Thumbs.db

# Editor
.vscode/
.idea/
*.swp
*.swo

# Logs
*.log

# Env
.env
.env.local
```

**Kenapa:** Mencegah file sistem macOS (`.DS_Store`) dan editor masuk ke repo.

---

### 3. Initial Commit

```bash
git add index.html README.md .gitignore tasks/
git commit -m "feat: initial release — Orbs Agent landing page v1.0

- Dark luxury landing page untuk Orbs Agent protocol
- Hero, Problem, How It Works, Roadmap, CTA sections
- API Reference modal dengan 11 endpoints
- Whitepaper modal dengan newspaper layout
- Custom cursor, scroll animations, responsive design"
```

**Konvensi commit:** gunakan [Conventional Commits](https://www.conventionalcommits.org/)
- `feat:` = fitur baru
- `fix:` = bug fix
- `docs:` = perubahan dokumentasi
- `style:` = perubahan tampilan tanpa logika
- `refactor:` = refactor kode

---

### 4. Buat Repository di GitHub

**Via GitHub web:**
1. Buka `github.com/new`
2. Repository name: `orbs-agent`
3. Description: `On-chain identity and reputation layer for AI agents — landing page`
4. Visibility: **Public** (agar bisa di-host dengan GitHub Pages gratis)
5. **JANGAN** centang "Initialize with README" — kita sudah punya
6. Klik "Create repository"

**Via GitHub CLI (opsional, lebih cepat):**
```bash
gh repo create orbs-agent --public --description "On-chain identity and reputation layer for AI agents"
```

---

### 5. Push ke GitHub

```bash
git remote add origin https://github.com/USERNAME/orbs-agent.git
git branch -M main
git push -u origin main
```

Ganti `USERNAME` dengan username GitHub Anda.

---

### 6. Verifikasi

Setelah push, cek:
- [ ] `github.com/USERNAME/orbs-agent` bisa dibuka
- [ ] File `index.html` dan `README.md` terlihat
- [ ] README.md ter-render dengan benar di halaman repo
- [ ] Badge di README tampil (Version, Status, dll)

---

## Referensi Teknologi

| Teknologi | Versi | Fungsi |
|---|---|---|
| Git | 2.x | Version control |
| GitHub | — | Remote repository hosting |
| GitHub Pages | — | Static site hosting (opsional, lihat task deployment) |

---

## Catatan

- Jika nama folder mengandung spasi (`orbs agent`), selalu gunakan quotes: `"/Users/.../orbs agent"`
- Branch utama dinamai `main` (bukan `master`) sesuai standar GitHub terbaru
- Untuk sekarang cukup satu branch. Branching strategy (feature branch, dll) bisa ditambahkan nanti
