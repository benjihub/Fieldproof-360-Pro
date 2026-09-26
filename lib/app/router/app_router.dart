import 'package:fieldproof_360/app/router/app_shell.dart';
import 'package:fieldproof_360/app/router/route_names.dart';
import 'package:fieldproof_360/features/customers/presentation/screens/customers_screen.dart';
import 'package:fieldproof_360/features/customers/presentation/screens/add_customer_screen.dart';
import 'package:fieldproof_360/features/customers/presentation/screens/customer_detail_screen.dart';
import 'package:fieldproof_360/features/customers/presentation/screens/edit_customer_screen.dart';
import 'package:fieldproof_360/features/dashboard/presentation/screens/home_screen.dart';
import 'package:fieldproof_360/features/business/presentation/providers/business_providers.dart';
import 'package:fieldproof_360/features/business/presentation/screens/business_profile_screen.dart';
import 'package:fieldproof_360/features/onboarding/presentation/screens/business_setup_screen.dart';
import 'package:fieldproof_360/features/onboarding/presentation/screens/startup_screen.dart';
import 'package:fieldproof_360/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:fieldproof_360/features/reports/presentation/screens/reports_screen.dart';
import 'package:fieldproof_360/features/reports/presentation/screens/new_report_screen.dart';
import 'package:fieldproof_360/features/reports/presentation/screens/report_detail_screen.dart';
import 'package:fieldproof_360/features/reports/presentation/screens/report_editor_screen.dart';
import 'package:fieldproof_360/features/reports/presentation/screens/report_photos_screen.dart';
import 'package:fieldproof_360/features/reports/presentation/screens/report_materials_screen.dart';
import 'package:fieldproof_360/features/reports/presentation/screens/report_signatures_screen.dart';
import 'package:fieldproof_360/features/pdf/presentation/screens/report_pdf_preview_screen.dart';
import 'package:fieldproof_360/features/legal/presentation/screens/privacy_policy_screen.dart';
import 'package:fieldproof_360/features/legal/presentation/screens/terms_of_use_screen.dart';
import 'package:fieldproof_360/features/settings/presentation/providers/settings_providers.dart';
import 'package:fieldproof_360/features/settings/presentation/screens/settings_screen.dart';
import 'package:fieldproof_360/features/subscriptions/presentation/screens/subscription_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

enum AppGate { loading, onboarding, home, error }

GoRouter createAppRouter({
  AppGate gate = AppGate.home,
  String initialLocation = RoutePaths.root,
}) {
  return GoRouter(
    initialLocation: initialLocation,
    redirect: (context, state) => _redirectFor(gate, state.uri.path),
    routes: [
      GoRoute(path: RoutePaths.root, redirect: (context, state) => null),
      GoRoute(
        name: AppRoute.startup.name,
        path: RoutePaths.startup,
        builder: (context, state) =>
            StartupScreen(hasError: gate == AppGate.error),
      ),
      GoRoute(
        name: AppRoute.welcome.name,
        path: RoutePaths.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        name: AppRoute.businessSetup.name,
        path: RoutePaths.businessSetup,
        builder: (context, state) => const BusinessSetupScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppRoute.home.name,
                path: RoutePaths.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppRoute.reports.name,
                path: RoutePaths.reports,
                builder: (context, state) => const ReportsScreen(),
                routes: [
                  GoRoute(
                    name: AppRoute.reportNew.name,
                    path: 'new',
                    builder: (context, state) => NewReportScreen(
                      initialCustomerId:
                          state.uri.queryParameters['customerId'],
                    ),
                  ),
                  GoRoute(
                    name: AppRoute.reportDetail.name,
                    path: ':reportId',
                    builder: (context, state) => ReportDetailScreen(
                      reportId: state.pathParameters['reportId']!,
                    ),
                    routes: [
                      GoRoute(
                        name: AppRoute.reportEdit.name,
                        path: 'edit',
                        builder: (context, state) => ReportEditorScreen(
                          reportId: state.pathParameters['reportId']!,
                        ),
                      ),
                      GoRoute(
                        name: AppRoute.reportPhotos.name,
                        path: 'photos',
                        builder: (context, state) => ReportPhotosScreen(
                          reportId: state.pathParameters['reportId']!,
                        ),
                      ),
                      GoRoute(
                        name: AppRoute.reportMaterials.name,
                        path: 'materials',
                        builder: (context, state) => ReportMaterialsScreen(
                          reportId: state.pathParameters['reportId']!,
                        ),
                      ),
                      GoRoute(
                        name: AppRoute.reportSignatures.name,
                        path: 'signatures',
                        builder: (context, state) => ReportSignaturesScreen(
                          reportId: state.pathParameters['reportId']!,
                        ),
                      ),
                      GoRoute(
                        name: AppRoute.reportPdfPreview.name,
                        path: 'pdf',
                        builder: (context, state) => ReportPdfPreviewScreen(
                          reportId: state.pathParameters['reportId']!,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppRoute.customers.name,
                path: RoutePaths.customers,
                builder: (context, state) => const CustomersScreen(),
                routes: [
                  GoRoute(
                    name: AppRoute.customerNew.name,
                    path: 'new',
                    builder: (context, state) => const AddCustomerScreen(),
                  ),
                  GoRoute(
                    name: AppRoute.customerDetail.name,
                    path: ':customerId',
                    builder: (context, state) => CustomerDetailScreen(
                      customerId: state.pathParameters['customerId']!,
                    ),
                    routes: [
                      GoRoute(
                        name: AppRoute.customerEdit.name,
                        path: 'edit',
                        builder: (context, state) => EditCustomerScreen(
                          customerId: state.pathParameters['customerId']!,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppRoute.settings.name,
                path: RoutePaths.settings,
                builder: (context, state) => const SettingsScreen(),
                routes: [
                  GoRoute(
                    name: AppRoute.businessProfile.name,
                    path: 'business',
                    builder: (context, state) => const BusinessProfileScreen(),
                  ),
                  GoRoute(
                    name: AppRoute.subscription.name,
                    path: 'subscription',
                    builder: (context, state) => const SubscriptionScreen(),
                  ),
                  GoRoute(
                    name: AppRoute.privacyPolicy.name,
                    path: 'privacy-policy',
                    builder: (context, state) => const PrivacyPolicyScreen(),
                  ),
                  GoRoute(
                    name: AppRoute.termsOfUse.name,
                    path: 'terms-of-use',
                    builder: (context, state) => const TermsOfUseScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page not found')),
      body: Center(child: Text('No route exists for ${state.uri.path}.')),
    ),
  );
}

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final gate = switch (ref.watch(appGateProvider)) {
    AsyncData(:final value) => value,
    AsyncError() => AppGate.error,
    _ => AppGate.loading,
  };
  final router = createAppRouter(gate: gate);
  ref.onDispose(router.dispose);
  return router;
}

@Riverpod(keepAlive: true)
Future<AppGate> appGate(Ref ref) async {
  final bootDelay = Future<void>.delayed(const Duration(milliseconds: 1100));
  final settingsFuture = ref.watch(settingsRepositoryProvider).getSettings();
  final profileFuture = ref
      .watch(businessRepositoryProvider)
      .getBusinessProfile();

  final settings = await settingsFuture;
  final profile = await profileFuture;
  await bootDelay;

  return settings.hasCompletedOnboarding && profile != null
      ? AppGate.home
      : AppGate.onboarding;
}

String? _redirectFor(AppGate gate, String path) {
  final isOnboarding =
      path == RoutePaths.welcome || path == RoutePaths.businessSetup;

  return switch (gate) {
    AppGate.loading => path == RoutePaths.startup ? null : RoutePaths.startup,
    AppGate.error => path == RoutePaths.startup ? null : RoutePaths.startup,
    AppGate.onboarding => isOnboarding ? null : RoutePaths.welcome,
    AppGate.home =>
      path == RoutePaths.root || path == RoutePaths.startup || isOnboarding
          ? RoutePaths.home
          : null,
  };
}
