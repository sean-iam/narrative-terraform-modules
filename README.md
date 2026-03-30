# Narrative Terraform Modules

Productized Terraform modules for identity infrastructure provisioning.
Built by [Narrative Consulting](https://accessnarrative.com).

## Okta

Modules for configuring Okta in a zero trust fashion with three risk profiles:

| Profile | Description |
|---|---|
| **Standard** | Baseline security. MFA via Okta Verify push, OFAC geo-blocking, 12-char passwords, 60-min idle timeout. |
| **Elevated** | Phishing-resistant MFA (number challenge), OFAC + high-risk geo-blocking, 14-char passwords, 30-min idle timeout. |
| **Strict** | Hardware security keys required, allowlist-only geo-access, 16-char passwords, 15-min idle timeout. |

### Quick Start

1. Copy `okta/terraform.tfvars.example` to `okta/terraform.tfvars`
2. Fill in your Okta org details and choose a risk profile
3. Run `terraform init && terraform plan` from the `okta/` directory
4. Review the plan and run `terraform apply`

### Modules

Each module configures one aspect of Okta. All modules accept `risk_profile`
and allow individual setting overrides.

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

### _meta.json

Each module includes a `_meta.json` file describing every variable with
client-facing descriptions, available options, and risk profile defaults.
This metadata powers the Narrative Consulting client questionnaire.
