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
- Server management: table + create/edit modal; group selector + create group option.
- Permission management: user list + group assignment panel.

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
- Content padding: 24px top, 28px horizontal, 32px bottom.
- Content header: eyebrow (optional), title, subtitle, right-aligned action slot.

### Table/List Pattern
- Table card with header toolbar (title + subtitle) and optional filter row.
- Table headers: uppercase, 11px, muted text, panel background.
- Row height: 48px, subtle hover highlight.
- Actions column right-aligned; text buttons only.

### Tokens
- Fonts: IBM Plex Sans (base), Oxanium (display), JetBrains Mono (mono).
- Colors: ink-900/800, surface-base/panel, text-primary/secondary/muted, accent-cyan, accent-neon.
- Spacing scale: 8/12/16/24/32 (use `--space-*` tokens).
- Buttons: Primary (36px height, radius-md, filled), Secondary (36px, outline), Link (text-only).

### Frames
- Admin / Users List (1440x900)
- Admin / User Create-Edit (1440x900)
- Admin / OTP QR Modal (1440x900 overlay, 360px modal width)

## States
- Loading: inline spinner + "Loading data" label.
- Error: top banner with concise error and retry.
- Success: inline toast for save actions.

## Development Notes
- Local API base URL: http://localhost:3001/api/v1
