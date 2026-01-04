# SSCenter PRD

## Summary
SSCenter is a web-based SSH access hub with a user-facing console-style UI and an internal admin console. The system manages users, servers, and access groups. Authentication requires username + password + OTP. The backend is a Rails 8.1 API with MySQL.

## Development
- Frontend package manager: pnpm.
- Local API base URL: http://localhost:3001.

## Goals
- Provide a secure login flow with OTP for both admin and frontend users.
- Allow admins to manage users, server inventory, and access groups.
- Allow users to view and access only the servers granted to them.
- Provide a terminal-inspired frontend experience with multi-server access.
- Support i18n across the entire UI (zh-TW, zh-CN, en).

## Personas
- Admin: full access to user and server management.
- Manager: operational access to admin console with limited controls (policy-driven).
- User: access to a subset of servers via groups.

## Scope
### Backend
- Devise JWT authentication with OTP (TOTP).
- JWT expiration: admin/manage 12 hours, user 1 hour.
- Pundit authorization with role-based policies.
- Entities: User, ServerGroup, Server, GroupMembership.
- API returns JSON `not_found` errors for missing resources to keep clients consistent.

### Admin UI (apps/admin)
- Login with username/password/OTP.
- Login uses standardized form control tokens and a responsive card layout.
- Enterprise layout: sidebar + topbar + content header.
- Page layout template aligns header and card content to a shared grid; table padding standardized for consistency.
- User management: list page + create/edit page, OTP QR modal.
- Server management: create/edit/delete servers; group binding handled in Group Settings.
- Group settings: create/edit/delete groups and bind servers (deleting a group unassigns servers).
- Permission management: assign and remove group access for users.
- Shared Select/Dropdown component: `AdminSelect` wrapper with single/search/multi modes, defined states, and standardized dropdown panel spec.
- 401 unauthorized responses clear the session and redirect to login (admin + web).
- All data mutations require confirmation before submission.
- Admin lists show counts, loading states, and empty states aligned to the shared table pattern.
- Admin forms validate required fields and server IP format.

### Web UI (apps/web)
- Login with username/password/OTP.
- Terminal-style console UI.
- Persistent header showing user, current time (1s update), and current IP.
- User settings: update password, SSH public key, and open mode (Terminal or Web).
- Server list: view servers by site/env/role, refresh list, select server(s).
- Connection command format: role@IP.
- Web mode: embedded terminal-like session with a return control.
- Locale selection persists across admin + web sessions.

## Non-goals (initial release)
- Self-service registration.
- Full SSH gateway implementation (use API integration placeholder).
- Advanced audit logs or SIEM export.

## Success Metrics
- 100% OTP-required logins for all users.
- Admin can create a user and assign a group in under 2 minutes.
- Users can access assigned servers with a single click from the list.

## Risks
- Ruby 4.0.0 availability in target environment.
- Web-based SSH terminal integration complexity.
