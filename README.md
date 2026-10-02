# FieldProof 360 Pro


**Proof of work. Professionally.**

FieldProof 360 Pro is an offline-first mobile application for technicians, field-service professionals and small service businesses to document completed work and produce professional customer reports.

The app is built with Flutter for Android and iOS and is designed to keep core field workflows available even when internet connectivity is unreliable.

## What FieldProof Does

- Customer management
- Field and service reports
- Draft autosaving
- Equipment and site details
- Work-performed documentation
- Materials tracking
- Photo evidence
- Technician and customer signatures
- Professional PDF reports
- Native report sharing
- Offline-first storage
- Subscription-based Pro features

## Typical Workflow

1. Create or select a customer.
2. Start a new service report.
3. Record the reported issue and equipment details.
4. Document diagnosis and work completed.
5. Add materials used.
6. Capture supporting photos.
7. Collect technician or customer signatures.
8. Finalize the report.
9. Generate a professional PDF.
10. Share the report through WhatsApp, email, Drive, AirDrop or another installed application.

Finalized reports are preserved as immutable snapshots so later edits to customer or business information do not change previously issued documents.

## Offline-First Architecture

FieldProof 360 Pro is designed around local persistence.

Core report data is stored in a local Drift/SQLite database, including:

- business profile
- customers
- reports
- materials
- photo metadata
- signatures
- application settings
- usage counters

Report photos and signature files are stored in application-owned local storage rather than database blobs.

This means reports can be created, edited and viewed without a network connection.

## Report Lifecycle

Reports begin as editable drafts.

Drafts:

- autosave locally
- can be associated with customers
- support photos, materials and signatures
- remain editable until finalization

Finalized reports:

- receive a permanent report number
- become read-only
- store a versioned snapshot of their contents
- can be reproduced later as PDFs
- can be duplicated into new drafts

This helps preserve the integrity of documents that have already been issued to customers.

## PDF Generation

FieldProof generates professional A4 service reports from finalized report snapshots.

A report can include:

- business identity
- report number
- customer details
- site information
- equipment details
- reported issue
- diagnosis
- work performed
- recommendations
- materials used
- categorized photos
- signatures
- terms
- page numbering

PDF generation uses the immutable finalized snapshot rather than current customer or business records.

## Sharing

Generated reports can be shared through the native Android or iOS share sheet.

Depending on installed applications, users can share through services such as:

- WhatsApp
- email
- Google Drive
- Files
- Messages
- AirDrop

Generated files are stored in application-owned report export directories.

## Subscription Model

FieldProof 360 Pro integrates RevenueCat for subscription management.

The application uses a `pro` entitlement with monthly and yearly subscription products.

Free users can work with the core product while configured usage limits apply to finalized reports.

Active Pro subscribers receive expanded report access and Pro PDF behavior.

RevenueCat public SDK keys are supplied through build configuration. Secret RevenueCat API keys, App Store Connect private keys and Google service-account credentials must never be included in application source code.

## Technology

### Mobile

- Flutter
- Dart
- Material 3

### State and Navigation

- Riverpod
- go_router

### Local Data

- Drift
- SQLite

### Reports

- pdf
- printing
- share_plus
- cross_file

### Media

- image_picker
- application-owned local file storage

### Subscriptions

- RevenueCat
- Apple StoreKit
- Google Play Billing

## Architecture

The Flutter codebase follows a feature-oriented structure.

`lib/app/`  
Application bootstrap, routing and themes.

`lib/core/`  
Shared errors, utilities and reusable UI components.

`lib/data/`  
Database and persistence infrastructure.

`lib/features/`  
Feature-specific data, domain and presentation layers.

Riverpod provides application state and dependency injection.

`go_router` manages onboarding and the persistent application navigation shell.

Drift handles local persistence and non-destructive schema migrations.

## Responsive UI

FieldProof supports compact and larger mobile layouts.

The interface includes:

- bottom navigation on phones
- navigation rail layouts on wider screens
- responsive content widths
- loading, empty and error states
- light and dark themes
- accessible touch targets and labels

## Privacy Approach

The current application architecture keeps customer and report information primarily on the user's device.

Core field data does not require a cloud account or backend to function.

This provides:

- offline availability
- reduced dependency on network connectivity
- simple local ownership of job records
- fewer external systems handling customer field data

Third-party subscription processing is handled through the platform stores and RevenueCat.

## Application Identity

Android package:

`com.benattech.fieldproof`

iOS bundle identifier:

`com.benattech.fieldproof`

## Local Development

### Requirements

- Flutter stable
- Dart
- Android Studio / Android SDK for Android development
- Xcode for local iOS development on macOS

Install dependencies:

`flutter pub get`

Generate code:

`dart run build_runner build`

Run the application:

`flutter run`

For continuous code generation:

`dart run build_runner watch`

## RevenueCat Configuration

Public SDK keys should be provided through Dart defines or CI configuration.

Example:

`--dart-define=REVENUECAT_APPLE_KEY=appl_YOUR_PUBLIC_KEY`

`--dart-define=REVENUECAT_GOOGLE_KEY=goog_YOUR_PUBLIC_KEY`

The project expects a RevenueCat entitlement named:

`pro`

with monthly and annual store products configured for the supported platforms.

## Quality Checks

Run formatting checks:

`dart format --output=none --set-exit-if-changed .`

Run static analysis:

`flutter analyze`

Run automated tests:

`flutter test`

## Branding

FieldProof 360 Pro uses the tagline:

**Proof of work. Professionally.**

The project includes branded application icons, launch screens and an animated Flutter introduction.

Additional branding information is available in:

`docs/BRANDING_ASSETS.md`

## Project Documentation

More detailed implementation and development history is maintained separately from this front-page overview.

See:

- `FIELDPROOF.md`
- `docs/`

## Project Status

FieldProof 360 Pro is a production-oriented Flutter application with Android and iOS targets.

The current codebase includes the complete offline reporting workflow, PDF generation and sharing, subscription infrastructure, production UI polish, legal/support surfaces and release-preparation work.

## Product Goal

FieldProof 360 Pro is designed to give technicians and field-service professionals a simple way to turn everyday service work into organized, professional proof of work.

Instead of relying on paper notes, scattered photos and informal messages, a technician can create a structured record and deliver a professional report from the same mobile device used in the field.
