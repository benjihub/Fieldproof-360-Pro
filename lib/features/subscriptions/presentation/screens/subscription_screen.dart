import 'package:fieldproof_360/app/config/legal_links.dart';
import 'package:fieldproof_360/app/theme/app_spacing.dart';
import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:fieldproof_360/features/reports/domain/models/usage_counter.dart';
import 'package:fieldproof_360/features/reports/presentation/providers/report_providers.dart';
import 'package:fieldproof_360/features/subscriptions/domain/models/subscription_plan.dart';
import 'package:fieldproof_360/features/subscriptions/domain/models/subscription_status.dart';
import 'package:fieldproof_360/features/subscriptions/presentation/providers/subscription_providers.dart';
import 'package:fieldproof_360/features/subscriptions/presentation/view_models/subscription_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/link.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  String? _busyPackage;
  bool _restoring = false;
  bool _managing = false;

  @override
  Widget build(BuildContext context) {
    final configured = ref.watch(subscriptionConfiguredProvider);
    final status = ref.watch(subscriptionStatusProvider);
    final plans = ref.watch(subscriptionPlansProvider);
    final usage = ref.watch(currentReportUsageProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('FieldProof 360 Pro')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.large),
          children: [
            status.when(
              loading: () => const _StatusCard.loading(),
              error: (error, stackTrace) => _StatusCard.error(
                message: _messageFor(error),
                onRetry: _refresh,
              ),
              data: (value) => _StatusCard(status: value, usage: usage),
            ),
            const SizedBox(height: AppSpacing.large),
            Text('Pro includes', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.medium),
            const _Feature(text: 'Unlimited finalized service reports'),
            const _Feature(
              text: 'Remove FieldProof 360 Pro branding from PDFs',
            ),
            const _Feature(text: 'Premium PDF templates as they are added'),
            const _Feature(text: 'Future cloud backup eligibility'),
            const SizedBox(height: AppSpacing.large),
            if (!configured)
              const _NotConfiguredCard()
            else
              status.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => _RetryCard(
                  message: 'Subscription status could not be loaded.',
                  onRetry: _refresh,
                ),
                data: (value) => value.isPro
                    ? _ProActions(
                        managing: _managing,
                        restoring: _restoring,
                        onManage: value.managementUrl == null
                            ? null
                            : () => _manage(value),
                        onRestore: _restore,
                      )
                    : _FreeActions(
                        plans: plans,
                        busyPackage: _busyPackage,
                        restoring: _restoring,
                        onPurchase: _purchase,
                        onRestore: _restore,
                        onRetryPlans: () =>
                            ref.invalidate(subscriptionPlansProvider),
                      ),
              ),
            const SizedBox(height: AppSpacing.large),
            Text(
              'Subscriptions renew automatically unless cancelled through your Apple App Store or Google Play account. Prices shown above come directly from your device store.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.small),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                Link(
                  uri: LegalLinks.privacyPolicy,
                  builder: (context, followLink) => TextButton(
                    key: const Key('subscriptionPrivacyPolicyAction'),
                    onPressed: followLink,
                    child: const Text('Privacy Policy'),
                  ),
                ),
                Link(
                  uri: LegalLinks.termsOfUse,
                  builder: (context, followLink) => TextButton(
                    key: const Key('subscriptionTermsOfUseAction'),
                    onPressed: followLink,
                    child: const Text('Terms of Use'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SubscriptionViewModel get _viewModel =>
      SubscriptionViewModel(ref.read(subscriptionRepositoryProvider));

  Future<void> _refresh() async {
    try {
      await _viewModel.refresh();
      ref.invalidate(subscriptionPlansProvider);
      ref.invalidate(currentReportUsageProvider);
    } on AppException catch (error) {
      _showMessage(error.message);
    }
  }

  Future<void> _purchase(SubscriptionPlan plan) async {
    setState(() => _busyPackage = plan.packageIdentifier);
    try {
      final status = await _viewModel.purchase(plan);
      ref.invalidate(currentReportUsageProvider);
      if (!mounted) return;
      _showMessage(
        status.isPro
            ? 'FieldProof 360 Pro is now active.'
            : 'Purchase completed, but Pro access is still being verified.',
      );
    } on PurchaseCancelledException {
      // Cancellation is a normal user choice; no error message is needed.
    } on AppException catch (error) {
      _showMessage(error.message);
    } finally {
      if (mounted) setState(() => _busyPackage = null);
    }
  }

  Future<void> _restore() async {
    setState(() => _restoring = true);
    try {
      final status = await _viewModel.restore();
      ref.invalidate(currentReportUsageProvider);
      if (!mounted) return;
      _showMessage(
        status.isPro
            ? 'Your FieldProof 360 Pro purchase was restored.'
            : 'No active FieldProof 360 Pro subscription was found.',
      );
    } on AppException catch (error) {
      _showMessage(error.message);
    } finally {
      if (mounted) setState(() => _restoring = false);
    }
  }

  Future<void> _manage(SubscriptionStatus status) async {
    setState(() => _managing = true);
    try {
      await _viewModel.manage(status);
    } on AppException catch (error) {
      _showMessage(error.message);
    } finally {
      if (mounted) setState(() => _managing = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _messageFor(Object error) =>
      error is AppException ? error.message : 'Subscriptions are unavailable.';
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.status, required this.usage})
    : message = null,
      onRetry = null,
      loading = false;

  const _StatusCard.loading()
    : status = null,
      usage = null,
      message = null,
      onRetry = null,
      loading = true;

  const _StatusCard.error({required this.message, required this.onRetry})
    : status = null,
      usage = null,
      loading = false;

  final SubscriptionStatus? status;
  final AsyncValue<UsageCounter>? usage;
  final String? message;
  final VoidCallback? onRetry;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.large),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    if (message != null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            children: [
              const Icon(Icons.cloud_off_outlined, size: 40),
              const SizedBox(height: AppSpacing.small),
              Text(message!, textAlign: TextAlign.center),
              TextButton(onPressed: onRetry, child: const Text('Try again')),
            ],
          ),
        ),
      );
    }

    final value = status!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              value.isPro
                  ? Icons.workspace_premium
                  : Icons.description_outlined,
              size: 42,
            ),
            const SizedBox(width: AppSpacing.medium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value.isPro ? 'FieldProof 360 Pro' : 'FieldProof 360 Free',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.xSmall),
                  if (value.isPro)
                    const Text('Unlimited report finalization is active.')
                  else
                    usage?.when(
                          loading: () => const Text('Checking monthly usage…'),
                          error: (error, stackTrace) =>
                              const Text('3 finalized reports per month.'),
                          data: (counter) => Text(
                            '${counter.finalizedReportCount} of 3 free reports used this month.',
                          ),
                        ) ??
                        const Text('3 finalized reports per month.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  const _Feature({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.small),
    child: Row(
      children: [
        const Icon(Icons.check_circle_outline, size: 20),
        const SizedBox(width: AppSpacing.small),
        Expanded(child: Text(text)),
      ],
    ),
  );
}

class _NotConfiguredCard extends StatelessWidget {
  const _NotConfiguredCard();

  @override
  Widget build(BuildContext context) => const Card(
    child: Padding(
      padding: EdgeInsets.all(AppSpacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Subscriptions are not configured in this build.'),
          SizedBox(height: AppSpacing.small),
          Text(
            'Add the RevenueCat public Apple and Google SDK keys using the documented dart-defines before testing purchases.',
          ),
        ],
      ),
    ),
  );
}

class _FreeActions extends StatelessWidget {
  const _FreeActions({
    required this.plans,
    required this.busyPackage,
    required this.restoring,
    required this.onPurchase,
    required this.onRestore,
    required this.onRetryPlans,
  });

  final AsyncValue<List<SubscriptionPlan>> plans;
  final String? busyPackage;
  final bool restoring;
  final ValueChanged<SubscriptionPlan> onPurchase;
  final VoidCallback onRestore;
  final VoidCallback onRetryPlans;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text('Choose a plan', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: AppSpacing.medium),
      plans.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _RetryCard(
          message: 'Could not load subscription prices.',
          onRetry: onRetryPlans,
        ),
        data: (items) => items.isEmpty
            ? const Card(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.large),
                  child: Text(
                    'No subscription products are available. Check the RevenueCat offering and store product configuration.',
                  ),
                ),
              )
            : Column(
                children: [
                  for (final plan in items)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.small),
                      child: _PlanCard(
                        plan: plan,
                        busy: busyPackage == plan.packageIdentifier,
                        disabled: busyPackage != null || restoring,
                        onPurchase: () => onPurchase(plan),
                      ),
                    ),
                ],
              ),
      ),
      const SizedBox(height: AppSpacing.medium),
      TextButton.icon(
        key: const Key('restorePurchasesAction'),
        onPressed: restoring || busyPackage != null ? null : onRestore,
        icon: restoring
            ? const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.restore),
        label: const Text('Restore Purchases'),
      ),
    ],
  );
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.busy,
    required this.disabled,
    required this.onPurchase,
  });

  final SubscriptionPlan plan;
  final bool busy;
  final bool disabled;
  final VoidCallback onPurchase;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan.periodLabel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xSmall),
                Text(
                  plan.price,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),
          FilledButton(
            key: Key('purchase_${plan.packageIdentifier}'),
            onPressed: disabled ? null : onPurchase,
            child: busy
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Choose'),
          ),
        ],
      ),
    ),
  );
}

class _ProActions extends StatelessWidget {
  const _ProActions({
    required this.managing,
    required this.restoring,
    required this.onManage,
    required this.onRestore,
  });

  final bool managing;
  final bool restoring;
  final VoidCallback? onManage;
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      FilledButton.icon(
        key: const Key('manageSubscriptionAction'),
        onPressed: managing ? null : onManage,
        icon: managing
            ? const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.open_in_new),
        label: const Text('Manage Subscription'),
      ),
      TextButton.icon(
        onPressed: restoring ? null : onRestore,
        icon: const Icon(Icons.restore),
        label: const Text('Restore Purchases'),
      ),
    ],
  );
}

class _RetryCard extends StatelessWidget {
  const _RetryCard({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        children: [
          Text(message, textAlign: TextAlign.center),
          TextButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    ),
  );
}
