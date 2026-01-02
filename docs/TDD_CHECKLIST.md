# TDD Checklist

## Auth
- [ ] POST /api/v1/auth/login returns JWT with valid password + OTP
- [ ] POST /api/v1/auth/login rejects invalid OTP
- [ ] GET /api/v1/auth/me returns current user
- [ ] DELETE /api/v1/auth/logout revokes token

## Users
- [ ] Admin can create user with role and open_mode
- [ ] Admin can update user (role, open_mode, ssh_public_key)
- [ ] User can update own password
- [ ] User can update own ssh_public_key
- [ ] Admin can fetch OTP QR data for a user

## Server Groups
- [ ] Admin can create, update, delete server groups
- [ ] Admin can list server groups

## Servers
- [ ] Admin can create and update servers
- [ ] User sees only servers from assigned groups
- [ ] Server list includes site/env/role/ip

## Permissions
- [ ] Admin can assign group to user
- [ ] User sees group-bound servers after assignment

## Development Notes
- Local API base URL: http://localhost:3001/api/v1

## UI Notes
- Admin user create/edit page continues to use POST/PATCH /api/v1/users.
- Web server connect command uses role@IP.
