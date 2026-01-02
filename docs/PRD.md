# SSCenter PRD

## Summary
SSCenter is a web-based SSH access hub with a user-facing console-style UI and an internal admin console. The system manages users, servers, and access groups. Authentication requires username + password + OTP. The backend is a Rails 8.1 API with MySQL.

## Development
- Frontend package manager: pnpm.

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
- Pundit authorization with role-based policies.
- Entities: User, ServerGroup, Server, GroupMembership.

### Admin UI (apps/admin)
- Login with username/password/OTP.
- User management: list, create, edit, OTP QR display.
- Server management: create/edit servers, group servers under a named group.
- Permission management: assign groups to users.

### Web UI (apps/web)
- Login with username/password/OTP.
- Terminal-style console UI.
- Persistent header showing user, current time (1s update), and current IP.
- User settings: update password, SSH public key, and open mode (Terminal or Web).
- Server list: view servers by site/env/role, refresh list, select server(s).
- Web mode: embedded terminal-like session with a return control.

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
