#!/usr/bin/env node
// Claude Code statusLine script
// Reads JSON from stdin, prints a single status line.

import { execSync } from 'child_process';

let raw = '';
process.stdin.setEncoding('utf8');
for await (const chunk of process.stdin) raw += chunk;

let data = {};
try { data = JSON.parse(raw); } catch { /* empty/invalid input — degrade gracefully */ }

// ── helpers ───────────────────────────────────────────────────────────────────

function progressBar(pct, cells = 10) {
  const filled = Math.round((pct / 100) * cells);
  return '[' + '█'.repeat(filled) + '░'.repeat(cells - filled) + ']';
}

function fmtResetTime(epochSec, includeDay = false) {
  if (!epochSec) return '';
  const d = new Date(epochSec * 1000);
  const hh = String(d.getHours()).padStart(2, '0');
  const mm = String(d.getMinutes()).padStart(2, '0');
  if (includeDay) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    const day = days[d.getDay()];
    return `${day} ${hh}:${mm}`;
  }
  return `${hh}:${mm}`;
}

function colorContext(pct, text) {
  if (pct === null || pct === undefined) return text;
  if (pct >= 90) return `\x1b[1;91m${text}\x1b[0m`;  // bold bright-red
  if (pct >= 75) return `\x1b[91m${text}\x1b[0m`;     // bright red
  if (pct >= 50) return `\x1b[93m${text}\x1b[0m`;     // bright yellow
  return text;
}

function colorWeekly(pct, text) {
  if (pct === null) return text;
  if (pct >= 95) return `\x1b[1;91m${text}\x1b[0m`;  // bold bright-red
  if (pct >= 80) return `\x1b[91m${text}\x1b[0m`;     // bright red
  if (pct >= 50) return `\x1b[93m${text}\x1b[0m`;     // bright yellow
  return text;
}

function shortenPath(p) {
  if (!p) return '';
  const home = process.env.USERPROFILE || process.env.HOME || '';
  if (home && p.startsWith(home)) return '~' + p.slice(home.length).replace(/\\/g, '/');
  return p.replace(/\\/g, '/');
}

function gitBranch(dir) {
  if (!dir) return null;
  try {
    const branch = execSync(
      `git --no-optional-locks -C "${dir}" rev-parse --abbrev-ref HEAD`,
      { encoding: 'utf8', stdio: ['pipe', 'pipe', 'pipe'], timeout: 3000 }
    ).trim();
    return branch === 'HEAD' ? null : branch;
  } catch {
    return null;
  }
}

// ── data extraction ───────────────────────────────────────────────────────────

const rateLimits  = data.rate_limits || {};
const fiveHour    = rateLimits.five_hour  || null;
const sevenDay    = rateLimits.seven_day  || null;
const cwd         = data.workspace?.current_dir || data.cwd || '';
const launchDir   = data.workspace?.project_dir || cwd;  // static session start dir
const repoInfo    = data.workspace?.repo || null;

// ── 1. 5-hour limit ───────────────────────────────────────────────────────────

let fiveHourStr = null;
if (fiveHour) {
  const pct      = fiveHour.used_percentage;
  const bar      = progressBar(pct);
  const reset    = fmtResetTime(fiveHour.resets_at);
  fiveHourStr    = `5h: ${bar} ${Math.round(pct)}%` + (reset ? ` (resets ${reset})` : '');
}

// ── 2. weekly limit ───────────────────────────────────────────────────────────

let weeklyStr = null;
if (sevenDay) {
  const pct   = sevenDay.used_percentage;
  const reset = fmtResetTime(sevenDay.resets_at, true);
  const raw2  = `7d: ${Math.round(pct)}%` + (reset ? ` (resets ${reset})` : '');
  weeklyStr   = colorWeekly(pct, raw2);
}

// ── 3. context window ────────────────────────────────────────────────────────

let ctxStr = null;
const ctxPct = data.context_window?.used_percentage;
if (typeof ctxPct === 'number') {
  const bar = progressBar(ctxPct);
  ctxStr = colorContext(ctxPct, `ctx: ${bar} ${Math.round(ctxPct)}%`);
}

// ── 4. launch dir (session's initial working directory, static) ───────────────

const cwdStr = launchDir ? shortenPath(launchDir) : null;

// ── 5. git repo / branch ──────────────────────────────────────────────────────

let gitStr = null;
const branch = gitBranch(cwd);
if (branch) {
  const repoName = repoInfo ? `${repoInfo.owner}/${repoInfo.name}` : null;
  gitStr = repoName ? `${repoName}:${branch}` : branch;
}

// ── assemble ──────────────────────────────────────────────────────────────────

const parts = [fiveHourStr, weeklyStr, ctxStr, cwdStr, gitStr].filter(Boolean);
process.stdout.write(parts.join('  |  '));
