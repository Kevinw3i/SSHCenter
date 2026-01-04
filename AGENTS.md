# AGENTS.md — Global Rules (Codex) + Recycle System Defaults (Vue3 + Rails API)

This document defines how Codex should behave when working with my projects.
Unless overridden by a repository-local AGENTS.md, these rules apply.

---

## 1) Project goal (default for this repo template)
Build a second-hand goods recycle / buyback system:

- Frontend (apps/web): user-facing landing + recycle request form + "My Requests"
  - UI/UX is designed via `$frontend-design` (not Element Plus by default)
- Admin (apps/admin): internal ops for quoting, messaging, proof photos, pickup/shipping workflow
  - Admin UI uses Element Plus
- API (services/api): Rails 8 API mode with Devise JWT, MySQL, Redis
- Unified brand consistency via shared design tokens (packages/ui/tokens.json)
  - Admin derives Element Plus theme from tokens
  - Web derives its UI style from the same tokens (even if not using Element Plus)
- TDD via RSpec (API) + minimal frontend sanity checks
- Maintain PRD + API contract + UX/UI spec + QA docs in /docs

---

## 2) Repo structure (default layout)
apps/web        (Vue 3 + Vite)
apps/admin      (Vue 3 + Vite + Element Plus)
packages/ui     (shared tokens + admin theme + shared UI utilities)
services/api    (Rails 8 API)
docs/           (PRD, API contract, UX/UI spec, QA docs, TDD checklist)

Docs (must exist and be kept up to date):
- docs/PRD.md
- docs/API.md
- docs/UX_UI.md
- docs/TDD_CHECKLIST.md
- docs/QA_TESTCASES.md
- docs/QA_REGRESSION.md

---

## 3) Non-negotiables (must follow)

### Output policy (avoid full doc dumps)
- Default: do NOT paste entire Markdown/JSON files in chat.
- After edits, respond with:
  1) short change summary (max 5 bullets)
  2) list of touched file(s) only (paths)
- Do NOT print unified diffs by default.
  - Only show a diff when I explicitly ask (e.g. “請給 diff”, “/diff”, “show patch”).
- If changes are complex/large:
  - Show ONLY the most relevant snippets (a few key hunks / lines) and explain what changed.
  - Ask me to run `/diff` (or request a patch) if I want the full diff.
- Full file content is ONLY shown when I explicitly ask for it (e.g. “請輸出完整檔案內容”).
- Target files for this rule include (but not limited to):
  - docs/UX_UI.md
  - UI/UX.md
  - packages/ui/tokens.json
  - packages/ui/theme/*

### Documentation-first
Always update docs when behavior changes:
- docs/PRD.md
- docs/API.md
- docs/UX_UI.md
- docs/TDD_CHECKLIST.md
- docs/QA_TESTCASES.md
- docs/QA_REGRESSION.md

### TDD for API
- Write/update RSpec request specs first, then implement.
- Do not merge without passing tests.

### Design authority (must follow)
- `$frontend-design` is the single source of truth for ALL design work:
  - apps/web UI/UX decisions
  - apps/admin visual decisions (within Element Plus constraints)
  - brand tokens evolution (packages/ui/tokens.json)
  - UX/UI spec writing (docs/UX_UI.md)
  - UX copy (empty / error / success copy), state matrix, responsive rules

### Landing page workflow order (apps/web only, must follow)
For **landing pages** (marketing pages, SEO-focused pages, campaign pages) in `apps/web`,
the workflow order is **strict**:

1) Invoke `$seo-optimizer` FIRST
   - define search intent + primary/secondary keywords
   - propose meta/title, heading outline, internal links, and schema strategy

2) Then invoke `$frontend-design`
   - create layout and place copy based on the SEO plan
   - ensure headings/sections/callouts align with keyword intent and user journey

Notes:
- This rule resolves any potential conflict between skill triggers:
  - Landing pages (apps/web) ALWAYS start with `$seo-optimizer`, then `$frontend-design`.
- Ensure the final implementation reflects BOTH outputs:
  - page structure + copy placement (design)
  - metadata/headings/internal links/schema (SEO)
  - and keep docs up to date (especially docs/UX_UI.md and docs/PRD.md where relevant).

### SEO scope (strict)
- `$seo-optimizer` is **ONLY for apps/web (frontend)**.
- `apps/admin` is an internal ops system and **does NOT do SEO**:
  - Do not optimize admin pages for search.
  - Do not add SEO metadata, schema, keyword plans, or content marketing logic to admin.
- If a request mentions SEO for admin, redirect the SEO work to the corresponding public frontend page (apps/web),
  or explicitly state that admin does not require SEO.

### Codex Skills — Design (required)
When a task involves ANY of the following, you MUST invoke `$frontend-design` FIRST:
- new page layout / redesign / visual polish
- component look & feel, spacing/typography/radius/elevation/motion
- design tokens changes or additions
- UX copy / empty-state / error copy / state matrix changes
- admin theme tuning (Element Plus theme vars)

Exception:
- For **landing pages (apps/web)**, follow “Landing page workflow order (apps/web only, must follow)”:
  `$seo-optimizer` → `$frontend-design`.

`$frontend-design` outputs MUST be reflected into repository files.
In chat output, default to a short summary + touched file list only.
Do NOT print diffs unless I explicitly ask (e.g. “請給 diff”, “/diff”).
Do NOT paste full file content unless I explicitly ask for it.

Required design artifacts (update as needed):
- docs/UX_UI.md  (update when needed)
- packages/ui/tokens.json (update when needed)
- packages/ui/theme/* (update when needed)
- If web styling system exists (CSS variables/base styles generated from tokens), update the corresponding files.

### Codex Skills — SQL Optimization Patterns (required)
When a task involves ANY database query performance or scalability concern, you MUST invoke `$sql-optimization-patterns` FIRST.

Trigger examples (non-exhaustive):
- slow API endpoints, slow admin lists, or slow background jobs
- large-table pagination or list endpoints
- N+1 queries or excessive query counts
- designing/changing indexes, schema changes affecting performance
- complex joins, aggregations (COUNT/GROUP BY), subqueries/CTEs
- investigating EXPLAIN / query plan output
- reducing DB load/costs and improving response time

Required outputs when this skill is used:
- Identify the “hot” query/queries (SQL or ActiveRecord) and the call site.
- Provide a concrete optimization plan and apply it:
  - query shape changes (select only needed columns, pre-filter before join, avoid anti-patterns)
  - indexing changes (new/modified indexes via Rails migrations; note index order/coverage)
  - N+1 elimination (e.g., includes/preload/eager_load or batched queries)
  - pagination strategy (avoid large OFFSET; prefer cursor-based patterns when needed)
- Include evidence:
  - EXPLAIN (MySQL) / EXPLAIN ANALYZE (where available) or equivalent query plan notes
  - before/after query count and/or timing (simple, practical evidence is enough)
- Ensure tests still pass; add/adjust request specs if behavior changed.

Notes:
- This project uses MySQL 8+, but the optimization principles still apply.
- Prefer correctness and stability first; then optimize with measurable evidence.

### Codex Skills — SEO Optimizer (apps/web only, required)
When a task involves SEO, search ranking, or marketing/content optimization for **apps/web**, you MUST invoke `$seo-optimizer` FIRST.

Scope guardrails (strict):
- Applies ONLY to: `apps/web`
- Does NOT apply to: `apps/admin`

Trigger examples (non-exhaustive):
- writing or optimizing blog posts / marketing pages / landing pages in `apps/web`
- keyword research, target keyword selection, related/LSI/long-tail keyword expansion
- crafting/optimizing: title (H1), meta description, URL slug, headings (H2/H3), image alt text
- internal link strategy (anchors, link placement, link count targets)
- suggesting structured data (Schema.org JSON-LD) such as Article/HowTo/FAQ
- generating an SEO audit/optimization report with actionable recommendations

Required outputs when this skill is used:
- Confirm content topic + target audience + primary keyword (and any secondary keywords if provided).
- Keyword research (use WebSearch/Read where available):
  - search intent, competitor keyword patterns, related keywords (LSI), long-tail variants
  - difficulty assessment (Low/Medium/High)
- Keyword placement strategy (priorities):
  - High: Title (H1), Meta description, first ~100 characters, H2 distribution
  - Medium: H3, image alt attributes, short keyworded URL slug
  - Low: body usage in natural context (avoid stuffing; optimize for readability first)
- Meta description draft:
  - 120–160 chars (mobile-friendly), includes primary keyword naturally, includes value proposition + CTA
- Heading structure optimization:
  - Single H1, hierarchical H2→H3 (and below) usage, headings should be readable standalone
- Internal link strategy:
  - Identify 3–5 relevant internal links, anchor text includes keywords, link placement is contextual
- Structured data suggestion:
  - Recommend appropriate Schema.org type (e.g., Article / HowTo / FAQ) and provide a ready-to-apply JSON-LD example
- Provide an “SEO Optimization Report” including:
  - keyword analysis summary
  - checklist-style scoring (Title / Meta description / Headings / Internal links / Readability)
  - prioritized improvement actions (top 3–7 items)
- Best practices guardrails:
  - avoid keyword stuffing; keep language natural
  - strengthen E-E-A-T by adding evidence, correct terminology, credible references, and clear author/brand context

### UI/UX consistency (brand-level)
- Both apps must share the same **brand tokens** (colors, spacing, typography, radius) from `packages/ui/tokens.json`.
- Admin uses Element Plus, but its theme must be derived from the same tokens (no ad-hoc divergence).
- Web does not default to Element Plus, but must match the same brand tokens and overall visual direction
  (color palette, typography scale, spacing/radius, elevation style, motion rules).

### UI framework constraints
- apps/admin: Element Plus is the only approved UI framework (unless explicitly overridden).
  - `$frontend-design` may NOT introduce another UI framework for admin.
- apps/web: UI framework is not mandated; prefer custom UI driven by `$frontend-design` and shared tokens.
- Do not introduce inconsistent one-off styling. Extend tokens instead.

### Output rule for design & UX artifacts (default: summary only)
When you modify any of the following files, you MUST update them in the repo,
but in chat output you should show ONLY:
- short change summary (max 5 bullets)
- touched file list (paths)

Do NOT print diffs by default.
Only output a diff when I explicitly request it (e.g. “請給 diff”, “/diff”).

Files:
- docs/UX_UI.md
- UI/UX.md
- packages/ui/tokens.json
- packages/ui/theme/*

Only output FULL file content when I explicitly request it.

Recommended output format:
- Summary bullets
- Touched files list
- (Optional) Diff/patch ONLY when requested

