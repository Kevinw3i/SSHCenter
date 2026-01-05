# UX/UI Spec

## Visual Direction
- Theme: industrial terminal console with phosphor glow and subtle grid texture.
- Contrast: dark surfaces with neon green and cyan accents.
- Motion: purposeful scanline sweeps, cursor blink, and staggered panel reveals.
- Admin: professional operations console aligned to the same palette (less glow, more clarity).

## Brand Tokens
Source of truth: packages/ui/tokens.json
- Font base: IBM Plex Sans
- Font display: Oxanium
- Font mono: JetBrains Mono
- Accent: neon green (#7cff6b) + cyan (#3dd6ff)
- Background: ink-900 (#0b0f14) + surface base (#141c25)

## Web (apps/web) Layout
### Shell
- Top status bar: user name, current time (1s refresh), current IP.
- Left module rail: User Info, Server List (expandable later).
- Content area: terminal-like cards with glow borders.

### Login Screen
- Single focus card.
- Fields: username, password, OTP code.
- Copy: short, direct, security-first tone.

### User Info
- Sections: change password, SSH public key, open mode (Terminal/Web).
- Open mode is a two-option toggle (single select).

### Server List
- Table-like list with monospace alignment: Site / Env / Role / IP.
- Actions: refresh, multi-open toggle, enter server.
- Terminal command format uses role@IP.
- Web open mode: in-page terminal simulation with a clear "Back to list" control.

## Admin (apps/admin) Layout
- Global shell with sidebar + topbar + content header using Element Plus.
- Login screen uses a split ops hero + form card, with helper copy and OTP hint (no registration).
- User management: list page + dedicated create/edit page; OTP QR modal for enrollment.
- Server management: table + create/edit modal; group assignment removed.
- Group settings: create/edit/delete groups; bind servers via multi-select.
- Permission management: user list + group assignment panel with remove action.

## UX Copy (English)
- Admin login headline: "Secure Ops Gateway"
- Admin login helper: "Use your admin credentials and current OTP."
- OTP field label: "One-time code"
- Server list empty: "No servers assigned yet. Contact an admin to get access."
- Access denied: "You do not have permission to view this resource."

## Admin UI Kit (Figma Spec)
### Layout
- Sidebar width: 248px; background: ink-800; active item uses cyan indicator.
- Topbar height: 56px; title + ops label on left, language + logout on right.
- Content padding: 24px top, 24px horizontal, 32px bottom.
- Page layout grid: content header and card content align to a 24px inner inset; actions align to the title row.
- Content header: eyebrow (optional), title, subtitle, right-aligned action slot with consistent spacing.
- Section spacing: 24px vertical gap between header and content card.
- Card padding: 24px; table toolbar and filters use the same 24px inset as table cells.
- Max width: full width within content padding (no hard max unless a page explicitly needs one).

### Header Dropdown (Language)
- Container: surface-panel background, border-strong, radius-md, shadow-sm, padding 4px.
- Options: 36px height, 12px horizontal padding, font-size-sm, text-secondary; hover uses cyan wash; selected uses cyan wash + left accent.
- Positioning: bottom-end aligned to trigger, 8px offset, popper teleported to body with z-index 1200 (below modals).
- Spacing: dropdown width 160px; avoid overlap with topbar actions.

### Login Layout
- Desktop: two-column split with hero left and form card right; card width 360-400px, padding 28px, max width container 980px, balanced gap 40-56px.
- Mobile: single column; form card first, hero below; card width 100%, padding 24px, compact hero spacing, decorative orbit reduces to two tiles.

### Table/List Pattern
- Table card with header toolbar (title + subtitle) and optional filter row.
- Table headers: uppercase, 11px, muted text, panel background.
- Row height: 48px (16px vertical padding), subtle hover highlight.
- Actions column right-aligned; text buttons only.
- Subtitle can include item count (e.g. "Grouped by site · 12 servers").
- Empty state uses `el-empty` with concise copy and optional action CTA (create primary).
- Loading uses the table overlay spinner while data is fetching.
- Permission filters show a muted note when a duplicate assignment is selected; assign button stays disabled.

### Form Controls
- Tokens: `--control-height-md` (36px), `--control-height-sm` (28px), `--control-padding-x` (12px), `--control-padding-y` (6px).
- Input/OTP: height 36px, padding 6px 12px, radius-md, background surface-elevated, border-subtle, clear/suffix icon centered.
- Input inner field: borderless/transparent, full-width to match the container; focus styling stays on the wrapper.
- States: default (surface-elevated + border-subtle), hover (border-strong), focus (accent-cyan + 1px ring), filled (text-primary), disabled (dim background + muted text), error (danger border + 1px ring), loading (spinner aligned in suffix; field dims).
- Button: height 36px, radius-md, primary uses brand cyan, secondary outline; loading dims and keeps height.
- Validation: required fields show inline error text; server IP validates IPv4 format on blur.
- Error surface: show first API validation error inline via toast to confirm why save failed.

### Select / Dropdown Spec
- Component: `AdminSelect` (Element Plus wrapper) for single, searchable, and multi-select across admin pages.
- Sizes: default 36px height; small 28px for table filters.
- Anatomy: optional label, field container, value/placeholder, clear icon, 12px caret.
- States: default (surface-elevated + border-subtle), hover (surface-panel + border-strong), focus (accent-cyan + 1px ring), filled (surface-panel + border-strong), disabled (dim background + muted text), error (danger border + helper text).
- Searchable: use `filterable` for >10 options; loading/empty uses i18n `common.loading`, `common.noData`, `common.noMatch`.
- Multi-select: use `multiple` with tags + `collapse-tags` + `max-collapse-tags=2`; clearable enabled when multi or in filter rows.
- Dropdown: min width >= field, max height 240px, internal scroll with thin scrollbar, option height 36px.
- Options: active (cyan wash), selected (cyan wash + left accent), disabled muted; long text uses ellipsis, optional tooltip via `el-tooltip`.
- Interaction: click anywhere to open; selected item pre-highlighted; keyboard (up/down/enter/esc); click outside closes; popper follows on scroll.

### Tokens
- Fonts: IBM Plex Sans (base), Oxanium (display), JetBrains Mono (mono).
- Colors: ink-900/800, surface-base/panel, text-primary/secondary/muted, accent-cyan, accent-neon.
- Spacing scale: 8/12/16/24/32 (use `--space-*` tokens).
- Buttons: Primary (36px height, radius-md, filled), Secondary (36px, outline), Link (text-only).

### Frames
- Admin / Users List (1440x900)
- Admin / User Create-Edit (1440x900)
- Admin / Group Settings (1440x900)
- Admin / OTP QR Modal (1440x900 overlay, 360px modal width)

## States
- Loading: inline spinner + "Loading data" label.
- Empty: table/list empty state with neutral copy and action.
- Error: top banner with concise error and retry.
- Not found (404): show a simple empty state with "Not found" and a back action.
- Success: inline toast for save actions.
- Unauthorized (401): clear session and redirect to login.
- Confirm: modal confirmation required before any create/update/delete/assign/logout.

## Development Notes
- Local API base URL: http://localhost:3001/api/v1
- JWT expiration: admin/manage 12h, user 1h.
- Locale selection persists via local storage for admin and web.
