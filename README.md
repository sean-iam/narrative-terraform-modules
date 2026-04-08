# Narrative Terraform Modules

Productized Terraform modules for identity infrastructure provisioning.
Built by [Narrative Consulting](https://accessnarrative.com).

44 modules across 4 identity platforms, all driven by a single `risk_profile` toggle.

## Risk Profiles

Every module accepts a `risk_profile` variable that controls security posture:

| Profile | Description |
|---|---|
| **Standard** | Baseline security. MFA via push/prompt, OFAC geo-blocking, 12-char passwords, relaxed session timeouts. Good for early-stage companies getting their first audit. |
| **Elevated** | Phishing-resistant MFA (number challenge), expanded geo-blocking, 14-char passwords, tighter sessions. For companies with active SOC 2 or regulatory obligations. |
| **Strict** | Hardware security keys required, allowlist-only geo-access, 16-char passwords, short sessions, auto-remediation. For companies under OCC, FedRAMP, or similar scrutiny. |

All module-specific settings default to `null`, meaning the risk profile drives everything. Override individual settings when you need to deviate without changing the whole profile.

## Platforms

### Okta Identity Engine (`okta/`)

Core IDP configuration for Okta.

| Module | Description |
|---|---|
| `groups` | Group hierarchy, admin roles, auto-assignment rules, geo-exception groups |
| `policies-signon` | Per-role sign-on policies with MFA requirements |
| `policies-password` | Tiered password policies by role |
| `network` | Network zones, OFAC/geo-blocking, trusted IPs |
| `apps` | SAML/OIDC/service app templates |
| `auth-server` | Custom authorization server, scopes, claims |
| `authenticators` | MFA methods and enrollment policies |
| `behaviors` | Anomaly detection (impossible travel, new device) |
| `user-schema` | Custom profile attributes for lifecycle management |
| `branding` | Theme, notifications, custom domain |
| `event-hooks` | Security event streaming and admin activity alerts |

### Okta Identity Governance (`okta-iga/`)

Access requests, certifications, and entitlement management for Okta IGA.

| Module | Description |
|---|---|
| `governance-policies` | Governance policy configuration, request and approval policies |
| `access-requests` | Request workflows, self-service settings, Slack/Teams integration |
| `certifications` | Campaign schedules, reviewer assignment, auto-remediation |
| `entitlements` | Entitlement management, resource catalogs, bundles |
| `approval-workflows` | Multi-level approval chains, escalation, timeout, delegation |
| `resource-catalog` | Requestable items, visibility rules, ownership |
| `audit-reports` | Governance reporting, scheduled reports, compliance dashboards |
| `lifecycle-rules` | Time-bound access, auto-expiration, extension workflows |
| `separation-of-duties` | SoD policy definitions, toxic combination rules, violation handling |
| `notifications` | Notification templates, reminders, escalation alerts |
| `integrations` | ServiceNow, Jira, Slack, Teams, SIEM forwarding |

> Note: OIG is relatively new. Some modules use placeholder resources where Terraform provider support is still catching up. Each module's `_meta.json` documents the current level of provider coverage.

### Microsoft Entra ID (`entra-id/`)

Identity and access configuration for Azure AD / Entra ID.

| Module | Description |
|---|---|
| `groups` | Security groups, M365 groups, admin role assignments, dynamic membership |
| `authenticators` | Authentication strength policies (Authenticator, FIDO2, phone) |
| `policies-password` | Password policies, banned passwords, lockout |
| `policies-conditional` | Conditional Access policies, session controls, sign-in frequency |
| `network` | Named locations, trusted IPs, country-based geo-blocking |
| `behaviors` | Identity Protection risk policies (sign-in risk, user risk) |
| `auth-server` | App registrations, service principals, token lifetime policies |
| `user-schema` | Directory extension attributes for custom user properties |
| `branding` | Company branding for login pages |
| `event-hooks` | Diagnostic settings for audit/sign-in log streaming |
| `apps` | Enterprise applications (SAML, OIDC, linked SSO) |

### Google Workspace (`google-workspace/`)

Identity and access configuration for Google Workspace.

| Module | Description |
|---|---|
| `groups` | Google Groups for admin roles, functional groups, group settings |
| `authenticators` | 2-Step Verification enforcement and allowed methods |
| `policies-password` | Password length, strength, expiration, reuse |
| `policies-login` | Session controls, duration, re-authentication requirements |
| `network` | Trusted networks, IP allowlists, context-aware access |
| `behaviors` | Login challenges, suspicious activity, account recovery |
| `auth-server` | OAuth app management, API client access, domain-wide delegation |
| `user-schema` | Custom schema fields on user profiles |
| `branding` | Custom logos and login page |
| `event-hooks` | Alert center rules, audit log exports |
| `apps` | Pre-installed apps, SAML configs, app access control |

## Quick Start

1. Pick a platform directory (e.g. `okta/`, `entra-id/`)
2. Copy `terraform.tfvars.example` to `terraform.tfvars`
3. Fill in your provider credentials and choose a `risk_profile`
4. `terraform init && terraform plan`
5. Review and `terraform apply`

## Module Metadata

Each module includes a `_meta.json` file describing every variable with client-facing descriptions, available options, and risk profile defaults. This metadata powers the [Narrative Consulting](https://accessnarrative.com) client configuration wizard.

## License

Proprietary. Copyright Narrative Consulting.
