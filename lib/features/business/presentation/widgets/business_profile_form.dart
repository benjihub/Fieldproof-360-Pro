import 'package:fieldproof_360/app/theme/app_spacing.dart';
import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:fieldproof_360/features/business/domain/models/business_profile_form_data.dart';
import 'package:fieldproof_360/features/business/domain/models/country_option.dart';
import 'package:fieldproof_360/features/business/domain/services/business_profile_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class BusinessProfileForm extends StatefulWidget {
  const BusinessProfileForm({
    required this.onSubmit,
    required this.submitLabel,
    this.initialData,
    this.isSubmitting = false,
    this.error,
    this.showAdvancedFields = false,
    super.key,
  });

  final BusinessProfileFormData? initialData;
  final Future<bool> Function(BusinessProfileFormData data) onSubmit;
  final String submitLabel;
  final bool isSubmitting;
  final Object? error;
  final bool showAdvancedFields;

  @override
  State<BusinessProfileForm> createState() => _BusinessProfileFormState();
}

class _BusinessProfileFormState extends State<BusinessProfileForm> {
  static const _otherCountry = 'OTHER';

  late final TextEditingController _businessName;
  late final TextEditingController _technicianName;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _address;
  late final TextEditingController _customCountryCode;
  late final TextEditingController _currencyCode;
  late final TextEditingController _reportPrefix;
  late final TextEditingController _taxLabel;
  late final TextEditingController _taxNumber;
  late final TextEditingController _defaultTerms;
  late String _localeCode;
  String? _countrySelection;
  Map<String, String> _errors = const {};

  @override
  void initState() {
    super.initState();
    final initial = widget.initialData;
    final country = initial == null
        ? null
        : CountryCatalog.findByCountryCode(initial.countryCode);
    _countrySelection = initial == null
        ? null
        : country?.countryCode ?? _otherCountry;
    _businessName = TextEditingController(text: initial?.businessName);
    _technicianName = TextEditingController(text: initial?.technicianName);
    _email = TextEditingController(text: initial?.email);
    _phone = TextEditingController(text: initial?.phone);
    _address = TextEditingController(text: initial?.address);
    _customCountryCode = TextEditingController(
      text: country == null ? initial?.countryCode : '',
    );
    _currencyCode = TextEditingController(text: initial?.currencyCode);
    _localeCode = initial?.localeCode ?? 'en';
    _reportPrefix = TextEditingController(text: initial?.reportPrefix ?? 'FP');
    _taxLabel = TextEditingController(text: initial?.taxLabel);
    _taxNumber = TextEditingController(text: initial?.taxNumber);
    _defaultTerms = TextEditingController(text: initial?.defaultTerms);
  }

  @override
  void dispose() {
    _businessName.dispose();
    _technicianName.dispose();
    _email.dispose();
    _phone.dispose();
    _address.dispose();
    _customCountryCode.dispose();
    _currencyCode.dispose();
    _reportPrefix.dispose();
    _taxLabel.dispose();
    _taxNumber.dispose();
    _defaultTerms.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final errorMessage = switch (widget.error) {
      AppException exception => exception.message,
      null => null,
      _ => 'Something went wrong. Please try again.',
    };

    return Form(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.medium),
        children: [
          TextFormField(
            key: const Key('businessNameField'),
            controller: _businessName,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Business / Trading Name',
              hintText: 'Ben Electrical Services',
              errorText: _errors['businessName'],
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          TextFormField(
            key: const Key('technicianNameField'),
            controller: _technicianName,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Your Name',
              errorText: _errors['technicianName'],
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          DropdownButtonFormField<String>(
            key: const Key('countryField'),
            initialValue: _countrySelection,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: 'Country',
              errorText: _errors['countryCode'],
            ),
            items: [
              for (final country in CountryCatalog.supported)
                DropdownMenuItem(
                  value: country.countryCode,
                  child: Text(country.name),
                ),
              const DropdownMenuItem(
                value: _otherCountry,
                child: Text('Other'),
              ),
            ],
            onChanged: widget.isSubmitting ? null : _selectCountry,
          ),
          if (_countrySelection == _otherCountry) ...[
            const SizedBox(height: AppSpacing.medium),
            TextFormField(
              key: const Key('customCountryCodeField'),
              controller: _customCountryCode,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[A-Za-z]')),
                LengthLimitingTextInputFormatter(2),
              ],
              decoration: InputDecoration(
                labelText: 'ISO Country Code',
                hintText: 'UG',
                errorText: _errors['countryCode'],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.medium),
          TextFormField(
            key: const Key('currencyField'),
            controller: _currencyCode,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[A-Za-z]')),
              LengthLimitingTextInputFormatter(3),
            ],
            decoration: InputDecoration(
              labelText: 'Currency',
              hintText: 'USD',
              helperText: _currencyHelper,
              errorText: _errors['currencyCode'],
            ),
            onChanged: (value) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.large),
          Text(
            'Optional details',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.medium),
          TextFormField(
            key: const Key('phoneField'),
            controller: _phone,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Phone'),
          ),
          const SizedBox(height: AppSpacing.medium),
          TextFormField(
            key: const Key('emailField'),
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Email',
              errorText: _errors['email'],
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          TextFormField(
            key: const Key('addressField'),
            controller: _address,
            keyboardType: TextInputType.streetAddress,
            minLines: 2,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Address'),
          ),
          if (widget.showAdvancedFields) ...[
            const SizedBox(height: AppSpacing.large),
            Text(
              'Report defaults',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.medium),
            TextFormField(
              key: const Key('reportPrefixField'),
              controller: _reportPrefix,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [LengthLimitingTextInputFormatter(8)],
              decoration: InputDecoration(
                labelText: 'Report Prefix',
                hintText: 'FP',
                errorText: _errors['reportPrefix'],
              ),
            ),
            const SizedBox(height: AppSpacing.medium),
            TextFormField(
              controller: _taxLabel,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Tax Label',
                hintText: 'VAT',
              ),
            ),
            const SizedBox(height: AppSpacing.medium),
            TextFormField(
              controller: _taxNumber,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Tax Number'),
            ),
            const SizedBox(height: AppSpacing.medium),
            TextFormField(
              controller: _defaultTerms,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(labelText: 'Default Terms'),
            ),
          ],
          if (errorMessage != null) ...[
            const SizedBox(height: AppSpacing.medium),
            Text(
              errorMessage,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: AppSpacing.large),
          FilledButton(
            key: const Key('businessProfileSubmit'),
            onPressed: widget.isSubmitting ? null : _submit,
            child: widget.isSubmitting
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(widget.submitLabel),
          ),
          const SizedBox(height: AppSpacing.large),
        ],
      ),
    );
  }

  void _selectCountry(String? countryCode) {
    final previousSuggestion = CountryCatalog.suggestedCurrency(
      _effectiveCountryCode,
    );
    final currentCurrency = _currencyCode.text.trim().toUpperCase();
    final country = countryCode == null || countryCode == _otherCountry
        ? null
        : CountryCatalog.findByCountryCode(countryCode);

    setState(() {
      _countrySelection = countryCode;
      if (country != null) {
        if (currentCurrency.isEmpty || currentCurrency == previousSuggestion) {
          _currencyCode.text = country.currencyCode;
        }
        _localeCode = country.localeCode;
      } else {
        _localeCode = 'en';
      }
      _errors = const {};
    });
  }

  String get _effectiveCountryCode => _countrySelection == _otherCountry
      ? _customCountryCode.text
      : _countrySelection ?? '';

  String get _currencyHelper {
    final code = _currencyCode.text.trim().toUpperCase();
    if (!RegExp(r'^[A-Z]{3}$').hasMatch(code)) {
      return 'ISO 4217 currency code';
    }

    final symbol = NumberFormat.simpleCurrency(name: code).currencySymbol;
    return symbol == code ? code : '$code · $symbol';
  }

  BusinessProfileFormData _formData() => BusinessProfileFormData(
    businessName: _businessName.text,
    technicianName: _technicianName.text,
    email: _email.text,
    phone: _phone.text,
    address: _address.text,
    countryCode: _effectiveCountryCode,
    currencyCode: _currencyCode.text,
    localeCode: _localeCode,
    reportPrefix: _reportPrefix.text,
    taxLabel: _taxLabel.text,
    taxNumber: _taxNumber.text,
    defaultTerms: _defaultTerms.text,
  );

  Future<void> _submit() async {
    final data = _formData();
    final errors = BusinessProfileValidator.validate(data);
    setState(() => _errors = errors);
    if (errors.isNotEmpty) return;

    await widget.onSubmit(data);
  }
}
