# Apple App Store Connect

## App identity

| Field | Copy |
| --- | --- |
| Name | FieldProof 360 Pro |
| Tagline | Proof of work. Professionally. |
| Bundle ID | `com.benattech.fieldproof` |
| Primary category | Business |
| Secondary category | Productivity |
| Privacy Policy URL | https://benattech.me/fieldproof360/privacy |
| Terms of Use URL | https://benattech.me/fieldproof360/terms |
| Support URL | https://benattech.me/fieldproof360/support |
| Support email | wamono.benjamin@gmail.com |

## Store listing metadata

### Subtitle

Professional service reports

### Promotional text

Create polished service reports with photos, signatures, and PDFs. Keep proof of completed work organized on your device.

### Description

FieldProof 360 Pro helps field professionals document completed work with clear, professional service reports.

Create reports for service calls, inspections, maintenance visits, installations, and repairs. Capture the work performed, materials used, customer details, photos, and signatures in one place. Finalize each report and share a polished PDF when the work is complete.

With FieldProof 360 Pro, you can:

- Create and manage customer records.
- Draft service reports with job, equipment, diagnosis, and work-performed details.
- Add before, during, and after photos from your camera or photo library.
- Capture technician and customer signatures.
- Record materials used.
- Finalize reports with permanent report numbers.
- Preview, export, and share professional PDF reports.
- Keep V1 report data locally on your device.

The Free plan includes up to 3 finalized reports per calendar month. FieldProof 360 Pro provides unlimited finalized reports and removes FieldProof 360 Pro branding from PDFs.

Subscriptions renew automatically unless cancelled through your Apple Account. Prices are shown in the App Store before purchase. You can restore eligible purchases and manage your subscription through Apple.

Proof of work. Professionally.

### Keywords

service reports,field service,job reports,work orders,inspection,maintenance,technician,PDF

### Support text

Need help with FieldProof 360 Pro? Visit https://benattech.me/fieldproof360/support or email wamono.benjamin@gmail.com. Include your device model, iOS version, and a short description of the issue. Do not include customer signatures, payment details, or sensitive report content in your first message.

### End User License Agreement

Use Apple’s Standard Licensed Application End User License Agreement for V1.

## App Review notes

FieldProof 360 Pro is an offline-first field reporting app. No account, login, or reviewer credentials are required.

The app launches into a local onboarding flow where the reviewer can enter any business profile details. Customer records, reports, report photos, and signatures are stored locally on the device. The app does not provide a cloud account or cloud sync in V1.

The camera and photo-library permissions are requested only after the reviewer chooses to add a photo to a service report. These photos are attached to that local report.

The app offers auto-renewable subscriptions through Apple in-app purchase. The app retrieves the current offering through RevenueCat and uses the `pro` entitlement to unlock Pro access. There are no external payment links or non-IAP purchase flows. Restore Purchases and Manage Subscription are available in the subscription screen.

For subscription review, please use Apple’s sandbox purchase environment. No test account is needed by the app itself.

## Auto-renewable subscriptions

Create an auto-renewable subscription group named **FieldProof 360 Pro**. Use the following products.

### Monthly Pro

| Field | Copy |
| --- | --- |
| Reference name | FieldProof 360 Pro Monthly |
| Product ID | `fieldproof_pro_monthly` |
| Duration | 1 month |
| Display name | FieldProof 360 Pro Monthly |
| Description | Unlimited finalized service reports and removal of FieldProof 360 Pro branding from PDFs. Renews monthly until cancelled. |

### Yearly Pro

| Field | Copy |
| --- | --- |
| Reference name | FieldProof 360 Pro Yearly |
| Product ID | `fieldproof_pro_yearly` |
| Duration | 1 year |
| Display name | FieldProof 360 Pro Yearly |
| Description | Unlimited finalized service reports and removal of FieldProof 360 Pro branding from PDFs. Renews yearly until cancelled. |

## App Privacy answers

These answers reflect the current code and the RevenueCat Purchases SDK with anonymous users, no custom app user ID, no customer attributes, and no RevenueCat integrations that receive advertising identifiers or other customer data.

### Data collected

Select **Yes, we collect data from this app**.

| Apple data type | Collect? | Linked to the user? | Used for tracking? | Purpose |
| --- | --- | --- | --- | --- |
| Purchases → Purchase History | Yes | No | No | App Functionality; Analytics |
| All other listed data types | No | — | — | — |

Select **Purchase History** because RevenueCat receives purchase information to validate receipts, determine the `pro` entitlement, and provide subscription reporting. Select both **App Functionality** and **Analytics** for that data type. RevenueCat’s App Privacy guidance requires these selections for its Purchases SDK.

### Do not declare as collected

Do not declare local customer records, reports, photos, signatures, PDF files, or business profile fields as collected for this version. They are stored in the app’s local SQLite database or app-owned local files and are not transmitted by FieldProof 360 Pro.

Do not declare payment information. Payment entry and processing happen in Apple’s purchase flow, and the app does not receive payment-card details.

Do not declare location, contacts, browsing history, search history, advertising data, diagnostics, crash data, photos/videos, or user content as collected. The app has no analytics, advertising, crash-reporting, cloud-sync, account, or backend SDK in the current source.

### Verification before submission

Re-check these answers if any of the following changes: a RevenueCat integration is enabled, a custom RevenueCat app user ID is added, customer attributes such as email or phone are sent to RevenueCat, an analytics/crash/advertising SDK is added, cloud sync is introduced, or report content is uploaded.
