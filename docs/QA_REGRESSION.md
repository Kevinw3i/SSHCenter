# QA Regression Checklist

- Login still requires OTP for all roles.
- JWT auth header accepted across protected endpoints.
- Admin can list users, servers, and groups without errors.
- Admin can edit servers from the list.
- Admin layout uses compact topbar and aligned table actions.
- User server list remains filtered by group membership.
- Web server connect command shows role@IP.
- i18n switches language without layout breakage.
- Web terminal view returns safely to list.

## Development Notes
- Local API base URL: http://localhost:3001/api/v1
