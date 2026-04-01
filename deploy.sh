#!/bin/bash

# ─────────────────────────────────────────────────────────────
# deploy.sh — Orbs Agent Deployment Script
#
# Usage:
#   bash deploy.sh              # deploy to production
#   bash deploy.sh --env stage  # deploy to staging
#   bash deploy.sh --dry-run    # simulate without deploying
# ─────────────────────────────────────────────────────────────

set -euo pipefail

# ── Colors ────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ── Config ────────────────────────────────────────────────────
APP_NAME="orbs-agent"
APP_DIR="/var/www/orbs-agent"
REPO_URL="https://github.com/your-username/orbs-agent.git"
BRANCH="main"
SERVER_USER="deploy"
SERVER_HOST="your-server-ip"
NGINX_CONFIG="/etc/nginx/sites-available/orbsagent.xyz"
ENV="${ENV:-production}"
DRY_RUN=false

# ── Parse Arguments ───────────────────────────────────────────
for arg in "$@"; do
  case $arg in
    --env=*)   ENV="${arg#*=}" ;;
    --env)     shift; ENV="${1}" ;;
    --dry-run) DRY_RUN=true ;;
    --help)
      echo "Usage: bash deploy.sh [--env=production|staging] [--dry-run]"
      exit 0
      ;;
  esac
done

# ── Logging Helpers ───────────────────────────────────────────
log()     { echo -e "${CYAN}[$(date '+%H:%M:%S')]${NC} $1"; }
success() { echo -e "${GREEN}✔${NC} $1"; }
warn()    { echo -e "${YELLOW}⚠${NC} $1"; }
error()   { echo -e "${RED}✖ ERROR:${NC} $1"; exit 1; }

# ── Banner ────────────────────────────────────────────────────
echo -e "${BLUE}"
echo "  ██████╗ ██████╗ ██████╗ ███████╗"
echo "  ██╔═══██╗██╔══██╗██╔══██╗██╔════╝"
echo "  ██║   ██║██████╔╝██████╔╝███████╗"
echo "  ██║   ██║██╔══██╗██╔══██╗╚════██║"
echo "  ╚██████╔╝██║  ██║██████╔╝███████║"
echo "   ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚══════╝"
echo -e "${NC}"
echo -e "  ${CYAN}AGENT DEPLOYMENT SCRIPT${NC} — ENV: ${YELLOW}${ENV}${NC}"
echo "  ────────────────────────────────────"
echo ""

# ── Dry Run Warning ───────────────────────────────────────────
if [ "$DRY_RUN" = true ]; then
  warn "DRY RUN MODE — no changes will be made"
  echo ""
fi

# ── Step 1: Pre-flight Checks ─────────────────────────────────
log "Running pre-flight checks..."

command -v git  >/dev/null 2>&1 || error "git is not installed"
command -v ssh  >/dev/null 2>&1 || error "ssh is not installed"
command -v rsync>/dev/null 2>&1 || error "rsync is not installed"

# Check current branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
CURRENT_COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")

log "Branch: ${CURRENT_BRANCH} @ ${CURRENT_COMMIT}"

if [ "$CURRENT_BRANCH" != "$BRANCH" ] && [ "$ENV" = "production" ]; then
  warn "You are not on '${BRANCH}'. Deploying from '${CURRENT_BRANCH}'."
fi

# Check for uncommitted changes
if ! git diff-index --quiet HEAD -- 2>/dev/null; then
  warn "You have uncommitted changes. Consider committing before deploying."
fi

success "Pre-flight checks passed"
echo ""

# ── Step 2: Pull Latest ───────────────────────────────────────
log "Pulling latest from origin/${BRANCH}..."

if [ "$DRY_RUN" = false ]; then
  git fetch origin
  git pull origin "$BRANCH"
  success "Code up to date"
else
  warn "[DRY RUN] Would pull from origin/${BRANCH}"
fi
echo ""

# ── Step 3: Sync Files to Server ──────────────────────────────
log "Syncing files to ${SERVER_USER}@${SERVER_HOST}:${APP_DIR}..."

RSYNC_OPTS=(
  -avz
  --delete
  --exclude='.git/'
  --exclude='.env'
  --exclude='node_modules/'
  --exclude='.DS_Store'
  --exclude='*.log'
  --exclude='tasks/'
)

if [ "$DRY_RUN" = false ]; then
  rsync "${RSYNC_OPTS[@]}" \
    ./ \
    "${SERVER_USER}@${SERVER_HOST}:${APP_DIR}/"
  success "Files synced"
else
  warn "[DRY RUN] Would rsync to ${SERVER_USER}@${SERVER_HOST}:${APP_DIR}"
fi
echo ""

# ── Step 4: Set Permissions ───────────────────────────────────
log "Setting file permissions..."

if [ "$DRY_RUN" = false ]; then
  ssh "${SERVER_USER}@${SERVER_HOST}" \
    "find ${APP_DIR} -type f -exec chmod 644 {} \; && find ${APP_DIR} -type d -exec chmod 755 {} \;"
  success "Permissions set"
else
  warn "[DRY RUN] Would set permissions on server"
fi
echo ""

# ── Step 5: Reload Nginx ──────────────────────────────────────
log "Reloading Nginx..."

if [ "$DRY_RUN" = false ]; then
  ssh "${SERVER_USER}@${SERVER_HOST}" \
    "sudo nginx -t && sudo systemctl reload nginx"
  success "Nginx reloaded"
else
  warn "[DRY RUN] Would reload Nginx"
fi
echo ""

# ── Step 6: Health Check ──────────────────────────────────────
log "Running health check..."

if [ "$DRY_RUN" = false ]; then
  sleep 2
  HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "https://orbsagent.xyz" || echo "000")
  if [ "$HTTP_STATUS" = "200" ]; then
    success "Health check passed (HTTP ${HTTP_STATUS})"
  else
    error "Health check failed (HTTP ${HTTP_STATUS})"
  fi
else
  warn "[DRY RUN] Would check https://orbsagent.xyz"
fi
echo ""

# ── Done ──────────────────────────────────────────────────────
echo -e "${GREEN}────────────────────────────────────────────────${NC}"
echo -e "${GREEN}  ✔ Deployment complete!${NC}"
echo -e "${GREEN}  App:    ${NC}https://orbsagent.xyz"
echo -e "${GREEN}  Commit: ${NC}${CURRENT_COMMIT}"
echo -e "${GREEN}  Env:    ${NC}${ENV}"
echo -e "${GREEN}  Time:   ${NC}$(date '+%Y-%m-%d %H:%M:%S')"
echo -e "${GREEN}────────────────────────────────────────────────${NC}"
