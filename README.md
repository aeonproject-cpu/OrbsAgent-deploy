# ORBS AGENT

> **The Reputation Protocol for Autonomous AI Agents**

![Version](https://img.shields.io/badge/version-1.0.0-ff007a?style=flat-square)
![Status](https://img.shields.io/badge/status-live-00c864?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-888?style=flat-square)
![Stack](https://img.shields.io/badge/stack-HTML%20%2B%20TailwindCSS-6482ff?style=flat-square)

---

## Overview

AI agents are already everywhere — trading capital, managing positions, executing on your behalf. Every single one: anonymous, disposable, unaccountable.

**Orbs Agent** is the fix.

A dark, futuristic marketing landing page for the Orbs Agent protocol — an on-chain identity and reputation layer for AI agents. Built as a single-file, production-quality static site.

---

## Live Preview

Open `index.html` directly in any browser. No build step. No dependencies to install.

---

## Features

### Pages & Sections
| Section | Description |
|---|---|
| **Hero** | Split layout with large serif headline + protocol narrative |
| **Marquee** | Animated keyword ticker |
| **Problem** | 3-column breakdown + stat block |
| **How It Works** | 4-card protocol flow: Register → Track → Stake → Query |
| **Roadmap** | 4-phase vertical timeline |
| **CTA** | Final conversion block |
| **Footer** | Minimal footer with social links |

### Modals
| Modal | Trigger | Description |
|---|---|---|
| **API Reference** | `API` button in navbar | Full REST API documentation with 11 endpoints, syntax-highlighted code blocks, request/response examples, and tab switching |
| **Whitepaper** | `Docs` in navbar | Full protocol whitepaper styled as a dark luxury newspaper — drop caps, multi-column layout, pull quotes, ASCII architecture diagram, tokenomics table |

### Design Details
- Custom neon pink cursor with lagging glow follower
- Scroll-triggered fade-in animations via `IntersectionObserver`
- Animated marquee ticker
- Card hover effects with animated top-line reveal
- Roadmap dot indicators with pink glow on hover
- 2px pink custom scrollbar
- CSS noise texture overlay
- Subtle dot-grid background

---

## Design System

```
Background:     #050505
Secondary bg:   #0a0a0a
Accent:         #ff007a  (neon pink)
Text primary:   #eaeaea
Text secondary: #888888
Borders:        rgba(255,255,255,0.08)
```

### Typography
- **Headlines** — Playfair Display (serif, 900 weight)
- **Body** — Inter (sans-serif)
- Accent words in pink italic serif
- Uppercase labels with wide letter-spacing

---

## Tech Stack

| Tool | Usage |
|---|---|
| HTML5 | Structure & content |
| TailwindCSS (CDN) | Utility classes + custom config |
| Custom CSS | Design system, animations, modals |
| Vanilla JavaScript | Cursor, scroll animations, modal logic |
| Google Fonts | Playfair Display + Inter |

No build tools. No frameworks. No backend. One file.

---

## File Structure

```
orbs-agent/
├── index.html            # Entire application — 2800+ lines
├── README.md             # This file
├── .env.example          # Environment variables template
├── .gitignore            # Git ignore rules
├── package.json          # Project metadata & npm scripts
├── package-lock.json     # Dependency lock file
├── ecosystem.config.js   # PM2 process manager config
├── nginx.conf            # Nginx web server config
├── deploy.sh             # Automated deployment script
└── tasks/                # Project documentation
    ├── setup/
    │   ├── project-initialization.md
    │   └── technology-stack.md
    ├── design/
    │   └── design-system.md
    ├── html/
    │   └── html-structure.md
    ├── css/
    │   └── css-architecture.md
    ├── javascript/
    │   └── javascript-logic.md
    ├── ui-components/
    │   └── ui-components.md
    ├── modals/
    │   └── modals.md
    └── deployment/
        └── deployment.md
```

---

## API Reference (Demo)

The built-in API docs cover these endpoints:

**Agents**
- `GET /v1/agents/{id}` — Get agent identity
- `GET /v1/agents` — List all agents
- `POST /v1/agents/register` — Register new agent
- `PATCH /v1/agents/{id}` — Update agent
- `DELETE /v1/agents/{id}` — Revoke agent

**Reputation**
- `GET /v1/agents/{id}/reputation` — Get reputation score
- `GET /v1/agents/{id}/history` — Get behavior history

**Staking**
- `POST /v1/agents/{id}/stake` — Add stake
- `GET /v1/agents/{id}/stake` — Get stake position

**Trust**
- `GET /v1/trust/query` — Query trust signal
- `POST /v1/trust/verify` — Batch verify trust

**System**
- `GET /v1/health` — Health check

---

## Whitepaper Sections

1. **Abstract** — Protocol thesis
2. **The Problem** — The anonymous agent economy
3. **The Solution** — Four primitives: Identity, Recording, Staking, Trust Query
4. **Architecture** — Contract system + ASCII diagram
5. **Tokenomics** — ORBS supply, allocation table, vesting
6. **Governance** — DAO transition, phase roadmap

---

## Running Locally

```bash
# Clone the repo
git clone https://github.com/aeonproject-cpu/OrbsAgent.git

# Open in browser
open index.html

# Or serve with any static server
npx serve .
python3 -m http.server 8080
```

---

## Deployment

```bash
# Vercel
vercel --prod

# Netlify
netlify deploy --prod --dir .

# Custom server
bash deploy.sh
```

---

## Roadmap

| Phase | Status | Description |
|---|---|---|
| Phase 1 — Launch | 🟡 In Progress | Token live, community formed |
| Phase 2 — Registry | ⚪ Pending | Agent identity system |
| Phase 3 — Reputation | ⚪ Pending | Scoring engine |
| Phase 4 — Standard | ⚪ Pending | Cross-protocol adoption |

---

## License

MIT — free to use, fork, and build upon.

---

*EST. 2026 — THE REPUTATION PROTOCOL*
