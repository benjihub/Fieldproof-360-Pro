import 'package:drift/drift.dart';
import 'package:fieldproof_360/data/database/app_database.dart';
import 'package:fieldproof_360/features/customers/domain/models/customer.dart';

extension CustomerEntityMapper on CustomerEntity {
  Customer toDomain() => Customer(
    id: id,
    name: name,
    companyName: companyName,
    phone: phone,
    email: email,
    address: address,
    notes: notes,
    createdAt: createdAt.toUtc(),
    updatedAt: updatedAt.toUtc(),
    archivedAt: archivedAt?.toUtc(),
  );
}

extension CustomerDomainMapper on Customer {
  CustomersCompanion toCompanion() => CustomersCompanion(
    id: Value(id),
    name: Value(name),
    companyName: Value(companyName),
    phone: Value(phone),
    email: Value(email),
    address: Value(address),
    notes: Value(notes),
    createdAt: Value(createdAt.toUtc()),
    updatedAt: Value(updatedAt.toUtc()),
    archivedAt: Value(archivedAt?.toUtc()),
  );
}
