# API Contract (v1)

## Auth
### POST /api/v1/auth/login
Request:
- username
- password
- otp_code

Response:
- jwt (Authorization header)
- user: id, username, role, open_mode

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

### POST /api/v1/server_groups
- Admin/manager only.
- Fields: name

### PATCH /api/v1/server_groups/:id
- Admin/manager only.
- Fields: name

### DELETE /api/v1/server_groups/:id
- Admin/manager only.

## Servers
### GET /api/v1/servers
- Returns servers visible to current user via group memberships.

### GET /api/v1/admin/servers
- Admin/manager only.

### POST /api/v1/servers
- Admin/manager only.
- Fields: site, env, role, ip, server_group_id

### PATCH /api/v1/servers/:id
- Admin/manager only.

## Group Memberships
### GET /api/v1/group_memberships
- Admin/manager only.

### POST /api/v1/group_memberships
- Admin/manager only.
- Fields: user_id, server_group_id

### DELETE /api/v1/group_memberships/:id
- Admin/manager only.
