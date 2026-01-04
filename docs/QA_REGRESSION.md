# QA Regression Checklist

- Login still requires OTP for all roles.
- JWT auth header accepted across protected endpoints.
- Admin can list users, servers, and groups without errors.
- Admin can edit servers from the list.
- Admin can delete servers and manage group bindings.
- Admin list pages show count, loading overlay, and empty states as expected.
- Admin empty states include the correct create CTA.
- Admin layout uses compact topbar and aligned table actions.
- Admin page header and table content align to the shared grid with consistent table padding.
- Admin language dropdown aligns to the trigger, has no bullets, and does not overlap actions.
- Admin select/dropdown fields use `AdminSelect` with defined states and 240px max-height panels.
- Admin 401 responses clear session and redirect to login.
- Web 401 responses clear session and redirect to login.
- Missing resources return JSON `not_found` errors with 404.
- Admin login card sizing and form control states match the latest tokens on desktop and mobile.
- Admin/web mutations require confirmation before submission.
- Admin tokens last 12 hours; user tokens last 1 hour.
- User server list remains filtered by group membership.
- Web server connect command shows role@IP.
- i18n switches language without layout breakage.
- Locale selection persists across refresh for admin and web.
- Web terminal view returns safely to list.
- Server IP validation blocks invalid entries on admin create/edit.
- Permissions assignments can be removed from the admin list.
- Duplicate permission assignments are blocked and signaled to the user.

## Development Notes
- Local API base URL: http://localhost:3001/api/v1
