# TDD Checklist

## Auth
- [ ] POST /api/v1/auth/login returns JWT with valid password + OTP
- [ ] POST /api/v1/auth/login rejects invalid OTP
- [ ] POST /api/v1/auth/login sets 12h JWT for admin/manage
- [ ] POST /api/v1/auth/login sets 1h JWT for user
- [ ] GET /api/v1/auth/me returns current user
- [ ] DELETE /api/v1/auth/logout revokes token
- [ ] Missing resources return 404 with error `not_found`

## Users
- [ ] Admin can create user with role and open_mode
- [ ] Admin can update user (role, open_mode, ssh_public_key)
- [ ] User can update own password
- [ ] User can update own ssh_public_key
- [ ] Admin can fetch OTP QR data for a user

## Server Groups
- [ ] Admin can create, update, delete server groups
- [ ] Admin can list server groups
- [ ] Admin can bind servers to groups via server_ids
- [ ] Deleting a group unassigns its servers
- [ ] Server group names are trimmed on save

## Servers
- [ ] Admin can create and update servers
- [ ] Admin can delete servers
- [ ] Server create/update allows optional server_group_id
- [ ] Server IP must be valid IPv4 and inputs are trimmed
- [ ] User sees only servers from assigned groups
- [ ] Server list includes site/env/role/ip

## Permissions
- [ ] Admin can assign group to user
- [ ] User sees group-bound servers after assignment
- [ ] Admin can remove a group membership
- [ ] Duplicate group assignments return 422

## Development Notes
- Local API base URL: http://localhost:3001/api/v1

## UI Notes
- Admin user create/edit page continues to use POST/PATCH /api/v1/users.
- Web server connect command uses role@IP.
- Admin select/dropdown fields use `AdminSelect` with defined states, 36/28 sizes, and a 240px max dropdown with scroll.
- Admin 401 responses clear session and redirect to login.
- Admin login form uses shared control tokens for input/button sizing and state styling.
- All admin/web data mutations require confirmation before submission.
- Admin page layout template aligns content header and table cells to the shared 24px inset grid.
