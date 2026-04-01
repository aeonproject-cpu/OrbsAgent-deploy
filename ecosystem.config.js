/**
 * PM2 Ecosystem Configuration
 * Orbs Agent — Landing Page
 *
 * Usage:
 *   pm2 start ecosystem.config.js
 *   pm2 start ecosystem.config.js --env production
 *   pm2 stop orbs-agent
 *   pm2 restart orbs-agent
 *   pm2 logs orbs-agent
 *   pm2 monit
 */

module.exports = {
  apps: [
    {
      // ── App Identity ─────────────────────────
      name: 'orbs-agent',
      script: 'npx',
      args: 'serve . --listen 3000 --no-clipboard',

      // ── Runtime ──────────────────────────────
      interpreter: 'none',
      cwd: '/var/www/orbs-agent',

      // ── Process Management ───────────────────
      instances: 1,
      exec_mode: 'fork',
      autorestart: true,
      watch: false,
      max_memory_restart: '256M',

      // ── Logging ──────────────────────────────
      log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
      error_file: '/var/log/pm2/orbs-agent-error.log',
      out_file: '/var/log/pm2/orbs-agent-out.log',
      merge_logs: true,

      // ── Environment: Development ─────────────
      env: {
        NODE_ENV: 'development',
        APP_PORT: 3000,
        APP_URL: 'http://localhost:3000',
      },

      // ── Environment: Production ──────────────
      env_production: {
        NODE_ENV: 'production',
        APP_PORT: 3000,
        APP_URL: 'https://orbsagent.xyz',
      },

      // ── Restart Policy ───────────────────────
      exp_backoff_restart_delay: 100,
      max_restarts: 10,
      min_uptime: '5s',
    },
  ],

  // ── Deployment Config (pm2 deploy) ───────────
  deploy: {
    production: {
      user: 'deploy',
      host: ['your-server-ip'],
      ref: 'origin/main',
      repo: 'git@github.com:your-username/orbs-agent.git',
      path: '/var/www/orbs-agent',
      'pre-deploy-local': '',
      'post-deploy': 'pm2 reload ecosystem.config.js --env production',
      'pre-setup': '',
      ssh_options: 'StrictHostKeyChecking=no',
    },
  },
}
