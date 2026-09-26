import 'package:fieldproof_360/app/theme/app_spacing.dart';
import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:fieldproof_360/features/customers/domain/models/customer_form_data.dart';
import 'package:fieldproof_360/features/customers/domain/services/customer_validator.dart';
import 'package:flutter/material.dart';

class CustomerForm extends StatefulWidget {
  const CustomerForm({
    required this.initialData,
    required this.submitLabel,
    required this.isSubmitting,
    required this.onSubmit,
    this.error,
    super.key,
  });

  final CustomerFormData initialData;
  final String submitLabel;
  final bool isSubmitting;
  final Object? error;
  final Future<void> Function(CustomerFormData data) onSubmit;

  @override
  State<CustomerForm> createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  late final TextEditingController _name;
  late final TextEditingController _companyName;
  late final TextEditingController _phone;
  late final TextEditingController _email;
  late final TextEditingController _address;
  late final TextEditingController _notes;
  Map<String, String> _errors = const {};

  @override
  void initState() {
    super.initState();
    final data = widget.initialData;
    _name = TextEditingController(text: data.name);
    _companyName = TextEditingController(text: data.companyName);
    _phone = TextEditingController(text: data.phone);
    _email = TextEditingController(text: data.email);
    _address = TextEditingController(text: data.address);
    _notes = TextEditingController(text: data.notes);
  }

  @override
  void dispose() {
    _name.dispose();
    _companyName.dispose();
    _phone.dispose();
    _email.dispose();
    _address.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final errorMessage = switch (widget.error) {
      AppException(:final message) => message,
      != null => 'Could not save the customer. Please try again.',
      _ => null,
    };

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  key: const Key('customerNameField'),
                  controller: _name,
                  autofocus: widget.initialData.name.isEmpty,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  enabled: !widget.isSubmitting,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    errorText: _errors['name'],
                  ),
                ),
                const SizedBox(height: AppSpacing.medium),
                TextField(
                  key: const Key('customerCompanyField'),
                  controller: _companyName,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  enabled: !widget.isSubmitting,
                  decoration: const InputDecoration(labelText: 'Company name'),
                ),
                const SizedBox(height: AppSpacing.medium),
                TextField(
                  key: const Key('customerPhoneField'),
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  enabled: !widget.isSubmitting,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
                const SizedBox(height: AppSpacing.medium),
                TextField(
                  key: const Key('customerEmailField'),
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  enabled: !widget.isSubmitting,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: _errors['email'],
                  ),
                ),
                const SizedBox(height: AppSpacing.medium),
                TextField(
                  key: const Key('customerAddressField'),
                  controller: _address,
                  keyboardType: TextInputType.streetAddress,
                  textCapitalization: TextCapitalization.sentences,
                  minLines: 2,
                  maxLines: 3,
                  enabled: !widget.isSubmitting,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                const SizedBox(height: AppSpacing.medium),
                TextField(
                  key: const Key('customerNotesField'),
                  controller: _notes,
                  textCapitalization: TextCapitalization.sentences,
                  minLines: 3,
                  maxLines: 5,
                  enabled: !widget.isSubmitting,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),
                if (errorMessage != null) ...[
                  const SizedBox(height: AppSpacing.medium),
                  Text(
                    errorMessage,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.large),
                FilledButton(
                  key: const Key('customerSubmit'),
                  onPressed: widget.isSubmitting ? null : _submit,
                  child: widget.isSubmitting
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(widget.submitLabel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  CustomerFormData _data() => CustomerFormData(
    name: _name.text,
    companyName: _companyName.text,
    phone: _phone.text,
    email: _email.text,
    address: _address.text,
    notes: _notes.text,
  );

  Future<void> _submit() async {
    final data = _data();
    final errors = CustomerValidator.validate(data);
    setState(() => _errors = errors);
    if (errors.isEmpty) {
      await widget.onSubmit(data);
    }
  }
}
