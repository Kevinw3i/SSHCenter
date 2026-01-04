# QA Test Cases

## Login
1. Login with valid username/password/OTP -> access granted.
2. Login with invalid OTP -> error shown.
3. Login without OTP -> error shown.
4. Access protected page without login -> redirected to login.
5. Admin API returns 401 -> session cleared and redirected to login.
6. Web API returns 401 -> session cleared and redirected to login.
7. Admin token remains valid for 12 hours before requiring re-login.
8. User token expires after 1 hour and redirects to login.
6. Login form input/button sizes match control tokens on desktop and mobile.
7. Login form shows clear focus/error/loading states without icon misalignment.

## Admin - Users
1. Create a new user with role user -> appears in list.
2. Edit user role -> policy applied.
3. View OTP QR code -> visible and scannable.
4. Click "Create User" -> navigates to create page and save returns to list.
5. Click "Edit" on a row -> navigates to edit page and save returns to list.
6. Empty state appears when no users exist.
7. Empty state CTA uses "Create User".
8. List shows loading overlay during fetch.

## Admin - Servers
1. Create server with site/env/role/ip -> appears in list.
2. Edit server -> updates list with new values.
3. Create/edit server without group -> allowed and saved.
4. Delete server -> removed from list after confirmation.
5. Invalid IP shows validation error and blocks save.
6. List shows count and loading overlay; empty state appears when none exist.
7. Empty state CTA uses "Create Server".
8. API validation errors surface the first message in the toast.

## Admin - Groups
1. Create group -> appears in list.
2. Edit group name and bound servers -> updates counts.
3. Delete group -> group removed and servers unassigned after confirmation.
4. Empty state appears when no groups exist.
5. Empty state CTA uses "Create Group".

## Admin - Permissions
1. Assign group to user -> user can see group servers.
2. Remove group from user -> user no longer sees those servers.
3. Remove assignment from list -> membership deleted after confirmation.
4. Assign button disabled until user + group are selected.
5. Empty state appears when no assignments exist.
6. Selecting a duplicate user+group shows the duplicate note and disables the assign button.

## Admin - Select/Dropdown
1. Default/hover/focus/filled/disabled/error states match spec and are visually distinct.
2. Searchable select filters options; no-match and no-data copy uses i18n.
3. Loading state shows i18n loading copy while options fetch.
4. Dropdown max height is 240px with scroll; active/selected styles show cyan highlight; keyboard navigation works.
5. Multi-select tags collapse into +N and show tooltip when exceeding max count.

## Admin - Header Dropdown
1. Language dropdown has no bullets and matches header styling (dark panel, rounded, hover/selected states).
2. Dropdown aligns to the trigger (bottom-end) with 8px offset and does not overlap topbar actions.
3. Dropdown remains correctly positioned on scroll/resize and closes on outside click or ESC.

## Admin - Page Layout
1. Page header title/subtitle aligns with table toolbar and table header text on Users/Servers/Groups.
2. Table header and row text share the same left start line; row height matches the 48px spec.
3. Header-to-card spacing uses the shared 24px vertical gap.

## Locale Persistence
1. Switching language persists on refresh for admin and web.

## API - Errors
1. Requesting a missing resource returns 404 with `error=not_found` (users, servers, groups).

## Confirmations
1. Admin create/edit/delete/assign/logout actions show confirmation before mutation.
2. Web user settings and logout actions show confirmation before mutation.

## Web - User Settings
1. Update password -> next login uses new password.
2. Update ssh public key -> value persists.
3. Switch open mode -> server click behavior changes.

## Web - Server List
1. Refresh list -> data updates.
2. Multi-open -> select multiple servers and open.
3. Web open mode -> terminal view opens and can return to list.
4. Terminal command uses role@IP format.

## Development Notes
- Local API base URL: http://localhost:3001/api/v1
