# FieldProof 360 Pro

FieldProof 360 Pro is a mobile-first field and service report application for Android
and iOS. Phase 8 adds professional, snapshot-driven A4 PDF generation, in-app
preview, app-owned PDF exports, and native Android/iOS sharing for finalized reports. Report content, photos, materials,
and signatures remain local and available offline.

## Requirements

- Flutter 3.44.8 or a compatible stable release
- Dart 3.12.2 or a compatible release
- Android Studio and the Android SDK for Android development
- Xcode on macOS for iOS development

## Setup

```bash
flutter pub get
dart run build_runner build
flutter run
```

For continuous code generation during development:

```bash
dart run build_runner watch
```

## Configuration

The app defaults to the development environment. Configuration values can be
supplied with Dart defines when needed:

```bash
flutter run \
  --dart-define=APP_ENV=development \
  --dart-define=REVENUECAT_APPLE_KEY=<apple-public-sdk-key> \
  --dart-define=REVENUECAT_GOOGLE_KEY=<google-public-sdk-key>
```

Phase 9 integrates RevenueCat through `purchases_flutter`. FieldProof uses anonymous RevenueCat customer IDs in V1 because the app still has no account/authentication system. Only RevenueCat public SDK keys belong in the app build; never add RevenueCat secret API keys, App Store Connect private keys, or Google service-account credentials to source control.

Configure RevenueCat with:

- entitlement: `pro`
- Apple monthly product: `fieldproof_pro_monthly`
- Apple yearly product: `fieldproof_pro_yearly`
- Google monthly product: `fieldproof_pro_monthly`
- Google yearly product: `fieldproof_pro_yearly`
- a Current Offering containing RevenueCat Monthly and Annual packages mapped to those store products

Run a configured build with the public SDK keys supplied by your shell or CI
environment. Do not add the key values to source files:

```bash
flutter run \
  --dart-define=APP_ENV=development \
  --dart-define=REVENUECAT_APPLE_KEY=appl_YOUR_PUBLIC_KEY \
  --dart-define=REVENUECAT_GOOGLE_KEY=goog_YOUR_PUBLIC_KEY
```

If the RevenueCat key for the current platform is absent, subscriptions show as unconfigured and the free-report quota is intentionally not enforced. This keeps local development usable before store products are configured.

## Quality checks

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

## Application identity

- Android application ID and namespace: `com.benattech.fieldproof`
- iOS bundle identifier: `com.benattech.fieldproof`

## Architecture

Application setup, routing, and themes live under `lib/app`. Shared errors and
widgets live under `lib/core`. Drift infrastructure lives under `lib/data`.
Product code is grouped feature-first under `lib/features`, with data, domain,
and presentation layers added only when a phase needs them.

Riverpod provides state and dependency injection. `go_router` directs a fresh
installation to onboarding and a configured installation to the persistent
`StatefulShellRoute`. Material 3 themes support system, light, and dark modes.

The Drift schema is version 7. It contains internal database metadata,
`business_profiles`, `app_settings_entries`, `customers`, `reports`,
`report_photos`, `report_materials`, `report_signatures`, and `usage_counters`.
Sequential, non-destructive migrations preserve existing data. The reports
table supports incomplete drafts and immutable finalized reports. Finalization
requires a business/technician identity, report title, and completed work; it
assigns a permanent `PREFIX-YYYY-0001` style number transactionally and stores a
versioned JSON snapshot containing the report, business, customer, equipment,
materials, photos, signatures, and selected PDF template. Report persistence
is exposed through `ReportRepository` and remains fully local and offline.
Reports can be created, viewed, and edited while offline. Draft edits autosave
locally and are flushed when leaving the editor or when the app backgrounds.
Report photos are copied out of camera/gallery temporary locations into
FieldProof-owned application support storage, with generated thumbnails when the
image format is supported by the local decoder. Photo metadata remains in Drift.
Photo changes also update the parent report timestamp so recent-report ordering stays accurate.
Materials are report-scoped rows with quantity, unit, notes, and explicit ordering.
Technician and customer signatures are captured in Flutter, stored as app-owned
PNG files under each report, and referenced from Drift. Replacing a signature
writes the new file before removing the previous file.

Phase 6 tracks monthly finalized-report usage locally. Phase 9 now connects that
usage to RevenueCat: configured Free users are limited to three finalized reports
per calendar month, while active `pro` subscribers are unlimited. Finalized reports
are read-only; the UI can duplicate them
as new drafts, including report-owned materials, photos, and signatures.
Business/customer edits made after finalization do not alter the frozen snapshot.

Onboarding stores the business profile and completion flag in one database
transaction. Business details can be edited from Settings. Theme selection is
stored in application settings and restored on the next launch. All Phase 1
data remains local and works offline.

Customers can be created, viewed, searched, edited, and soft-archived. Active
lists and search exclude archived customers. Repository restoration support is
implemented and tested; an archived-customer management screen is deferred to a
later phase. Customer data is stored only in the local Drift database and
survives application restarts.


## PDF generation and sharing

Phase 7 added `pdf` and `printing`. Phase 8 adds `share_plus` and `cross_file` for explicit native sharing. The PDF engine consumes the immutable
`ReportSnapshot`, never live customer/business tables, so an issued report can
be reproduced after later profile edits. The classic A4 template includes
business identity, report number, customer/site/equipment details, reported
issue, diagnosis, work performed, recommendations, materials, categorized
photos, signatures, terms, page numbering, and the Free-plan FieldProof footer.
Internal notes are intentionally excluded from customer PDFs.

Finalized report details expose **Preview PDF** and **Share PDF**. Sharing first
regenerates the PDF into app-owned report storage under `reports/<id>/exports/`,
then opens the platform share sheet so the user can choose WhatsApp, email, Drive,
AirDrop, Messages, Files, or any other installed compatible target. The preview
screen also exposes a dedicated share action. Stale PDF exports for the same report
are cleaned up best-effort. Drafts must be finalized before an official PDF can be
generated. Phase 9 connects that access-policy layer to the RevenueCat `pro` entitlement. Free users can finalize up to three reports per calendar month; active Pro users can finalize without that limit and PDFs are generated/shared without the `Created with FieldProof` footer. Subscription status is checked through RevenueCat CustomerInfo, which normally uses the SDK's local cache when current data is available. Users can explicitly restore purchases and open their Apple/Google subscription-management URL from Settings.

The iOS Podfile enables `use_frameworks!` as required by the `printing` plugin.
After adding/updating dependencies, run `flutter pub get` before CocoaPods or an
iOS CI build.

## Local report file storage

Report photos are stored under the application support directory in a per-report
folder. SQLite stores only paths, categories, captions, ordering, and timestamps;
image bytes are not stored as database blobs. Signature PNGs are stored under the
report `signatures/` directory using the same app-owned storage strategy. The iOS
project includes camera and photo-library usage descriptions. Android uses the
platform integration provided by `image_picker`.

## Phase 9 subscriptions

The subscription implementation deliberately uses the base `purchases_flutter` SDK and a FieldProof-native paywall instead of `purchases_ui_flutter`. This preserves the existing iOS 13 and Android 21+ deployment range while still using Apple StoreKit / Google Play Billing through RevenueCat.

The subscription screen is available at **Settings → FieldProof 360 Pro** and shows store-localized prices from the current RevenueCat Offering. Purchase cancellation is treated as a normal user action rather than an error. Restore Purchases is only triggered from explicit user interaction. Active subscribers can open the RevenueCat-provided store management URL.

Before store release:

1. Create the FieldProof project in RevenueCat.
2. Add the iOS app with bundle ID `com.benattech.fieldproof`.
3. Add the Android app with package `com.benattech.fieldproof`.
4. Create the `pro` entitlement.
5. Attach `fieldproof_pro_monthly` and `fieldproof_pro_yearly` products from both stores.
6. Create/set a Current Offering with Monthly and Annual packages.
7. Add the public RevenueCat Apple/Google SDK keys to your CI/build environment.
8. Enable/configure In-App Purchases in App Store Connect and subscriptions in Google Play Console.
9. Test purchase, renewal, cancellation, restore, and expiry using sandbox/test accounts before production submission.

After pulling Phase 9 changes, resolve dependencies and regenerate Riverpod code:

```bash
flutter pub get
dart run build_runner build
dart format .
flutter analyze
flutter test
flutter build apk --debug
```



## Phase 10 — Production polish

Phase 10 focuses on production UX rather than new product scope.

Implemented:

- Adaptive navigation: bottom navigation on phones and NavigationRail on wider layouts
- Responsive content widths for key dashboard, reports, customers, and settings surfaces
- Consistent loading, empty, and error-state components
- Refined Material 3 theme, buttons, cards, search, dialogs, and snackbars
- Home dashboard with quick actions, workspace counts, plan status, and recent reports
- Improved onboarding with clear product benefits and privacy reassurance
- In-app workflow help and V1 local-data explanation
- Branded Android/iOS launch backgrounds
- Accessibility-oriented labels, larger touch targets, and status text that does not rely on color alone
- Responsive widget tests for compact and wide layouts

The database schema remains version 7. Phase 10 adds no backend, authentication, or cloud-sync requirement.

### Branding note

Phase 10.5 introduces the FieldProof 360 Pro logo/app icon, branded native launch screens, and a lightweight animated Flutter intro. See `docs/BRANDING_ASSETS.md`.
