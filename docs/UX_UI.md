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
- Web open mode: in-page terminal simulation with a clear "Back to list" control.

## Admin (apps/admin) Layout
- Global shell with Element Plus layout + dark theme.
- Login screen mirrors OTP flow (no registration).
- User management: table + drawer for edit/create; QR code display.
- Server management: table + form; group selector + create group option.
- Permission management: user list + group assignment panel.

## UX Copy (English)
- Login title: "Secure Console Access"
- OTP field label: "One-time code"
- Server list empty: "No servers assigned yet. Contact an admin to get access."
- Access denied: "You do not have permission to view this resource."

## States
- Loading: inline spinner + "Loading data" label.
- Error: top banner with concise error and retry.
- Success: inline toast for save actions.
