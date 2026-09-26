# FIELDPROOF

## 1. Product Definition

FieldProof is a mobile-first service-report application for field technicians, contractors, engineers, maintenance workers, electricians, plumbers, solar installers, HVAC technicians, inspectors, biomedical technicians and similar professionals.

Primary purpose:

**Create a professional field/service report from a phone in minutes using work details, photos and signatures, then generate and share a PDF.**

Platforms:

* Android
* iOS

Framework:

* Flutter

Initial language:

* English

Initial commercial focus:

* United Kingdom
* Australia
* South Africa

Also make the app globally usable, including:

* Uganda
* Kenya
* Nigeria
* United States
* Canada
* New Zealand
* Ireland
* Other English-speaking markets

The app must not contain country-specific assumptions in its core architecture.

---

# 2. Core Product Principle

The user should be able to go from:

New Report → Customer → Work Details → Photos → Signature → PDF

in under approximately two minutes for a simple report.

Do not turn V1 into:

* accounting software
* CRM software
* inventory management
* a technician marketplace
* scheduling software
* invoicing software
* chat
* social media
* AI assistant
* workforce management
* GPS tracking

Those may become future features but are outside V1.

---

# 3. V1 Product Scope

V1 must support:

1. Business profile
2. Customers
3. Service reports
4. Before/during/after photos
5. Work performed
6. Fault/problem description
7. Diagnosis
8. Materials used
9. Recommendations
10. Technician signature
11. Customer signature
12. Professional PDF generation
13. PDF preview
14. Native sharing
15. Local persistent storage
16. Draft reports
17. Finalized reports
18. Search
19. Report duplication
20. Basic free/pro access control
21. RevenueCat subscription integration
22. Restore purchases
23. Settings
24. Dark/light/system theme
25. Currency and locale support

V1 must work without an internet connection except for:

* subscription purchase
* subscription restoration
* RevenueCat entitlement refresh

Core report creation must work completely offline.

---

# 4. Monetization

Use native mobile subscriptions.

iOS:

* Apple StoreKit / App Store In-App Purchase

Android:

* Google Play Billing

Use RevenueCat as the subscription abstraction layer.

Entitlement:

`pro`

Products:

`fieldproof_pro_monthly`

`fieldproof_pro_yearly`

Use the actual product identifiers configured in App Store Connect and Google Play Console if different.

Do not use:

* Stripe
* PayPal
* Paddle

inside the mobile application for digital Pro access.

Paddle may be used for a future web product but is out of scope for this mobile V1.

---

# 5. Free vs Pro

## Free

* Create and save customers
* Create drafts
* Up to 3 finalized reports per calendar month
* One standard PDF template
* Up to 6 report photos
* Technician and customer signatures
* PDF preview
* PDF sharing
* Small “Created with FieldProof” footer

## Pro

* Unlimited finalized reports
* Remove FieldProof footer
* Business logo
* Unlimited or substantially higher photo limit
* Additional PDF templates
* Full report/customer history
* Report duplication
* Advanced business branding
* Future cloud backup eligibility

Do not scatter subscription checks throughout widgets.

Implement a centralized:

`AccessPolicy`

or equivalent domain service.

Example responsibilities:

* `canFinalizeReport()`
* `canRemoveBranding()`
* `maxPhotosPerReport`
* `availableTemplates`
* `remainingFreeReports`

Subscription entitlement must be exposed through a repository/provider.

---

# 6. Subscription Behavior

Use RevenueCat.

Architecture:

Flutter UI
→ SubscriptionRepository
→ RevenueCatService
→ RevenueCat SDK
→ Apple / Google

The rest of the app must not call RevenueCat directly.

The repository exposes:

* current entitlement
* isPro
* offerings
* purchaseMonthly()
* purchaseYearly()
* restorePurchases()
* openCustomerCenter()
* refreshEntitlements()

Support anonymous RevenueCat users in V1.

Do not require FieldProof account registration.

A user must be able to restore purchases.

The application must gracefully continue in Free mode if RevenueCat is temporarily unreachable.

Never block access to locally stored reports because subscription servers are offline.

---

# 7. Architecture

Use a feature-first layered Flutter architecture.

Follow:

UI Layer

* Views
* ViewModels / Controllers

Domain Layer

* Models
* Use cases / policies where useful

Data Layer

* Repository interfaces/implementations
* Local database
* Device/platform services
* RevenueCat service

Use Riverpod for:

* dependency injection
* state management
* ViewModels
* repository providers
* application-wide state

Use `go_router` for navigation.

Use Drift + SQLite for local structured persistence.

Store image files in application storage.

Do NOT store full photo binary blobs directly in SQLite.

SQLite stores file references/paths and metadata.

---

# 8. High-Level Architecture

```text
┌─────────────────────────────────────────────┐
│                    UI                       │
│                                             │
│ Screens / Widgets / Dialogs / Forms         │
│                     │                       │
│                     ▼                       │
│             Riverpod ViewModels             │
└─────────────────────┬───────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────┐
│                 DOMAIN                      │
│                                             │
│ Models                                      │
│ Report finalization rules                   │
│ AccessPolicy                                │
│ Report numbering                           │
│ Validation                                  │
│ Snapshot creation                           │
└─────────────────────┬───────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────┐
│                  DATA                       │
│                                             │
│ CustomerRepository                         │
│ ReportRepository                           │
│ BusinessRepository                         │
│ SubscriptionRepository                     │
│ SettingsRepository                         │
│                     │                       │
│     ┌───────────────┼──────────────┐        │
│     ▼               ▼              ▼        │
│   Drift         File Service   RevenueCat   │
│  SQLite             │           Service     │
└─────────────────────┼───────────────────────┘
                      │
                      ▼
                Device storage
```

PDF generation should be isolated as its own application service.

---

# 9. Suggested Packages

Use current stable mutually compatible versions rather than blindly pinning versions from this document.

Core:

* flutter_riverpod
* riverpod_annotation
* go_router

Database:

* drift
* drift_flutter
* path_provider

Code generation:

* build_runner
* drift_dev
* riverpod_generator

IDs:

* uuid

Formatting/localization:

* intl

Images:

* image_picker
* image
* optional image compression package if required

PDF:

* pdf
* printing

Sharing:

* share_plus

Signature:

* signature

Subscriptions:

* purchases_flutter
* purchases_ui_flutter

Utilities:

* path

Optional before production:

* firebase_core
* firebase_crashlytics
* firebase_analytics

Do not add packages without a concrete reason.

Do not use GetX.

Do not use Bloc.

Do not use a second state management framework.

---

# 10. Proposed Project Structure

```text
lib/
├── app/
│   ├── app.dart
│   ├── bootstrap.dart
│   ├── router/
│   │   ├── app_router.dart
│   │   └── route_names.dart
│   └── theme/
│       ├── app_theme.dart
│       ├── app_colors.dart
│       ├── app_spacing.dart
│       ├── app_typography.dart
│       └── app_radius.dart
│
├── core/
│   ├── constants/
│   ├── errors/
│   │   ├── app_exception.dart
│   │   └── failure.dart
│   ├── extensions/
│   ├── formatting/
│   ├── utils/
│   ├── widgets/
│   └── services/
│       ├── file_service.dart
│       ├── image_service.dart
│       └── pdf_service.dart
│
├── data/
│   ├── database/
│   │   ├── app_database.dart
│   │   ├── tables/
│   │   ├── daos/
│   │   └── migrations/
│   │
│   └── services/
│       └── revenuecat_service.dart
│
├── features/
│   ├── onboarding/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── dashboard/
│   │   └── presentation/
│   │
│   ├── business/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── customers/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── reports/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── pdf/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── subscriptions/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── settings/
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── main.dart
```

A feature can contain:

```text
feature/
├── data/
│   ├── repositories/
│   └── services/
├── domain/
│   ├── models/
│   ├── repositories/
│   └── use_cases/
└── presentation/
    ├── screens/
    ├── widgets/
    └── view_models/
```

Avoid unnecessary layers when a feature is trivial.

Architecture should improve clarity rather than generate boilerplate.

---

# 11. Database Model

Use UUID text primary keys.

Use UTC timestamps internally.

Convert to local time only for presentation.

## BusinessProfile

Fields:

* id
* businessName
* technicianName
* email
* phone
* address
* countryCode
* currencyCode
* localeCode
* logoPath nullable
* taxLabel nullable
* taxNumber nullable
* reportPrefix
* defaultTerms nullable
* createdAt
* updatedAt

There will normally be one local business profile.

---

## Customers

Fields:

* id
* name
* companyName nullable
* phone nullable
* email nullable
* address nullable
* notes nullable
* createdAt
* updatedAt
* archivedAt nullable

Customers should be soft-archived rather than automatically deleted if reports reference them.

---

## Reports

Fields:

* id
* reportNumber
* customerId nullable
* reportType
* status
* title
* siteAddress nullable
* equipmentName nullable
* equipmentManufacturer nullable
* equipmentModel nullable
* equipmentSerial nullable
* issueReported nullable
* diagnosis nullable
* workPerformed
* recommendations nullable
* internalNotes nullable
* startedAt nullable
* completedAt nullable
* finalizedAt nullable
* finalizedSnapshotJson nullable
* pdfTemplateId
* createdAt
* updatedAt
* archivedAt nullable

Report status enum:

* draft
* finalized
* archived

Report type enum:

* service
* maintenance
* inspection
* workCompletion
* siteVisit
* general

Do not create separate tables for every report type in V1.

---

## ReportPhotos

Fields:

* id
* reportId
* filePath
* thumbnailPath nullable
* category
* caption nullable
* sortOrder
* createdAt

Photo category:

* before
* during
* after
* issue
* general

When deleting a photo record, safely delete the associated app-owned files.

---

## ReportMaterials

Fields:

* id
* reportId
* name
* quantity
* unit nullable
* notes nullable
* sortOrder

Do not build inventory management in V1.

These are only materials used on a particular report.

---

## ReportSignatures

Fields:

* id
* reportId
* signatureType
* signerName
* filePath
* signedAt

Signature type:

* technician
* customer

---

## AppSettings

Fields:

* id
* themeMode
* defaultReportType
* defaultPdfTemplate
* hasCompletedOnboarding
* createdAt
* updatedAt

---

## UsageCounters

Fields:

* id
* year
* month
* finalizedReportCount

This is used for Free plan limits.

V1 may keep this locally.

Do not over-engineer anti-abuse mechanisms.

---

# 12. Finalized Report Integrity

This is mandatory.

A finalized report must not change when:

* customer details change
* business details change
* logo changes
* report templates change
* materials are later edited elsewhere

When a user finalizes a report:

1. Validate required fields.
2. Check AccessPolicy.
3. Build a complete immutable `ReportSnapshot`.
4. Serialize the snapshot to JSON.
5. Save it to `finalizedSnapshotJson`.
6. Set `finalizedAt`.
7. Change status to `finalized`.
8. Increment usage counter in the same transaction.
9. Future PDF generation for that report uses the snapshot.

A finalized report should be read-only.

To modify it:

`Duplicate as Draft`

Do not mutate the historical report.

---

# 13. ReportSnapshot Model

The snapshot should contain everything needed to reproduce the report without database joins.

Example conceptual structure:

```text
ReportSnapshot
├── report
│   ├── number
│   ├── type
│   ├── title
│   ├── dates
│   ├── issue
│   ├── diagnosis
│   ├── workPerformed
│   └── recommendations
│
├── business
│   ├── businessName
│   ├── technicianName
│   ├── address
│   ├── phone
│   ├── email
│   ├── tax information
│   └── logoPath
│
├── customer
│   ├── name
│   ├── companyName
│   ├── address
│   ├── phone
│   └── email
│
├── equipment
├── materials[]
├── photos[]
├── signatures[]
└── templateId
```

When possible, snapshot the actual logo/signature/photo files into report-owned storage so that replacing a business logo later does not break an old report.

---

# 14. Local File Architecture

Application support directory:

```text
fieldproof/
├── database/
├── business/
│   └── logo/
├── customers/
├── reports/
│   └── <report_uuid>/
│       ├── photos/
│       │   ├── original/
│       │   └── thumbnails/
│       ├── signatures/
│       └── exports/
└── temp/
```

Never rely on temporary camera/gallery paths.

When importing an image:

1. obtain the selected image
2. copy it into FieldProof-controlled storage
3. create optimized display image/thumbnail
4. save the app-owned path in Drift

Original photos should remain reasonable quality for PDFs.

Prevent massive images from causing memory crashes.

Decode/resize appropriately.

---

# 15. Report Numbering

Default format:

`FP-YYYY-0001`

Example:

`FP-2026-0001`

Business profile allows custom prefix.

Example:

`BEN-2026-0001`

Report number must be assigned transactionally.

Avoid duplicate numbers.

Report IDs and report numbers are separate concepts.

UUID is the internal identity.

Report number is human-facing.

---

# 16. Navigation

Use `go_router`.

Main bottom navigation:

1. Home
2. Reports
3. Customers
4. Settings

Primary routes conceptually:

```text
/
 /onboarding

/home

/reports
/reports/new
/reports/:id
/reports/:id/edit
/reports/:id/photos
/reports/:id/signatures
/reports/:id/preview

/customers
/customers/new
/customers/:id
/customers/:id/edit

/settings
/settings/business
/settings/appearance
/settings/subscription

/paywall
```

Use a shell route for persistent bottom navigation where appropriate.

---

# 17. Onboarding

Keep onboarding short.

Screen 1:
Welcome to FieldProof

Primary CTA:

`Create your first report`

Screen 2:
Business setup

Ask:

* business/trading name
* your name
* country
* currency

Optional:

* phone
* email
* logo

Allow optional items to be skipped.

Do not require:

* account creation
* email verification
* password
* organization setup
* team creation

---

# 18. Dashboard

Dashboard should answer:

* How quickly can I start a report?
* What have I recently worked on?
* How many free reports remain?

Suggested content:

Header:
`Good morning`

Primary CTA:
`+ New Report`

Cards:

* Reports this month
* Drafts
* Free reports remaining or Pro status

Recent reports list.

Do not overload V1 dashboard with analytics.

---

# 19. Report Creation UX

Use a step-based report builder.

Recommended steps:

## Step 1 — Customer & Site

* choose existing customer
* add customer
* site address
* report type
* title

Allow one-off customer details if needed.

---

## Step 2 — Job Details

Fields:

* problem/fault reported
* equipment
* equipment model/serial
* diagnosis
* work performed
* recommendations

`Work performed` should be the most prominent field.

Not every report requires equipment.

---

## Step 3 — Photos

Sections:

BEFORE

DURING

AFTER

Allow:

* camera capture
* gallery selection
* caption
* reorder
* delete

Show compression/loading state.

---

## Step 4 — Materials

Simple rows:

* material
* quantity
* unit
* notes

Do not include stock management.

---

## Step 5 — Signatures

Technician:

* name
* signature

Customer:

* name
* signature

Customer signature may be optional depending on report.

Include Clear and Redo controls.

---

## Step 6 — Review

Show:

* business
* customer
* work details
* images
* signatures

Actions:

* Save Draft
* Preview PDF
* Finalize Report

If Free limit is exceeded:

Finalize Report
→ Paywall

Do not lose draft data when showing paywall.

---

# 20. Autosave

Report creation must autosave.

Never rely only on a final Save button.

Save draft changes:

* after field focus loss where appropriate
* when moving to another report step
* after adding/removing images
* when application backgrounds if practical

A crash should not destroy an entire report.

---

# 21. PDF Architecture

PDF generation must not live inside UI widgets.

Create:

`PdfService`

Inputs:

* ReportSnapshot
* PdfTemplateDefinition
* AccessPolicy / branding flag

Output:

`Uint8List`

PDF service responsibilities:

* build PDF
* paginate
* format typography
* embed images
* embed logo
* embed signatures
* render headers/footers
* render report number
* render page numbering

Do not query Drift from the PDF service.

Repository/ViewModel gathers data and creates a snapshot first.

---

# 22. V1 PDF Layout

A4 default.

Page 1:

* logo
* business name
* SERVICE REPORT
* report number
* date
* customer
* site
* equipment

Sections:

* Reported issue
* Diagnosis
* Work performed
* Materials used
* Recommendations

Following section/pages:

* Before photos
* During photos
* After photos

Last section:

* technician signature
* customer signature
* names
* signature dates

Footer:

Free:
`Created with FieldProof`

Pro:
business/footer only, no FieldProof branding.

Prevent photos from being distorted.

Use consistent max dimensions.

Preserve aspect ratios.

---

# 23. PDF Templates

Create a template abstraction from day one.

For example:

```text
PdfTemplate
- id
- name
- build(snapshot)
```

V1:

`classic`

Future Pro templates:

* modern
* compact
* photoHeavy
* inspection

Do not build all templates during initial implementation.

The architecture only needs to support them.

---

# 24. Sharing

Use native system share sheet.

Share generated PDF as a file.

User can then choose:

* WhatsApp
* Email
* Messages
* Google Drive
* AirDrop
* other installed apps

Do not integrate WhatsApp API.

Do not require WhatsApp to be installed.

Suggested file name:

`FieldProof_FP-2026-0012_ABC-Guest-House.pdf`

Sanitize filenames.

---

# 25. Customer Feature

Customer list supports:

* search by name
* company
* phone

Customer details show:

* contact information
* number of reports
* recent reports

Actions:

* New Report for Customer
* Edit Customer
* Archive Customer

Do not build sales pipelines or CRM stages.

---

# 26. Report Search & Filters

Reports screen:

Search:

* report number
* customer
* title
* equipment

Filters:

* Draft
* Finalized
* All

Optional:

* report type
* date range

Default sort:

Newest first.

---

# 27. Themes & Design System

Use Material 3.

Support:

* Light
* Dark
* System

Create centralized design tokens.

Do not hard-code spacing, typography and radii repeatedly.

Design objectives:

* professional
* clean
* field-friendly
* high readability
* large tap targets
* minimal typing
* one-handed operation where possible

Avoid excessive gradients.

Avoid glassmorphism everywhere.

Avoid decorative UI that slows report creation.

Responsive layouts must work on common small Android devices and modern iPhones.

---

# 28. Internationalization Foundation

V1 UI is English.

However:

* do not hard-code currency symbol
* do not assume `MM/DD/YYYY`
* do not assume UK date format
* do not assume phone format
* do not assume VAT exists
* do not assume postal code terminology
* do not assume metric/imperial units globally

Business profile stores:

* countryCode
* currencyCode
* localeCode

Use `intl` for formatting.

Example:

UK:
GBP

Australia:
AUD

South Africa:
ZAR

Uganda:
UGX

Kenya:
KES

Nigeria:
NGN

US:
USD

Canada:
CAD

Future localization must be possible without rewriting screens.

---

# 29. Report Validation

Minimum requirement before finalization:

* business name
* technician name
* report title
* work performed
* report number
* date

Customer may be optional for generic/internal reports.

Signature requirements should not be universally mandatory.

Photos should not be universally mandatory.

Report validation should exist in domain logic, not be duplicated in several screens.

---

# 30. Error Handling

Create user-friendly errors.

Examples:

* image could not be imported
* insufficient device storage
* PDF generation failed
* purchase unavailable
* purchase cancelled
* restore failed
* database operation failed

Never expose stack traces to users.

Log technical errors in debug mode.

Future production crash reporting may use Crashlytics.

Subscription cancellation is not an error.

---

# 31. Deletion Rules

Draft report:
may be permanently deleted after confirmation.

Finalized report:
prefer Archive rather than Delete.

If permanent deletion is offered:

* require strong confirmation
* delete associated photo/signature/PDF files safely
* delete database children transactionally

Deleting a customer with report history should not destroy finalized reports.

Prefer archive.

---

# 32. Privacy

V1 report/customer data is local to the device.

Do not upload:

* customer names
* addresses
* report photos
* signatures
* report contents

unless cloud sync is explicitly implemented later.

RevenueCat receives information required for subscription management.

If Crashlytics/Analytics is added, document it in privacy policy.

Do not request unnecessary permissions.

No location permission in V1.

No contacts permission.

No microphone permission.

Camera/photo access only when user intentionally uses those features.

---

# 33. Offline Requirements

These functions must work in airplane mode:

* launch app
* view customers
* create customer
* edit customer
* create report
* edit report
* take/import supported local photos
* capture signatures
* generate PDF
* preview PDF
* save report

Native sharing should work according to target application's own requirements.

Subscriptions may display cached entitlement when offline.

Do not require network connectivity merely to open Pro functionality when a recent valid entitlement is cached.

---

# 34. Future Cloud Sync

Do NOT implement cloud sync in initial V1.

Architecture must make it possible later.

Potential future backend:

Supabase/PostgreSQL.

Repositories must hide the persistence mechanism from ViewModels.

Future architecture:

ViewModel
→ Repository
→ Local Drift
→ Sync engine
→ Supabase

Do not couple UI directly to Drift row objects when avoidable.

Map database entities to domain models.

---

# 35. Future Features — Explicitly Out of Scope

Do not implement these until requested:

* authentication
* Supabase
* cloud sync
* team accounts
* technician management
* scheduling
* job dispatch
* inventory
* invoices
* quotations
* payment collection
* GPS
* maps
* timesheets
* payroll
* customer web portal
* AI
* OCR
* speech transcription
* messaging
* marketplace
* web app

Architecture may leave extension points for them.

Do not prematurely implement them.

---

# 36. State Management Rules

Use Riverpod.

Recommended provider categories:

* databaseProvider
* repository providers
* service providers
* businessProfileProvider
* reportsProvider
* reportDetailProvider(reportId)
* customersProvider
* customerDetailProvider(customerId)
* subscriptionProvider
* appSettingsProvider

Feature actions belong in ViewModels/Notifiers.

Widgets should:

* display state
* collect input
* emit user actions

Widgets must not directly:

* execute SQL
* call RevenueCat
* move files
* generate PDFs
* implement subscription rules

---

# 37. Repository Interfaces

Create domain-facing interfaces.

Example conceptual APIs:

## CustomerRepository

* watchCustomers()
* watchCustomer(id)
* createCustomer()
* updateCustomer()
* archiveCustomer()
* searchCustomers()

## ReportRepository

* watchReports()
* watchReport(id)
* createDraft()
* updateDraft()
* addPhoto()
* removePhoto()
* addMaterial()
* saveSignature()
* finalizeReport()
* duplicateAsDraft()
* archiveReport()
* getFinalizedReportCountForMonth()

## BusinessRepository

* watchBusinessProfile()
* saveBusinessProfile()

## SubscriptionRepository

* watchEntitlement()
* getOfferings()
* purchaseMonthly()
* purchaseYearly()
* restorePurchases()
* openCustomerCenter()

## SettingsRepository

* watchSettings()
* updateTheme()
* updateDefaultTemplate()

---

# 38. Transactions

Use Drift transactions for operations requiring consistency.

Examples:

Finalizing report:

```text
BEGIN
validate report
assign/finalize report number
save snapshot
set status finalized
increment monthly usage
COMMIT
```

Deleting a draft:

```text
BEGIN
delete children
delete report
COMMIT
delete orphaned files safely
```

Database and filesystem cannot share a true transaction.

Design file cleanup so failures do not corrupt report metadata.

---

# 39. Database Migrations

Start schemaVersion at 1.

Never use destructive production migrations.

Every schema change after release must include migration logic.

Add migration tests before release.

Keep migration history understandable.

Do not delete users' reports during schema upgrades.

---

# 40. Performance Requirements

Report list should remain responsive with thousands of reports.

Use database filtering instead of loading entire database and filtering in Dart.

Generate thumbnails for report lists.

Do not decode full-resolution photos just to display thumbnails.

PDF generation should show progress/loading.

Avoid performing heavy image work on the UI thread where it causes jank.

Handle low-memory Android devices reasonably.

---

# 41. Accessibility

Use:

* meaningful semantic labels
* sufficient text contrast
* scalable text where practical
* minimum practical touch target sizes
* labels instead of relying purely on icons

Signature screen needs clear instructions.

Do not encode report status using color alone.

---

# 42. Security

Do not store secrets in source control.

RevenueCat platform public SDK keys should be supplied through project configuration/environment/dart-defines as appropriate.

Never include App Store Connect private keys or Google service-account private keys inside the app.

Database remains inside application sandbox.

Sanitize filenames.

Validate file types before processing.

Protect against malformed or unexpectedly huge images.

---

# 43. App Configuration

Create environment abstraction:

```text
AppConfig
- environment
- revenueCatAppleKey
- revenueCatGoogleKey
```

Environments:

* development
* production

Do not create a complicated multi-environment deployment system beyond what is needed.

---

# 44. Testing Strategy

## Unit Tests

Must test:

* report number generation
* report validation
* access policy
* free monthly quota
* Pro access
* snapshot creation
* report duplication
* currency/date formatting
* repository business logic

## Database Tests

Test:

* inserts
* updates
* relationships
* archive behavior
* finalization transaction
* migrations

Use an in-memory Drift database where appropriate.

## Widget Tests

Test:

* onboarding
* report builder navigation
* validation errors
* customer selection
* subscription state
* paywall trigger

## Integration Tests

Critical happy path:

1. fresh install
2. complete onboarding
3. add customer
4. create report
5. add photos
6. add work details
7. capture signatures
8. preview
9. finalize
10. restart application
11. confirm report persists
12. reopen PDF
13. share

Also test airplane-mode core workflow.

---

# 45. Quality Gate

Before considering a phase complete:

Run:

```bash
dart format .
flutter analyze
flutter test
```

There must be:

* no analyzer errors
* no failing tests
* no obvious debug print spam
* no commented-out dead implementations
* no TODO replacing required functionality

Warnings should be intentionally resolved rather than ignored.

---

# 46. CI

Add GitHub Actions eventually for:

* dependency install
* code generation
* format check
* flutter analyze
* flutter test

Do not attempt production App Store signing through ordinary GitHub CI unless explicitly configured.

Android/iOS production builds may later use Codemagic or the chosen signing pipeline.

---

# 47. Development Phases

Do NOT build the entire application in one giant change.

## Phase 0 — Foundation

Create:

* Flutter project
* project architecture
* dependencies
* Riverpod
* router
* theme
* Drift database
* code generation
* base error handling
* basic test setup

Acceptance:

App launches on Android and iOS.

---

## Phase 1 — Onboarding & Business Profile

Build:

* onboarding
* business profile
* country
* currency
* local persistence

Acceptance:

Restarting app preserves onboarding and profile.

---

## Phase 2 — Customers

Build:

* customer model
* repository
* list
* create
* edit
* archive
* search
* detail screen

Acceptance:

Customer CRUD works offline and is tested.

---

## Phase 3 — Reports Core

Build:

* report schema
* report repository
* report list
* create draft
* autosave
* report editor
* report details
* report types/statuses

Acceptance:

Create/edit/reopen draft after restart.

---

## Phase 4 — Photos

Build:

* camera/gallery
* file import
* app-owned file storage
* thumbnails
* categories
* captions
* reorder
* delete

Acceptance:

Photos survive restart and source-gallery changes.

---

## Phase 5 — Materials & Signatures

Build:

* materials
* technician signature
* customer signature
* signature file persistence

Acceptance:

Data survives restart.

---

## Phase 6 — Finalization & Snapshots

Build:

* validation
* report numbering
* snapshot generation
* finalized immutable state
* duplicate-as-draft
* usage counter

Acceptance:

Changing customer/business details does not change finalized report snapshot.

---

## Phase 7 — PDF

Build:

* classic template
* PDF service
* preview
* image layout
* signatures
* page numbering
* Free branding

Acceptance:

Generate readable multi-page PDFs on Android and iOS.

---

## Phase 8 — Sharing

Build:

* sanitized filename
* export cache
* native share sheet

Acceptance:

PDF can be shared from Android and iOS.

---

## Phase 9 — RevenueCat

Build:

* subscription service
* repository
* entitlement provider
* offerings
* paywall
* monthly purchase
* yearly purchase
* restore
* customer center
* AccessPolicy integration

Acceptance:

Sandbox/Test Store purchase unlocks Pro.

Free quota works.

Offline app does not break if RevenueCat fails.

---

## Phase 10 — Polish

Build:

* loading states
* empty states
* error states
* search polish
* responsive layout
* dark mode
* accessibility
* first-run sample/help
* app icon
* launch screen

---

## Phase 11 — Release Preparation

Complete:

* privacy policy
* terms
* App Store screenshots
* Play screenshots
* App Store metadata
* Play metadata
* subscription metadata
* restore-purchase UX
* review notes
* production RevenueCat configuration
* production signing

---

# 48. Definition of V1 Done

V1 is done when a first-time user can:

1. Install FieldProof.
2. Open it without creating an online account.
3. Enter business information.
4. Add a customer.
5. Start a report.
6. Record what happened.
7. Take before/after photos.
8. Add materials.
9. Capture signatures.
10. Preview a professional PDF.
11. Finalize it.
12. Share it.
13. Reopen it days later offline.
14. Upgrade to Pro through Apple/Google.
15. Restore an existing purchase.

Anything else is secondary.

---

# 49. Coding Rules for Codex

Follow these rules throughout development:

1. Read the existing repository before changing files.
2. Do not rewrite functioning code unnecessarily.
3. Implement one phase at a time.
4. Before each phase, state which files will change.
5. Preserve architectural boundaries.
6. Do not call database code directly from Widgets.
7. Do not call RevenueCat directly from Widgets.
8. Do not put PDF generation inside UI Widgets.
9. Use Riverpod consistently.
10. Use repository abstractions.
11. Write tests for business rules.
12. Run formatter, analyzer and tests after implementation.
13. Fix errors rather than suppressing them.
14. Do not add speculative features.
15. Do not introduce a backend without explicit instruction.
16. Do not introduce authentication.
17. Do not change product scope without explaining why.
18. Prefer understandable code over excessive abstraction.
19. Keep files reasonably focused.
20. Never delete user data as part of a migration.
21. Never place secrets in source code.
22. Keep Android and iOS behavior aligned.
23. Use native/adaptive behavior where platform differences matter.
24. Comment architectural decisions, not obvious syntax.
25. Update README when setup requirements change.

---

# 50. Initial Codex Task

Start only with Phase 0.

Before modifying anything:

1. Inspect the repository.
2. Report the existing Flutter/Dart versions.
3. Inspect `pubspec.yaml`.
4. Inspect Android configuration.
5. Inspect iOS configuration.
6. Inspect existing source files.
7. Explain any conflicts with this architecture.
8. Then implement the foundation.

For Phase 0:

* establish the feature-first layered architecture
* configure Riverpod
* configure go_router
* configure Material 3 theme
* configure Drift
* create AppDatabase schema infrastructure
* create app bootstrap
* create route shell
* create basic Home placeholder
* create basic Reports placeholder
* create basic Customers placeholder
* create basic Settings placeholder
* create test infrastructure
* update README with setup and code-generation commands

Use current stable mutually compatible package versions.

Run:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart format .
flutter analyze
flutter test
```

Do not implement customers, reports, PDF generation, RevenueCat or subscriptions yet.

At the end provide:

1. files created
2. files modified
3. architectural decisions
4. commands executed
5. analyzer result
6. test result
7. remaining Phase 0 issues
8. recommended next step

Stop after Phase 0.

