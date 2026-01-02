# QA Test Cases

## Login
1. Login with valid username/password/OTP -> access granted.
2. Login with invalid OTP -> error shown.
3. Login without OTP -> error shown.
4. Access protected page without login -> redirected to login.

## Admin - Users
1. Create a new user with role user -> appears in list.
2. Edit user role -> policy applied.
3. View OTP QR code -> visible and scannable.
4. Click "Create User" -> navigates to create page and save returns to list.
5. Click "Edit" on a row -> navigates to edit page and save returns to list.

## Admin - Servers
1. Create server with site/env/role/ip -> appears in list.
2. Create group and attach server -> server shows group.
3. Edit server -> updates list with new values.

## Admin - Permissions
1. Assign group to user -> user can see group servers.
2. Remove group from user -> user no longer sees those servers.

## Web - User Settings
1. Update password -> next login uses new password.
2. Update ssh public key -> value persists.
3. Switch open mode -> server click behavior changes.

## Web - Server List
1. Refresh list -> data updates.
2. Multi-open -> select multiple servers and open.
3. Web open mode -> terminal view opens and can return to list.

## Development Notes
- Local API base URL: http://localhost:3001/api/v1
