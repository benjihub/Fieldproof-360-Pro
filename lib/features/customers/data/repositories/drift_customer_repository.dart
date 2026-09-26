import 'package:drift/drift.dart';
import 'package:fieldproof_360/core/errors/app_exception.dart';
import 'package:fieldproof_360/data/database/app_database.dart';
import 'package:fieldproof_360/data/database/tables/customers.dart';
import 'package:fieldproof_360/features/customers/data/mappers/customer_mapper.dart';
import 'package:fieldproof_360/features/customers/domain/models/customer.dart';
import 'package:fieldproof_360/features/customers/domain/models/customer_form_data.dart';
import 'package:fieldproof_360/features/customers/domain/repositories/customer_repository.dart';
import 'package:fieldproof_360/features/customers/domain/services/customer_validator.dart';
import 'package:uuid/uuid.dart';

final class DriftCustomerRepository implements CustomerRepository {
  DriftCustomerRepository(this._database, [this._uuid = const Uuid()]);

  final AppDatabase _database;
  final Uuid _uuid;

  @override
  Stream<List<Customer>> watchCustomers({String search = ''}) =>
      _activeQuery(search).watch().map(
        (entities) => entities.map((entity) => entity.toDomain()).toList(),
      );

  @override
  Stream<Customer?> watchCustomer(String id) {
    final query = _database.select(_database.customers)
      ..where((customer) => customer.id.equals(id));
    return query.watchSingleOrNull().map((entity) => entity?.toDomain());
  }

  @override
  Future<List<Customer>> getCustomers({String search = ''}) async {
    try {
      final entities = await _activeQuery(search).get();
      return entities.map((entity) => entity.toDomain()).toList();
    } catch (error) {
      throw DatabaseException('Could not load customers.', cause: error);
    }
  }

  @override
  Future<Customer?> getCustomer(String id) async {
    try {
      final query = _database.select(_database.customers)
        ..where((customer) => customer.id.equals(id));
      return (await query.getSingleOrNull())?.toDomain();
    } catch (error) {
      throw DatabaseException('Could not load the customer.', cause: error);
    }
  }

  @override
  Future<Customer> createCustomer(CustomerFormData input) async {
    final normalized = _validate(input);
    final now = _nowUtc();
    final customer = Customer(
      id: _uuid.v4(),
      name: normalized.name,
      companyName: CustomerValidator.optional(normalized.companyName),
      phone: CustomerValidator.optional(normalized.phone),
      email: CustomerValidator.optional(normalized.email),
      address: CustomerValidator.optional(normalized.address),
      notes: CustomerValidator.optional(normalized.notes),
      createdAt: now,
      updatedAt: now,
    );

    try {
      await _database.into(_database.customers).insert(customer.toCompanion());
      return customer;
    } catch (error) {
      throw DatabaseException('Could not save the customer.', cause: error);
    }
  }

  @override
  Future<Customer> updateCustomer(String id, CustomerFormData input) async {
    final normalized = _validate(input);
    final existing = await getCustomer(id);
    if (existing == null) {
      throw const DatabaseException('Customer not found.');
    }

    final updated = Customer(
      id: existing.id,
      name: normalized.name,
      companyName: CustomerValidator.optional(normalized.companyName),
      phone: CustomerValidator.optional(normalized.phone),
      email: CustomerValidator.optional(normalized.email),
      address: CustomerValidator.optional(normalized.address),
      notes: CustomerValidator.optional(normalized.notes),
      createdAt: existing.createdAt,
      updatedAt: _nowUtc(),
      archivedAt: existing.archivedAt,
    );

    try {
      await (_database.update(_database.customers)
            ..where((customer) => customer.id.equals(id)))
          .write(updated.toCompanion());
      return updated;
    } catch (error) {
      throw DatabaseException('Could not update the customer.', cause: error);
    }
  }

  @override
  Future<void> archiveCustomer(String id) => _setArchived(
    id,
    archivedAt: _nowUtc(),
    failureMessage: 'Could not archive the customer.',
  );

  @override
  Future<void> restoreCustomer(String id) => _setArchived(
    id,
    archivedAt: null,
    failureMessage: 'Could not restore the customer.',
  );

  SimpleSelectStatement<Customers, CustomerEntity> _activeQuery(String search) {
    final query = _database.select(_database.customers)
      ..where((customer) {
        Expression<bool> predicate = customer.archivedAt.isNull();
        final term = search.trim();
        if (term.isNotEmpty) {
          predicate =
              predicate &
              (customer.name.contains(term) |
                  customer.companyName.contains(term) |
                  customer.phone.contains(term));
        }
        return predicate;
      })
      ..orderBy([
        (customer) => OrderingTerm.asc(customer.name.collate(Collate.noCase)),
      ]);
    return query;
  }

  CustomerFormData _validate(CustomerFormData input) {
    final errors = CustomerValidator.validate(input);
    if (errors.isNotEmpty) {
      throw const ValidationException('Check the highlighted fields.');
    }
    return CustomerValidator.normalize(input);
  }

  Future<void> _setArchived(
    String id, {
    required DateTime? archivedAt,
    required String failureMessage,
  }) async {
    try {
      final changed =
          await (_database.update(
            _database.customers,
          )..where((customer) => customer.id.equals(id))).write(
            CustomersCompanion(
              archivedAt: Value(archivedAt),
              updatedAt: Value(_nowUtc()),
            ),
          );
      if (changed == 0) {
        throw const DatabaseException('Customer not found.');
      }
    } on AppException {
      rethrow;
    } catch (error) {
      throw DatabaseException(failureMessage, cause: error);
    }
  }

  DateTime _nowUtc() {
    final now = DateTime.now().toUtc();
    return DateTime.fromMillisecondsSinceEpoch(
      (now.millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond) *
          Duration.millisecondsPerSecond,
      isUtc: true,
    );
  }
}
