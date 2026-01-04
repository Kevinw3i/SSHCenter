# API Contract (v1)

Base URL (local dev): http://localhost:3001/api/v1

Notes:
- Admin UI user list/create/edit uses the Users endpoints below.
- OTP QR modal uses GET /api/v1/users/:id/otp_qr.
- Admin select/dropdown lists use client-side filtering via `AdminSelect`; plan for server-side query/pagination when lists grow.
- Admin page layout uses a shared grid (24px content inset) to align headers and table content; no API impact.
- Admin + Web UIs redirect to `/login` and clear session on any 401 response.
- Admin login form uses shared control tokens for sizing and states; no API changes.
- Missing resources return `{"error":"not_found"}` with 404.
- Validation errors return `{"error":[...messages]}` with 422.

## Auth
### POST /api/v1/auth/login
Request:
- username
- password
- otp_code

Response:
- jwt (Authorization header)
- user: id, username, role, open_mode
- Token expiration: admin/manage 12 hours, user 1 hour.

### DELETE /api/v1/auth/logout
- Revokes JWT.

### GET /api/v1/auth/me
- Returns current user profile, access groups, and current IP.

### GET /api/v1/users/:id/otp_qr
- Admin/manager only.
- Returns otp_provisioning_uri and qr_svg.

## Users
### GET /api/v1/users
- Admin/manager only.
- Filters: role, query

### POST /api/v1/users
- Admin/manager only.
- Fields: username, password, role, ssh_public_key, open_mode

### PATCH /api/v1/users/:id
- Admin/manager only.
- Fields: username, role, ssh_public_key, open_mode, otp_reset

### PATCH /api/v1/users/me
- User self profile update.

### PATCH /api/v1/users/me/password
- Fields: current_password, new_password

### PATCH /api/v1/users/me/ssh_key
- Fields: ssh_public_key

## Server Groups
### GET /api/v1/server_groups
- Admin/manager only.
- Response includes server_ids and servers_count for binding UI.

### POST /api/v1/server_groups
- Admin/manager only.
- Fields: name, server_ids (optional array). Name is trimmed on save.

### PATCH /api/v1/server_groups/:id
- Admin/manager only.
- Fields: name, server_ids (optional array)
- Passing server_ids replaces current bindings; omit to keep unchanged.

### DELETE /api/v1/server_groups/:id
- Admin/manager only.
- Unassigns servers from the group.

## Servers
### GET /api/v1/servers
- Returns servers visible to current user via group memberships.
- Client formats connect command as role@ip using `role` and `ip`.

### GET /api/v1/admin/servers
- Admin/manager only.

### POST /api/v1/servers
- Admin/manager only.
- Fields: site, env, role, ip, server_group_id (optional). Strings are trimmed; ip must be valid IPv4.

### PATCH /api/v1/servers/:id
- Admin/manager only.

### DELETE /api/v1/servers/:id
- Admin/manager only.

## Group Memberships
### GET /api/v1/group_memberships
- Admin/manager only.

### POST /api/v1/group_memberships
- Admin/manager only.
- Fields: user_id, server_group_id
- Duplicate assignments return 422.

### DELETE /api/v1/group_memberships/:id
- Admin/manager only.
