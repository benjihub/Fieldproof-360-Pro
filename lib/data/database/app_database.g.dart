// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DatabaseMetadataTable extends DatabaseMetadata
    with TableInfo<$DatabaseMetadataTable, DatabaseMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DatabaseMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'database_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<DatabaseMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  DatabaseMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DatabaseMetadataData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DatabaseMetadataTable createAlias(String alias) {
    return $DatabaseMetadataTable(attachedDatabase, alias);
  }
}

class DatabaseMetadataData extends DataClass
    implements Insertable<DatabaseMetadataData> {
  final String key;
  final String? value;
  final DateTime updatedAt;
  const DatabaseMetadataData({
    required this.key,
    this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DatabaseMetadataCompanion toCompanion(bool nullToAbsent) {
    return DatabaseMetadataCompanion(
      key: Value(key),
      value: value == null && nullToAbsent
          ? const Value.absent()
          : Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory DatabaseMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DatabaseMetadataData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String?>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String?>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DatabaseMetadataData copyWith({
    String? key,
    Value<String?> value = const Value.absent(),
    DateTime? updatedAt,
  }) => DatabaseMetadataData(
    key: key ?? this.key,
    value: value.present ? value.value : this.value,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DatabaseMetadataData copyWithCompanion(DatabaseMetadataCompanion data) {
    return DatabaseMetadataData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DatabaseMetadataData(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DatabaseMetadataData &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class DatabaseMetadataCompanion extends UpdateCompanion<DatabaseMetadataData> {
  final Value<String> key;
  final Value<String?> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DatabaseMetadataCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DatabaseMetadataCompanion.insert({
    required String key,
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key);
  static Insertable<DatabaseMetadataData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DatabaseMetadataCompanion copyWith({
    Value<String>? key,
    Value<String?>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DatabaseMetadataCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DatabaseMetadataCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BusinessProfilesTable extends BusinessProfiles
    with TableInfo<$BusinessProfilesTable, BusinessProfileEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BusinessProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _businessNameMeta = const VerificationMeta(
    'businessName',
  );
  @override
  late final GeneratedColumn<String> businessName = GeneratedColumn<String>(
    'business_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _technicianNameMeta = const VerificationMeta(
    'technicianName',
  );
  @override
  late final GeneratedColumn<String> technicianName = GeneratedColumn<String>(
    'technician_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _countryCodeMeta = const VerificationMeta(
    'countryCode',
  );
  @override
  late final GeneratedColumn<String> countryCode = GeneratedColumn<String>(
    'country_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localeCodeMeta = const VerificationMeta(
    'localeCode',
  );
  @override
  late final GeneratedColumn<String> localeCode = GeneratedColumn<String>(
    'locale_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _logoPathMeta = const VerificationMeta(
    'logoPath',
  );
  @override
  late final GeneratedColumn<String> logoPath = GeneratedColumn<String>(
    'logo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taxLabelMeta = const VerificationMeta(
    'taxLabel',
  );
  @override
  late final GeneratedColumn<String> taxLabel = GeneratedColumn<String>(
    'tax_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taxNumberMeta = const VerificationMeta(
    'taxNumber',
  );
  @override
  late final GeneratedColumn<String> taxNumber = GeneratedColumn<String>(
    'tax_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reportPrefixMeta = const VerificationMeta(
    'reportPrefix',
  );
  @override
  late final GeneratedColumn<String> reportPrefix = GeneratedColumn<String>(
    'report_prefix',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('FP'),
  );
  static const VerificationMeta _defaultTermsMeta = const VerificationMeta(
    'defaultTerms',
  );
  @override
  late final GeneratedColumn<String> defaultTerms = GeneratedColumn<String>(
    'default_terms',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    businessName,
    technicianName,
    email,
    phone,
    address,
    countryCode,
    currencyCode,
    localeCode,
    logoPath,
    taxLabel,
    taxNumber,
    reportPrefix,
    defaultTerms,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'business_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<BusinessProfileEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('business_name')) {
      context.handle(
        _businessNameMeta,
        businessName.isAcceptableOrUnknown(
          data['business_name']!,
          _businessNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_businessNameMeta);
    }
    if (data.containsKey('technician_name')) {
      context.handle(
        _technicianNameMeta,
        technicianName.isAcceptableOrUnknown(
          data['technician_name']!,
          _technicianNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_technicianNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('country_code')) {
      context.handle(
        _countryCodeMeta,
        countryCode.isAcceptableOrUnknown(
          data['country_code']!,
          _countryCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_countryCodeMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('locale_code')) {
      context.handle(
        _localeCodeMeta,
        localeCode.isAcceptableOrUnknown(data['locale_code']!, _localeCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_localeCodeMeta);
    }
    if (data.containsKey('logo_path')) {
      context.handle(
        _logoPathMeta,
        logoPath.isAcceptableOrUnknown(data['logo_path']!, _logoPathMeta),
      );
    }
    if (data.containsKey('tax_label')) {
      context.handle(
        _taxLabelMeta,
        taxLabel.isAcceptableOrUnknown(data['tax_label']!, _taxLabelMeta),
      );
    }
    if (data.containsKey('tax_number')) {
      context.handle(
        _taxNumberMeta,
        taxNumber.isAcceptableOrUnknown(data['tax_number']!, _taxNumberMeta),
      );
    }
    if (data.containsKey('report_prefix')) {
      context.handle(
        _reportPrefixMeta,
        reportPrefix.isAcceptableOrUnknown(
          data['report_prefix']!,
          _reportPrefixMeta,
        ),
      );
    }
    if (data.containsKey('default_terms')) {
      context.handle(
        _defaultTermsMeta,
        defaultTerms.isAcceptableOrUnknown(
          data['default_terms']!,
          _defaultTermsMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BusinessProfileEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BusinessProfileEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      businessName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_name'],
      )!,
      technicianName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}technician_name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      countryCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country_code'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      localeCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale_code'],
      )!,
      logoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_path'],
      ),
      taxLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tax_label'],
      ),
      taxNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tax_number'],
      ),
      reportPrefix: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}report_prefix'],
      )!,
      defaultTerms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_terms'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BusinessProfilesTable createAlias(String alias) {
    return $BusinessProfilesTable(attachedDatabase, alias);
  }
}

class BusinessProfileEntity extends DataClass
    implements Insertable<BusinessProfileEntity> {
  final String id;
  final String businessName;
  final String technicianName;
  final String? email;
  final String? phone;
  final String? address;
  final String countryCode;
  final String currencyCode;
  final String localeCode;
  final String? logoPath;
  final String? taxLabel;
  final String? taxNumber;
  final String reportPrefix;
  final String? defaultTerms;
  final DateTime createdAt;
  final DateTime updatedAt;
  const BusinessProfileEntity({
    required this.id,
    required this.businessName,
    required this.technicianName,
    this.email,
    this.phone,
    this.address,
    required this.countryCode,
    required this.currencyCode,
    required this.localeCode,
    this.logoPath,
    this.taxLabel,
    this.taxNumber,
    required this.reportPrefix,
    this.defaultTerms,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['business_name'] = Variable<String>(businessName);
    map['technician_name'] = Variable<String>(technicianName);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['country_code'] = Variable<String>(countryCode);
    map['currency_code'] = Variable<String>(currencyCode);
    map['locale_code'] = Variable<String>(localeCode);
    if (!nullToAbsent || logoPath != null) {
      map['logo_path'] = Variable<String>(logoPath);
    }
    if (!nullToAbsent || taxLabel != null) {
      map['tax_label'] = Variable<String>(taxLabel);
    }
    if (!nullToAbsent || taxNumber != null) {
      map['tax_number'] = Variable<String>(taxNumber);
    }
    map['report_prefix'] = Variable<String>(reportPrefix);
    if (!nullToAbsent || defaultTerms != null) {
      map['default_terms'] = Variable<String>(defaultTerms);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BusinessProfilesCompanion toCompanion(bool nullToAbsent) {
    return BusinessProfilesCompanion(
      id: Value(id),
      businessName: Value(businessName),
      technicianName: Value(technicianName),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      countryCode: Value(countryCode),
      currencyCode: Value(currencyCode),
      localeCode: Value(localeCode),
      logoPath: logoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(logoPath),
      taxLabel: taxLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(taxLabel),
      taxNumber: taxNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(taxNumber),
      reportPrefix: Value(reportPrefix),
      defaultTerms: defaultTerms == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultTerms),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BusinessProfileEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BusinessProfileEntity(
      id: serializer.fromJson<String>(json['id']),
      businessName: serializer.fromJson<String>(json['businessName']),
      technicianName: serializer.fromJson<String>(json['technicianName']),
      email: serializer.fromJson<String?>(json['email']),
      phone: serializer.fromJson<String?>(json['phone']),
      address: serializer.fromJson<String?>(json['address']),
      countryCode: serializer.fromJson<String>(json['countryCode']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      localeCode: serializer.fromJson<String>(json['localeCode']),
      logoPath: serializer.fromJson<String?>(json['logoPath']),
      taxLabel: serializer.fromJson<String?>(json['taxLabel']),
      taxNumber: serializer.fromJson<String?>(json['taxNumber']),
      reportPrefix: serializer.fromJson<String>(json['reportPrefix']),
      defaultTerms: serializer.fromJson<String?>(json['defaultTerms']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'businessName': serializer.toJson<String>(businessName),
      'technicianName': serializer.toJson<String>(technicianName),
      'email': serializer.toJson<String?>(email),
      'phone': serializer.toJson<String?>(phone),
      'address': serializer.toJson<String?>(address),
      'countryCode': serializer.toJson<String>(countryCode),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'localeCode': serializer.toJson<String>(localeCode),
      'logoPath': serializer.toJson<String?>(logoPath),
      'taxLabel': serializer.toJson<String?>(taxLabel),
      'taxNumber': serializer.toJson<String?>(taxNumber),
      'reportPrefix': serializer.toJson<String>(reportPrefix),
      'defaultTerms': serializer.toJson<String?>(defaultTerms),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BusinessProfileEntity copyWith({
    String? id,
    String? businessName,
    String? technicianName,
    Value<String?> email = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> address = const Value.absent(),
    String? countryCode,
    String? currencyCode,
    String? localeCode,
    Value<String?> logoPath = const Value.absent(),
    Value<String?> taxLabel = const Value.absent(),
    Value<String?> taxNumber = const Value.absent(),
    String? reportPrefix,
    Value<String?> defaultTerms = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => BusinessProfileEntity(
    id: id ?? this.id,
    businessName: businessName ?? this.businessName,
    technicianName: technicianName ?? this.technicianName,
    email: email.present ? email.value : this.email,
    phone: phone.present ? phone.value : this.phone,
    address: address.present ? address.value : this.address,
    countryCode: countryCode ?? this.countryCode,
    currencyCode: currencyCode ?? this.currencyCode,
    localeCode: localeCode ?? this.localeCode,
    logoPath: logoPath.present ? logoPath.value : this.logoPath,
    taxLabel: taxLabel.present ? taxLabel.value : this.taxLabel,
    taxNumber: taxNumber.present ? taxNumber.value : this.taxNumber,
    reportPrefix: reportPrefix ?? this.reportPrefix,
    defaultTerms: defaultTerms.present ? defaultTerms.value : this.defaultTerms,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BusinessProfileEntity copyWithCompanion(BusinessProfilesCompanion data) {
    return BusinessProfileEntity(
      id: data.id.present ? data.id.value : this.id,
      businessName: data.businessName.present
          ? data.businessName.value
          : this.businessName,
      technicianName: data.technicianName.present
          ? data.technicianName.value
          : this.technicianName,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      countryCode: data.countryCode.present
          ? data.countryCode.value
          : this.countryCode,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      localeCode: data.localeCode.present
          ? data.localeCode.value
          : this.localeCode,
      logoPath: data.logoPath.present ? data.logoPath.value : this.logoPath,
      taxLabel: data.taxLabel.present ? data.taxLabel.value : this.taxLabel,
      taxNumber: data.taxNumber.present ? data.taxNumber.value : this.taxNumber,
      reportPrefix: data.reportPrefix.present
          ? data.reportPrefix.value
          : this.reportPrefix,
      defaultTerms: data.defaultTerms.present
          ? data.defaultTerms.value
          : this.defaultTerms,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BusinessProfileEntity(')
          ..write('id: $id, ')
          ..write('businessName: $businessName, ')
          ..write('technicianName: $technicianName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('countryCode: $countryCode, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('localeCode: $localeCode, ')
          ..write('logoPath: $logoPath, ')
          ..write('taxLabel: $taxLabel, ')
          ..write('taxNumber: $taxNumber, ')
          ..write('reportPrefix: $reportPrefix, ')
          ..write('defaultTerms: $defaultTerms, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    businessName,
    technicianName,
    email,
    phone,
    address,
    countryCode,
    currencyCode,
    localeCode,
    logoPath,
    taxLabel,
    taxNumber,
    reportPrefix,
    defaultTerms,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BusinessProfileEntity &&
          other.id == this.id &&
          other.businessName == this.businessName &&
          other.technicianName == this.technicianName &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.countryCode == this.countryCode &&
          other.currencyCode == this.currencyCode &&
          other.localeCode == this.localeCode &&
          other.logoPath == this.logoPath &&
          other.taxLabel == this.taxLabel &&
          other.taxNumber == this.taxNumber &&
          other.reportPrefix == this.reportPrefix &&
          other.defaultTerms == this.defaultTerms &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BusinessProfilesCompanion extends UpdateCompanion<BusinessProfileEntity> {
  final Value<String> id;
  final Value<String> businessName;
  final Value<String> technicianName;
  final Value<String?> email;
  final Value<String?> phone;
  final Value<String?> address;
  final Value<String> countryCode;
  final Value<String> currencyCode;
  final Value<String> localeCode;
  final Value<String?> logoPath;
  final Value<String?> taxLabel;
  final Value<String?> taxNumber;
  final Value<String> reportPrefix;
  final Value<String?> defaultTerms;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BusinessProfilesCompanion({
    this.id = const Value.absent(),
    this.businessName = const Value.absent(),
    this.technicianName = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.countryCode = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.localeCode = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.taxLabel = const Value.absent(),
    this.taxNumber = const Value.absent(),
    this.reportPrefix = const Value.absent(),
    this.defaultTerms = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BusinessProfilesCompanion.insert({
    required String id,
    required String businessName,
    required String technicianName,
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    required String countryCode,
    required String currencyCode,
    required String localeCode,
    this.logoPath = const Value.absent(),
    this.taxLabel = const Value.absent(),
    this.taxNumber = const Value.absent(),
    this.reportPrefix = const Value.absent(),
    this.defaultTerms = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       businessName = Value(businessName),
       technicianName = Value(technicianName),
       countryCode = Value(countryCode),
       currencyCode = Value(currencyCode),
       localeCode = Value(localeCode),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<BusinessProfileEntity> custom({
    Expression<String>? id,
    Expression<String>? businessName,
    Expression<String>? technicianName,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<String>? countryCode,
    Expression<String>? currencyCode,
    Expression<String>? localeCode,
    Expression<String>? logoPath,
    Expression<String>? taxLabel,
    Expression<String>? taxNumber,
    Expression<String>? reportPrefix,
    Expression<String>? defaultTerms,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (businessName != null) 'business_name': businessName,
      if (technicianName != null) 'technician_name': technicianName,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (countryCode != null) 'country_code': countryCode,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (localeCode != null) 'locale_code': localeCode,
      if (logoPath != null) 'logo_path': logoPath,
      if (taxLabel != null) 'tax_label': taxLabel,
      if (taxNumber != null) 'tax_number': taxNumber,
      if (reportPrefix != null) 'report_prefix': reportPrefix,
      if (defaultTerms != null) 'default_terms': defaultTerms,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BusinessProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? businessName,
    Value<String>? technicianName,
    Value<String?>? email,
    Value<String?>? phone,
    Value<String?>? address,
    Value<String>? countryCode,
    Value<String>? currencyCode,
    Value<String>? localeCode,
    Value<String?>? logoPath,
    Value<String?>? taxLabel,
    Value<String?>? taxNumber,
    Value<String>? reportPrefix,
    Value<String?>? defaultTerms,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return BusinessProfilesCompanion(
      id: id ?? this.id,
      businessName: businessName ?? this.businessName,
      technicianName: technicianName ?? this.technicianName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      countryCode: countryCode ?? this.countryCode,
      currencyCode: currencyCode ?? this.currencyCode,
      localeCode: localeCode ?? this.localeCode,
      logoPath: logoPath ?? this.logoPath,
      taxLabel: taxLabel ?? this.taxLabel,
      taxNumber: taxNumber ?? this.taxNumber,
      reportPrefix: reportPrefix ?? this.reportPrefix,
      defaultTerms: defaultTerms ?? this.defaultTerms,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (businessName.present) {
      map['business_name'] = Variable<String>(businessName.value);
    }
    if (technicianName.present) {
      map['technician_name'] = Variable<String>(technicianName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (countryCode.present) {
      map['country_code'] = Variable<String>(countryCode.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (localeCode.present) {
      map['locale_code'] = Variable<String>(localeCode.value);
    }
    if (logoPath.present) {
      map['logo_path'] = Variable<String>(logoPath.value);
    }
    if (taxLabel.present) {
      map['tax_label'] = Variable<String>(taxLabel.value);
    }
    if (taxNumber.present) {
      map['tax_number'] = Variable<String>(taxNumber.value);
    }
    if (reportPrefix.present) {
      map['report_prefix'] = Variable<String>(reportPrefix.value);
    }
    if (defaultTerms.present) {
      map['default_terms'] = Variable<String>(defaultTerms.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BusinessProfilesCompanion(')
          ..write('id: $id, ')
          ..write('businessName: $businessName, ')
          ..write('technicianName: $technicianName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('countryCode: $countryCode, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('localeCode: $localeCode, ')
          ..write('logoPath: $logoPath, ')
          ..write('taxLabel: $taxLabel, ')
          ..write('taxNumber: $taxNumber, ')
          ..write('reportPrefix: $reportPrefix, ')
          ..write('defaultTerms: $defaultTerms, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsEntriesTable extends AppSettingsEntries
    with TableInfo<$AppSettingsEntriesTable, AppSettingsEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _defaultReportTypeMeta = const VerificationMeta(
    'defaultReportType',
  );
  @override
  late final GeneratedColumn<String> defaultReportType =
      GeneratedColumn<String>(
        'default_report_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('service'),
      );
  static const VerificationMeta _defaultPdfTemplateMeta =
      const VerificationMeta('defaultPdfTemplate');
  @override
  late final GeneratedColumn<String> defaultPdfTemplate =
      GeneratedColumn<String>(
        'default_pdf_template',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('classic'),
      );
  static const VerificationMeta _hasCompletedOnboardingMeta =
      const VerificationMeta('hasCompletedOnboarding');
  @override
  late final GeneratedColumn<bool> hasCompletedOnboarding =
      GeneratedColumn<bool>(
        'has_completed_onboarding',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_completed_onboarding" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    themeMode,
    defaultReportType,
    defaultPdfTemplate,
    hasCompletedOnboarding,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingsEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    if (data.containsKey('default_report_type')) {
      context.handle(
        _defaultReportTypeMeta,
        defaultReportType.isAcceptableOrUnknown(
          data['default_report_type']!,
          _defaultReportTypeMeta,
        ),
      );
    }
    if (data.containsKey('default_pdf_template')) {
      context.handle(
        _defaultPdfTemplateMeta,
        defaultPdfTemplate.isAcceptableOrUnknown(
          data['default_pdf_template']!,
          _defaultPdfTemplateMeta,
        ),
      );
    }
    if (data.containsKey('has_completed_onboarding')) {
      context.handle(
        _hasCompletedOnboardingMeta,
        hasCompletedOnboarding.isAcceptableOrUnknown(
          data['has_completed_onboarding']!,
          _hasCompletedOnboardingMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSettingsEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingsEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
      defaultReportType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_report_type'],
      )!,
      defaultPdfTemplate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_pdf_template'],
      )!,
      hasCompletedOnboarding: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_completed_onboarding'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppSettingsEntriesTable createAlias(String alias) {
    return $AppSettingsEntriesTable(attachedDatabase, alias);
  }
}

class AppSettingsEntity extends DataClass
    implements Insertable<AppSettingsEntity> {
  final String id;
  final String themeMode;
  final String defaultReportType;
  final String defaultPdfTemplate;
  final bool hasCompletedOnboarding;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AppSettingsEntity({
    required this.id,
    required this.themeMode,
    required this.defaultReportType,
    required this.defaultPdfTemplate,
    required this.hasCompletedOnboarding,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['theme_mode'] = Variable<String>(themeMode);
    map['default_report_type'] = Variable<String>(defaultReportType);
    map['default_pdf_template'] = Variable<String>(defaultPdfTemplate);
    map['has_completed_onboarding'] = Variable<bool>(hasCompletedOnboarding);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppSettingsEntriesCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsEntriesCompanion(
      id: Value(id),
      themeMode: Value(themeMode),
      defaultReportType: Value(defaultReportType),
      defaultPdfTemplate: Value(defaultPdfTemplate),
      hasCompletedOnboarding: Value(hasCompletedOnboarding),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSettingsEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingsEntity(
      id: serializer.fromJson<String>(json['id']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      defaultReportType: serializer.fromJson<String>(json['defaultReportType']),
      defaultPdfTemplate: serializer.fromJson<String>(
        json['defaultPdfTemplate'],
      ),
      hasCompletedOnboarding: serializer.fromJson<bool>(
        json['hasCompletedOnboarding'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'themeMode': serializer.toJson<String>(themeMode),
      'defaultReportType': serializer.toJson<String>(defaultReportType),
      'defaultPdfTemplate': serializer.toJson<String>(defaultPdfTemplate),
      'hasCompletedOnboarding': serializer.toJson<bool>(hasCompletedOnboarding),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppSettingsEntity copyWith({
    String? id,
    String? themeMode,
    String? defaultReportType,
    String? defaultPdfTemplate,
    bool? hasCompletedOnboarding,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AppSettingsEntity(
    id: id ?? this.id,
    themeMode: themeMode ?? this.themeMode,
    defaultReportType: defaultReportType ?? this.defaultReportType,
    defaultPdfTemplate: defaultPdfTemplate ?? this.defaultPdfTemplate,
    hasCompletedOnboarding:
        hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AppSettingsEntity copyWithCompanion(AppSettingsEntriesCompanion data) {
    return AppSettingsEntity(
      id: data.id.present ? data.id.value : this.id,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      defaultReportType: data.defaultReportType.present
          ? data.defaultReportType.value
          : this.defaultReportType,
      defaultPdfTemplate: data.defaultPdfTemplate.present
          ? data.defaultPdfTemplate.value
          : this.defaultPdfTemplate,
      hasCompletedOnboarding: data.hasCompletedOnboarding.present
          ? data.hasCompletedOnboarding.value
          : this.hasCompletedOnboarding,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsEntity(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('defaultReportType: $defaultReportType, ')
          ..write('defaultPdfTemplate: $defaultPdfTemplate, ')
          ..write('hasCompletedOnboarding: $hasCompletedOnboarding, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    themeMode,
    defaultReportType,
    defaultPdfTemplate,
    hasCompletedOnboarding,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingsEntity &&
          other.id == this.id &&
          other.themeMode == this.themeMode &&
          other.defaultReportType == this.defaultReportType &&
          other.defaultPdfTemplate == this.defaultPdfTemplate &&
          other.hasCompletedOnboarding == this.hasCompletedOnboarding &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsEntriesCompanion extends UpdateCompanion<AppSettingsEntity> {
  final Value<String> id;
  final Value<String> themeMode;
  final Value<String> defaultReportType;
  final Value<String> defaultPdfTemplate;
  final Value<bool> hasCompletedOnboarding;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AppSettingsEntriesCompanion({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.defaultReportType = const Value.absent(),
    this.defaultPdfTemplate = const Value.absent(),
    this.hasCompletedOnboarding = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsEntriesCompanion.insert({
    required String id,
    this.themeMode = const Value.absent(),
    this.defaultReportType = const Value.absent(),
    this.defaultPdfTemplate = const Value.absent(),
    this.hasCompletedOnboarding = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<AppSettingsEntity> custom({
    Expression<String>? id,
    Expression<String>? themeMode,
    Expression<String>? defaultReportType,
    Expression<String>? defaultPdfTemplate,
    Expression<bool>? hasCompletedOnboarding,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (themeMode != null) 'theme_mode': themeMode,
      if (defaultReportType != null) 'default_report_type': defaultReportType,
      if (defaultPdfTemplate != null)
        'default_pdf_template': defaultPdfTemplate,
      if (hasCompletedOnboarding != null)
        'has_completed_onboarding': hasCompletedOnboarding,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? themeMode,
    Value<String>? defaultReportType,
    Value<String>? defaultPdfTemplate,
    Value<bool>? hasCompletedOnboarding,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppSettingsEntriesCompanion(
      id: id ?? this.id,
      themeMode: themeMode ?? this.themeMode,
      defaultReportType: defaultReportType ?? this.defaultReportType,
      defaultPdfTemplate: defaultPdfTemplate ?? this.defaultPdfTemplate,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (defaultReportType.present) {
      map['default_report_type'] = Variable<String>(defaultReportType.value);
    }
    if (defaultPdfTemplate.present) {
      map['default_pdf_template'] = Variable<String>(defaultPdfTemplate.value);
    }
    if (hasCompletedOnboarding.present) {
      map['has_completed_onboarding'] = Variable<bool>(
        hasCompletedOnboarding.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsEntriesCompanion(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('defaultReportType: $defaultReportType, ')
          ..write('defaultPdfTemplate: $defaultPdfTemplate, ')
          ..write('hasCompletedOnboarding: $hasCompletedOnboarding, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, CustomerEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _companyNameMeta = const VerificationMeta(
    'companyName',
  );
  @override
  late final GeneratedColumn<String> companyName = GeneratedColumn<String>(
    'company_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    companyName,
    phone,
    email,
    address,
    notes,
    createdAt,
    updatedAt,
    archivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomerEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('company_name')) {
      context.handle(
        _companyNameMeta,
        companyName.isAcceptableOrUnknown(
          data['company_name']!,
          _companyNameMeta,
        ),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomerEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomerEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      companyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_name'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class CustomerEntity extends DataClass implements Insertable<CustomerEntity> {
  final String id;
  final String name;
  final String? companyName;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;
  const CustomerEntity({
    required this.id,
    required this.name,
    this.companyName,
    this.phone,
    this.email,
    this.address,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.archivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || companyName != null) {
      map['company_name'] = Variable<String>(companyName);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      name: Value(name),
      companyName: companyName == null && nullToAbsent
          ? const Value.absent()
          : Value(companyName),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
    );
  }

  factory CustomerEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomerEntity(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      companyName: serializer.fromJson<String?>(json['companyName']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      address: serializer.fromJson<String?>(json['address']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'companyName': serializer.toJson<String?>(companyName),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'address': serializer.toJson<String?>(address),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  CustomerEntity copyWith({
    String? id,
    String? name,
    Value<String?> companyName = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> archivedAt = const Value.absent(),
  }) => CustomerEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    companyName: companyName.present ? companyName.value : this.companyName,
    phone: phone.present ? phone.value : this.phone,
    email: email.present ? email.value : this.email,
    address: address.present ? address.value : this.address,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
  );
  CustomerEntity copyWithCompanion(CustomersCompanion data) {
    return CustomerEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      companyName: data.companyName.present
          ? data.companyName.value
          : this.companyName,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomerEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('companyName: $companyName, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    companyName,
    phone,
    email,
    address,
    notes,
    createdAt,
    updatedAt,
    archivedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomerEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.companyName == this.companyName &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.address == this.address &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.archivedAt == this.archivedAt);
}

class CustomersCompanion extends UpdateCompanion<CustomerEntity> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> companyName;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> address;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> archivedAt;
  final Value<int> rowid;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.companyName = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomersCompanion.insert({
    required String id,
    required String name,
    this.companyName = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CustomerEntity> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? companyName,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? address,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (companyName != null) 'company_name': companyName,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? companyName,
    Value<String?>? phone,
    Value<String?>? email,
    Value<String?>? address,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? archivedAt,
    Value<int>? rowid,
  }) {
    return CustomersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      companyName: companyName ?? this.companyName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (companyName.present) {
      map['company_name'] = Variable<String>(companyName.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('companyName: $companyName, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReportsTable extends Reports
    with TableInfo<$ReportsTable, ReportEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reportNumberMeta = const VerificationMeta(
    'reportNumber',
  );
  @override
  late final GeneratedColumn<String> reportNumber = GeneratedColumn<String>(
    'report_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _reportTypeMeta = const VerificationMeta(
    'reportType',
  );
  @override
  late final GeneratedColumn<String> reportType = GeneratedColumn<String>(
    'report_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('service'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('draft'),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _siteAddressMeta = const VerificationMeta(
    'siteAddress',
  );
  @override
  late final GeneratedColumn<String> siteAddress = GeneratedColumn<String>(
    'site_address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _equipmentNameMeta = const VerificationMeta(
    'equipmentName',
  );
  @override
  late final GeneratedColumn<String> equipmentName = GeneratedColumn<String>(
    'equipment_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _equipmentManufacturerMeta =
      const VerificationMeta('equipmentManufacturer');
  @override
  late final GeneratedColumn<String> equipmentManufacturer =
      GeneratedColumn<String>(
        'equipment_manufacturer',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _equipmentModelMeta = const VerificationMeta(
    'equipmentModel',
  );
  @override
  late final GeneratedColumn<String> equipmentModel = GeneratedColumn<String>(
    'equipment_model',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _equipmentSerialMeta = const VerificationMeta(
    'equipmentSerial',
  );
  @override
  late final GeneratedColumn<String> equipmentSerial = GeneratedColumn<String>(
    'equipment_serial',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _issueReportedMeta = const VerificationMeta(
    'issueReported',
  );
  @override
  late final GeneratedColumn<String> issueReported = GeneratedColumn<String>(
    'issue_reported',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _diagnosisMeta = const VerificationMeta(
    'diagnosis',
  );
  @override
  late final GeneratedColumn<String> diagnosis = GeneratedColumn<String>(
    'diagnosis',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _workPerformedMeta = const VerificationMeta(
    'workPerformed',
  );
  @override
  late final GeneratedColumn<String> workPerformed = GeneratedColumn<String>(
    'work_performed',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _recommendationsMeta = const VerificationMeta(
    'recommendations',
  );
  @override
  late final GeneratedColumn<String> recommendations = GeneratedColumn<String>(
    'recommendations',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _internalNotesMeta = const VerificationMeta(
    'internalNotes',
  );
  @override
  late final GeneratedColumn<String> internalNotes = GeneratedColumn<String>(
    'internal_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _finalizedAtMeta = const VerificationMeta(
    'finalizedAt',
  );
  @override
  late final GeneratedColumn<DateTime> finalizedAt = GeneratedColumn<DateTime>(
    'finalized_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _finalizedSnapshotJsonMeta =
      const VerificationMeta('finalizedSnapshotJson');
  @override
  late final GeneratedColumn<String> finalizedSnapshotJson =
      GeneratedColumn<String>(
        'finalized_snapshot_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _pdfTemplateIdMeta = const VerificationMeta(
    'pdfTemplateId',
  );
  @override
  late final GeneratedColumn<String> pdfTemplateId = GeneratedColumn<String>(
    'pdf_template_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('classic'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    reportNumber,
    customerId,
    reportType,
    status,
    title,
    siteAddress,
    equipmentName,
    equipmentManufacturer,
    equipmentModel,
    equipmentSerial,
    issueReported,
    diagnosis,
    workPerformed,
    recommendations,
    internalNotes,
    startedAt,
    completedAt,
    finalizedAt,
    finalizedSnapshotJson,
    pdfTemplateId,
    createdAt,
    updatedAt,
    archivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reports';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReportEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('report_number')) {
      context.handle(
        _reportNumberMeta,
        reportNumber.isAcceptableOrUnknown(
          data['report_number']!,
          _reportNumberMeta,
        ),
      );
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('report_type')) {
      context.handle(
        _reportTypeMeta,
        reportType.isAcceptableOrUnknown(data['report_type']!, _reportTypeMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('site_address')) {
      context.handle(
        _siteAddressMeta,
        siteAddress.isAcceptableOrUnknown(
          data['site_address']!,
          _siteAddressMeta,
        ),
      );
    }
    if (data.containsKey('equipment_name')) {
      context.handle(
        _equipmentNameMeta,
        equipmentName.isAcceptableOrUnknown(
          data['equipment_name']!,
          _equipmentNameMeta,
        ),
      );
    }
    if (data.containsKey('equipment_manufacturer')) {
      context.handle(
        _equipmentManufacturerMeta,
        equipmentManufacturer.isAcceptableOrUnknown(
          data['equipment_manufacturer']!,
          _equipmentManufacturerMeta,
        ),
      );
    }
    if (data.containsKey('equipment_model')) {
      context.handle(
        _equipmentModelMeta,
        equipmentModel.isAcceptableOrUnknown(
          data['equipment_model']!,
          _equipmentModelMeta,
        ),
      );
    }
    if (data.containsKey('equipment_serial')) {
      context.handle(
        _equipmentSerialMeta,
        equipmentSerial.isAcceptableOrUnknown(
          data['equipment_serial']!,
          _equipmentSerialMeta,
        ),
      );
    }
    if (data.containsKey('issue_reported')) {
      context.handle(
        _issueReportedMeta,
        issueReported.isAcceptableOrUnknown(
          data['issue_reported']!,
          _issueReportedMeta,
        ),
      );
    }
    if (data.containsKey('diagnosis')) {
      context.handle(
        _diagnosisMeta,
        diagnosis.isAcceptableOrUnknown(data['diagnosis']!, _diagnosisMeta),
      );
    }
    if (data.containsKey('work_performed')) {
      context.handle(
        _workPerformedMeta,
        workPerformed.isAcceptableOrUnknown(
          data['work_performed']!,
          _workPerformedMeta,
        ),
      );
    }
    if (data.containsKey('recommendations')) {
      context.handle(
        _recommendationsMeta,
        recommendations.isAcceptableOrUnknown(
          data['recommendations']!,
          _recommendationsMeta,
        ),
      );
    }
    if (data.containsKey('internal_notes')) {
      context.handle(
        _internalNotesMeta,
        internalNotes.isAcceptableOrUnknown(
          data['internal_notes']!,
          _internalNotesMeta,
        ),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('finalized_at')) {
      context.handle(
        _finalizedAtMeta,
        finalizedAt.isAcceptableOrUnknown(
          data['finalized_at']!,
          _finalizedAtMeta,
        ),
      );
    }
    if (data.containsKey('finalized_snapshot_json')) {
      context.handle(
        _finalizedSnapshotJsonMeta,
        finalizedSnapshotJson.isAcceptableOrUnknown(
          data['finalized_snapshot_json']!,
          _finalizedSnapshotJsonMeta,
        ),
      );
    }
    if (data.containsKey('pdf_template_id')) {
      context.handle(
        _pdfTemplateIdMeta,
        pdfTemplateId.isAcceptableOrUnknown(
          data['pdf_template_id']!,
          _pdfTemplateIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReportEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReportEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      reportNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}report_number'],
      ),
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      ),
      reportType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}report_type'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      siteAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}site_address'],
      ),
      equipmentName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipment_name'],
      ),
      equipmentManufacturer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipment_manufacturer'],
      ),
      equipmentModel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipment_model'],
      ),
      equipmentSerial: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipment_serial'],
      ),
      issueReported: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}issue_reported'],
      ),
      diagnosis: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diagnosis'],
      ),
      workPerformed: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_performed'],
      )!,
      recommendations: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recommendations'],
      ),
      internalNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}internal_notes'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      finalizedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finalized_at'],
      ),
      finalizedSnapshotJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}finalized_snapshot_json'],
      ),
      pdfTemplateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pdf_template_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
    );
  }

  @override
  $ReportsTable createAlias(String alias) {
    return $ReportsTable(attachedDatabase, alias);
  }
}

class ReportEntity extends DataClass implements Insertable<ReportEntity> {
  final String id;
  final String? reportNumber;
  final String? customerId;
  final String reportType;
  final String status;
  final String title;
  final String? siteAddress;
  final String? equipmentName;
  final String? equipmentManufacturer;
  final String? equipmentModel;
  final String? equipmentSerial;
  final String? issueReported;
  final String? diagnosis;
  final String workPerformed;
  final String? recommendations;
  final String? internalNotes;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? finalizedAt;
  final String? finalizedSnapshotJson;
  final String pdfTemplateId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;
  const ReportEntity({
    required this.id,
    this.reportNumber,
    this.customerId,
    required this.reportType,
    required this.status,
    required this.title,
    this.siteAddress,
    this.equipmentName,
    this.equipmentManufacturer,
    this.equipmentModel,
    this.equipmentSerial,
    this.issueReported,
    this.diagnosis,
    required this.workPerformed,
    this.recommendations,
    this.internalNotes,
    this.startedAt,
    this.completedAt,
    this.finalizedAt,
    this.finalizedSnapshotJson,
    required this.pdfTemplateId,
    required this.createdAt,
    required this.updatedAt,
    this.archivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || reportNumber != null) {
      map['report_number'] = Variable<String>(reportNumber);
    }
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    map['report_type'] = Variable<String>(reportType);
    map['status'] = Variable<String>(status);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || siteAddress != null) {
      map['site_address'] = Variable<String>(siteAddress);
    }
    if (!nullToAbsent || equipmentName != null) {
      map['equipment_name'] = Variable<String>(equipmentName);
    }
    if (!nullToAbsent || equipmentManufacturer != null) {
      map['equipment_manufacturer'] = Variable<String>(equipmentManufacturer);
    }
    if (!nullToAbsent || equipmentModel != null) {
      map['equipment_model'] = Variable<String>(equipmentModel);
    }
    if (!nullToAbsent || equipmentSerial != null) {
      map['equipment_serial'] = Variable<String>(equipmentSerial);
    }
    if (!nullToAbsent || issueReported != null) {
      map['issue_reported'] = Variable<String>(issueReported);
    }
    if (!nullToAbsent || diagnosis != null) {
      map['diagnosis'] = Variable<String>(diagnosis);
    }
    map['work_performed'] = Variable<String>(workPerformed);
    if (!nullToAbsent || recommendations != null) {
      map['recommendations'] = Variable<String>(recommendations);
    }
    if (!nullToAbsent || internalNotes != null) {
      map['internal_notes'] = Variable<String>(internalNotes);
    }
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || finalizedAt != null) {
      map['finalized_at'] = Variable<DateTime>(finalizedAt);
    }
    if (!nullToAbsent || finalizedSnapshotJson != null) {
      map['finalized_snapshot_json'] = Variable<String>(finalizedSnapshotJson);
    }
    map['pdf_template_id'] = Variable<String>(pdfTemplateId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  ReportsCompanion toCompanion(bool nullToAbsent) {
    return ReportsCompanion(
      id: Value(id),
      reportNumber: reportNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(reportNumber),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      reportType: Value(reportType),
      status: Value(status),
      title: Value(title),
      siteAddress: siteAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(siteAddress),
      equipmentName: equipmentName == null && nullToAbsent
          ? const Value.absent()
          : Value(equipmentName),
      equipmentManufacturer: equipmentManufacturer == null && nullToAbsent
          ? const Value.absent()
          : Value(equipmentManufacturer),
      equipmentModel: equipmentModel == null && nullToAbsent
          ? const Value.absent()
          : Value(equipmentModel),
      equipmentSerial: equipmentSerial == null && nullToAbsent
          ? const Value.absent()
          : Value(equipmentSerial),
      issueReported: issueReported == null && nullToAbsent
          ? const Value.absent()
          : Value(issueReported),
      diagnosis: diagnosis == null && nullToAbsent
          ? const Value.absent()
          : Value(diagnosis),
      workPerformed: Value(workPerformed),
      recommendations: recommendations == null && nullToAbsent
          ? const Value.absent()
          : Value(recommendations),
      internalNotes: internalNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(internalNotes),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      finalizedAt: finalizedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(finalizedAt),
      finalizedSnapshotJson: finalizedSnapshotJson == null && nullToAbsent
          ? const Value.absent()
          : Value(finalizedSnapshotJson),
      pdfTemplateId: Value(pdfTemplateId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
    );
  }

  factory ReportEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReportEntity(
      id: serializer.fromJson<String>(json['id']),
      reportNumber: serializer.fromJson<String?>(json['reportNumber']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      reportType: serializer.fromJson<String>(json['reportType']),
      status: serializer.fromJson<String>(json['status']),
      title: serializer.fromJson<String>(json['title']),
      siteAddress: serializer.fromJson<String?>(json['siteAddress']),
      equipmentName: serializer.fromJson<String?>(json['equipmentName']),
      equipmentManufacturer: serializer.fromJson<String?>(
        json['equipmentManufacturer'],
      ),
      equipmentModel: serializer.fromJson<String?>(json['equipmentModel']),
      equipmentSerial: serializer.fromJson<String?>(json['equipmentSerial']),
      issueReported: serializer.fromJson<String?>(json['issueReported']),
      diagnosis: serializer.fromJson<String?>(json['diagnosis']),
      workPerformed: serializer.fromJson<String>(json['workPerformed']),
      recommendations: serializer.fromJson<String?>(json['recommendations']),
      internalNotes: serializer.fromJson<String?>(json['internalNotes']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      finalizedAt: serializer.fromJson<DateTime?>(json['finalizedAt']),
      finalizedSnapshotJson: serializer.fromJson<String?>(
        json['finalizedSnapshotJson'],
      ),
      pdfTemplateId: serializer.fromJson<String>(json['pdfTemplateId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'reportNumber': serializer.toJson<String?>(reportNumber),
      'customerId': serializer.toJson<String?>(customerId),
      'reportType': serializer.toJson<String>(reportType),
      'status': serializer.toJson<String>(status),
      'title': serializer.toJson<String>(title),
      'siteAddress': serializer.toJson<String?>(siteAddress),
      'equipmentName': serializer.toJson<String?>(equipmentName),
      'equipmentManufacturer': serializer.toJson<String?>(
        equipmentManufacturer,
      ),
      'equipmentModel': serializer.toJson<String?>(equipmentModel),
      'equipmentSerial': serializer.toJson<String?>(equipmentSerial),
      'issueReported': serializer.toJson<String?>(issueReported),
      'diagnosis': serializer.toJson<String?>(diagnosis),
      'workPerformed': serializer.toJson<String>(workPerformed),
      'recommendations': serializer.toJson<String?>(recommendations),
      'internalNotes': serializer.toJson<String?>(internalNotes),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'finalizedAt': serializer.toJson<DateTime?>(finalizedAt),
      'finalizedSnapshotJson': serializer.toJson<String?>(
        finalizedSnapshotJson,
      ),
      'pdfTemplateId': serializer.toJson<String>(pdfTemplateId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  ReportEntity copyWith({
    String? id,
    Value<String?> reportNumber = const Value.absent(),
    Value<String?> customerId = const Value.absent(),
    String? reportType,
    String? status,
    String? title,
    Value<String?> siteAddress = const Value.absent(),
    Value<String?> equipmentName = const Value.absent(),
    Value<String?> equipmentManufacturer = const Value.absent(),
    Value<String?> equipmentModel = const Value.absent(),
    Value<String?> equipmentSerial = const Value.absent(),
    Value<String?> issueReported = const Value.absent(),
    Value<String?> diagnosis = const Value.absent(),
    String? workPerformed,
    Value<String?> recommendations = const Value.absent(),
    Value<String?> internalNotes = const Value.absent(),
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
    Value<DateTime?> finalizedAt = const Value.absent(),
    Value<String?> finalizedSnapshotJson = const Value.absent(),
    String? pdfTemplateId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> archivedAt = const Value.absent(),
  }) => ReportEntity(
    id: id ?? this.id,
    reportNumber: reportNumber.present ? reportNumber.value : this.reportNumber,
    customerId: customerId.present ? customerId.value : this.customerId,
    reportType: reportType ?? this.reportType,
    status: status ?? this.status,
    title: title ?? this.title,
    siteAddress: siteAddress.present ? siteAddress.value : this.siteAddress,
    equipmentName: equipmentName.present
        ? equipmentName.value
        : this.equipmentName,
    equipmentManufacturer: equipmentManufacturer.present
        ? equipmentManufacturer.value
        : this.equipmentManufacturer,
    equipmentModel: equipmentModel.present
        ? equipmentModel.value
        : this.equipmentModel,
    equipmentSerial: equipmentSerial.present
        ? equipmentSerial.value
        : this.equipmentSerial,
    issueReported: issueReported.present
        ? issueReported.value
        : this.issueReported,
    diagnosis: diagnosis.present ? diagnosis.value : this.diagnosis,
    workPerformed: workPerformed ?? this.workPerformed,
    recommendations: recommendations.present
        ? recommendations.value
        : this.recommendations,
    internalNotes: internalNotes.present
        ? internalNotes.value
        : this.internalNotes,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    finalizedAt: finalizedAt.present ? finalizedAt.value : this.finalizedAt,
    finalizedSnapshotJson: finalizedSnapshotJson.present
        ? finalizedSnapshotJson.value
        : this.finalizedSnapshotJson,
    pdfTemplateId: pdfTemplateId ?? this.pdfTemplateId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
  );
  ReportEntity copyWithCompanion(ReportsCompanion data) {
    return ReportEntity(
      id: data.id.present ? data.id.value : this.id,
      reportNumber: data.reportNumber.present
          ? data.reportNumber.value
          : this.reportNumber,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      reportType: data.reportType.present
          ? data.reportType.value
          : this.reportType,
      status: data.status.present ? data.status.value : this.status,
      title: data.title.present ? data.title.value : this.title,
      siteAddress: data.siteAddress.present
          ? data.siteAddress.value
          : this.siteAddress,
      equipmentName: data.equipmentName.present
          ? data.equipmentName.value
          : this.equipmentName,
      equipmentManufacturer: data.equipmentManufacturer.present
          ? data.equipmentManufacturer.value
          : this.equipmentManufacturer,
      equipmentModel: data.equipmentModel.present
          ? data.equipmentModel.value
          : this.equipmentModel,
      equipmentSerial: data.equipmentSerial.present
          ? data.equipmentSerial.value
          : this.equipmentSerial,
      issueReported: data.issueReported.present
          ? data.issueReported.value
          : this.issueReported,
      diagnosis: data.diagnosis.present ? data.diagnosis.value : this.diagnosis,
      workPerformed: data.workPerformed.present
          ? data.workPerformed.value
          : this.workPerformed,
      recommendations: data.recommendations.present
          ? data.recommendations.value
          : this.recommendations,
      internalNotes: data.internalNotes.present
          ? data.internalNotes.value
          : this.internalNotes,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      finalizedAt: data.finalizedAt.present
          ? data.finalizedAt.value
          : this.finalizedAt,
      finalizedSnapshotJson: data.finalizedSnapshotJson.present
          ? data.finalizedSnapshotJson.value
          : this.finalizedSnapshotJson,
      pdfTemplateId: data.pdfTemplateId.present
          ? data.pdfTemplateId.value
          : this.pdfTemplateId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReportEntity(')
          ..write('id: $id, ')
          ..write('reportNumber: $reportNumber, ')
          ..write('customerId: $customerId, ')
          ..write('reportType: $reportType, ')
          ..write('status: $status, ')
          ..write('title: $title, ')
          ..write('siteAddress: $siteAddress, ')
          ..write('equipmentName: $equipmentName, ')
          ..write('equipmentManufacturer: $equipmentManufacturer, ')
          ..write('equipmentModel: $equipmentModel, ')
          ..write('equipmentSerial: $equipmentSerial, ')
          ..write('issueReported: $issueReported, ')
          ..write('diagnosis: $diagnosis, ')
          ..write('workPerformed: $workPerformed, ')
          ..write('recommendations: $recommendations, ')
          ..write('internalNotes: $internalNotes, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('finalizedAt: $finalizedAt, ')
          ..write('finalizedSnapshotJson: $finalizedSnapshotJson, ')
          ..write('pdfTemplateId: $pdfTemplateId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    reportNumber,
    customerId,
    reportType,
    status,
    title,
    siteAddress,
    equipmentName,
    equipmentManufacturer,
    equipmentModel,
    equipmentSerial,
    issueReported,
    diagnosis,
    workPerformed,
    recommendations,
    internalNotes,
    startedAt,
    completedAt,
    finalizedAt,
    finalizedSnapshotJson,
    pdfTemplateId,
    createdAt,
    updatedAt,
    archivedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReportEntity &&
          other.id == this.id &&
          other.reportNumber == this.reportNumber &&
          other.customerId == this.customerId &&
          other.reportType == this.reportType &&
          other.status == this.status &&
          other.title == this.title &&
          other.siteAddress == this.siteAddress &&
          other.equipmentName == this.equipmentName &&
          other.equipmentManufacturer == this.equipmentManufacturer &&
          other.equipmentModel == this.equipmentModel &&
          other.equipmentSerial == this.equipmentSerial &&
          other.issueReported == this.issueReported &&
          other.diagnosis == this.diagnosis &&
          other.workPerformed == this.workPerformed &&
          other.recommendations == this.recommendations &&
          other.internalNotes == this.internalNotes &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.finalizedAt == this.finalizedAt &&
          other.finalizedSnapshotJson == this.finalizedSnapshotJson &&
          other.pdfTemplateId == this.pdfTemplateId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.archivedAt == this.archivedAt);
}

class ReportsCompanion extends UpdateCompanion<ReportEntity> {
  final Value<String> id;
  final Value<String?> reportNumber;
  final Value<String?> customerId;
  final Value<String> reportType;
  final Value<String> status;
  final Value<String> title;
  final Value<String?> siteAddress;
  final Value<String?> equipmentName;
  final Value<String?> equipmentManufacturer;
  final Value<String?> equipmentModel;
  final Value<String?> equipmentSerial;
  final Value<String?> issueReported;
  final Value<String?> diagnosis;
  final Value<String> workPerformed;
  final Value<String?> recommendations;
  final Value<String?> internalNotes;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> completedAt;
  final Value<DateTime?> finalizedAt;
  final Value<String?> finalizedSnapshotJson;
  final Value<String> pdfTemplateId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> archivedAt;
  final Value<int> rowid;
  const ReportsCompanion({
    this.id = const Value.absent(),
    this.reportNumber = const Value.absent(),
    this.customerId = const Value.absent(),
    this.reportType = const Value.absent(),
    this.status = const Value.absent(),
    this.title = const Value.absent(),
    this.siteAddress = const Value.absent(),
    this.equipmentName = const Value.absent(),
    this.equipmentManufacturer = const Value.absent(),
    this.equipmentModel = const Value.absent(),
    this.equipmentSerial = const Value.absent(),
    this.issueReported = const Value.absent(),
    this.diagnosis = const Value.absent(),
    this.workPerformed = const Value.absent(),
    this.recommendations = const Value.absent(),
    this.internalNotes = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.finalizedAt = const Value.absent(),
    this.finalizedSnapshotJson = const Value.absent(),
    this.pdfTemplateId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReportsCompanion.insert({
    required String id,
    this.reportNumber = const Value.absent(),
    this.customerId = const Value.absent(),
    this.reportType = const Value.absent(),
    this.status = const Value.absent(),
    this.title = const Value.absent(),
    this.siteAddress = const Value.absent(),
    this.equipmentName = const Value.absent(),
    this.equipmentManufacturer = const Value.absent(),
    this.equipmentModel = const Value.absent(),
    this.equipmentSerial = const Value.absent(),
    this.issueReported = const Value.absent(),
    this.diagnosis = const Value.absent(),
    this.workPerformed = const Value.absent(),
    this.recommendations = const Value.absent(),
    this.internalNotes = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.finalizedAt = const Value.absent(),
    this.finalizedSnapshotJson = const Value.absent(),
    this.pdfTemplateId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ReportEntity> custom({
    Expression<String>? id,
    Expression<String>? reportNumber,
    Expression<String>? customerId,
    Expression<String>? reportType,
    Expression<String>? status,
    Expression<String>? title,
    Expression<String>? siteAddress,
    Expression<String>? equipmentName,
    Expression<String>? equipmentManufacturer,
    Expression<String>? equipmentModel,
    Expression<String>? equipmentSerial,
    Expression<String>? issueReported,
    Expression<String>? diagnosis,
    Expression<String>? workPerformed,
    Expression<String>? recommendations,
    Expression<String>? internalNotes,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? finalizedAt,
    Expression<String>? finalizedSnapshotJson,
    Expression<String>? pdfTemplateId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reportNumber != null) 'report_number': reportNumber,
      if (customerId != null) 'customer_id': customerId,
      if (reportType != null) 'report_type': reportType,
      if (status != null) 'status': status,
      if (title != null) 'title': title,
      if (siteAddress != null) 'site_address': siteAddress,
      if (equipmentName != null) 'equipment_name': equipmentName,
      if (equipmentManufacturer != null)
        'equipment_manufacturer': equipmentManufacturer,
      if (equipmentModel != null) 'equipment_model': equipmentModel,
      if (equipmentSerial != null) 'equipment_serial': equipmentSerial,
      if (issueReported != null) 'issue_reported': issueReported,
      if (diagnosis != null) 'diagnosis': diagnosis,
      if (workPerformed != null) 'work_performed': workPerformed,
      if (recommendations != null) 'recommendations': recommendations,
      if (internalNotes != null) 'internal_notes': internalNotes,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (finalizedAt != null) 'finalized_at': finalizedAt,
      if (finalizedSnapshotJson != null)
        'finalized_snapshot_json': finalizedSnapshotJson,
      if (pdfTemplateId != null) 'pdf_template_id': pdfTemplateId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReportsCompanion copyWith({
    Value<String>? id,
    Value<String?>? reportNumber,
    Value<String?>? customerId,
    Value<String>? reportType,
    Value<String>? status,
    Value<String>? title,
    Value<String?>? siteAddress,
    Value<String?>? equipmentName,
    Value<String?>? equipmentManufacturer,
    Value<String?>? equipmentModel,
    Value<String?>? equipmentSerial,
    Value<String?>? issueReported,
    Value<String?>? diagnosis,
    Value<String>? workPerformed,
    Value<String?>? recommendations,
    Value<String?>? internalNotes,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? completedAt,
    Value<DateTime?>? finalizedAt,
    Value<String?>? finalizedSnapshotJson,
    Value<String>? pdfTemplateId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? archivedAt,
    Value<int>? rowid,
  }) {
    return ReportsCompanion(
      id: id ?? this.id,
      reportNumber: reportNumber ?? this.reportNumber,
      customerId: customerId ?? this.customerId,
      reportType: reportType ?? this.reportType,
      status: status ?? this.status,
      title: title ?? this.title,
      siteAddress: siteAddress ?? this.siteAddress,
      equipmentName: equipmentName ?? this.equipmentName,
      equipmentManufacturer:
          equipmentManufacturer ?? this.equipmentManufacturer,
      equipmentModel: equipmentModel ?? this.equipmentModel,
      equipmentSerial: equipmentSerial ?? this.equipmentSerial,
      issueReported: issueReported ?? this.issueReported,
      diagnosis: diagnosis ?? this.diagnosis,
      workPerformed: workPerformed ?? this.workPerformed,
      recommendations: recommendations ?? this.recommendations,
      internalNotes: internalNotes ?? this.internalNotes,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      finalizedAt: finalizedAt ?? this.finalizedAt,
      finalizedSnapshotJson:
          finalizedSnapshotJson ?? this.finalizedSnapshotJson,
      pdfTemplateId: pdfTemplateId ?? this.pdfTemplateId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (reportNumber.present) {
      map['report_number'] = Variable<String>(reportNumber.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (reportType.present) {
      map['report_type'] = Variable<String>(reportType.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (siteAddress.present) {
      map['site_address'] = Variable<String>(siteAddress.value);
    }
    if (equipmentName.present) {
      map['equipment_name'] = Variable<String>(equipmentName.value);
    }
    if (equipmentManufacturer.present) {
      map['equipment_manufacturer'] = Variable<String>(
        equipmentManufacturer.value,
      );
    }
    if (equipmentModel.present) {
      map['equipment_model'] = Variable<String>(equipmentModel.value);
    }
    if (equipmentSerial.present) {
      map['equipment_serial'] = Variable<String>(equipmentSerial.value);
    }
    if (issueReported.present) {
      map['issue_reported'] = Variable<String>(issueReported.value);
    }
    if (diagnosis.present) {
      map['diagnosis'] = Variable<String>(diagnosis.value);
    }
    if (workPerformed.present) {
      map['work_performed'] = Variable<String>(workPerformed.value);
    }
    if (recommendations.present) {
      map['recommendations'] = Variable<String>(recommendations.value);
    }
    if (internalNotes.present) {
      map['internal_notes'] = Variable<String>(internalNotes.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (finalizedAt.present) {
      map['finalized_at'] = Variable<DateTime>(finalizedAt.value);
    }
    if (finalizedSnapshotJson.present) {
      map['finalized_snapshot_json'] = Variable<String>(
        finalizedSnapshotJson.value,
      );
    }
    if (pdfTemplateId.present) {
      map['pdf_template_id'] = Variable<String>(pdfTemplateId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReportsCompanion(')
          ..write('id: $id, ')
          ..write('reportNumber: $reportNumber, ')
          ..write('customerId: $customerId, ')
          ..write('reportType: $reportType, ')
          ..write('status: $status, ')
          ..write('title: $title, ')
          ..write('siteAddress: $siteAddress, ')
          ..write('equipmentName: $equipmentName, ')
          ..write('equipmentManufacturer: $equipmentManufacturer, ')
          ..write('equipmentModel: $equipmentModel, ')
          ..write('equipmentSerial: $equipmentSerial, ')
          ..write('issueReported: $issueReported, ')
          ..write('diagnosis: $diagnosis, ')
          ..write('workPerformed: $workPerformed, ')
          ..write('recommendations: $recommendations, ')
          ..write('internalNotes: $internalNotes, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('finalizedAt: $finalizedAt, ')
          ..write('finalizedSnapshotJson: $finalizedSnapshotJson, ')
          ..write('pdfTemplateId: $pdfTemplateId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReportPhotosTable extends ReportPhotos
    with TableInfo<$ReportPhotosTable, ReportPhotoEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReportPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reportIdMeta = const VerificationMeta(
    'reportId',
  );
  @override
  late final GeneratedColumn<String> reportId = GeneratedColumn<String>(
    'report_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES reports (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thumbnailPathMeta = const VerificationMeta(
    'thumbnailPath',
  );
  @override
  late final GeneratedColumn<String> thumbnailPath = GeneratedColumn<String>(
    'thumbnail_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _captionMeta = const VerificationMeta(
    'caption',
  );
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
    'caption',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    reportId,
    filePath,
    thumbnailPath,
    category,
    caption,
    sortOrder,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'report_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReportPhotoEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('report_id')) {
      context.handle(
        _reportIdMeta,
        reportId.isAcceptableOrUnknown(data['report_id']!, _reportIdMeta),
      );
    } else if (isInserting) {
      context.missing(_reportIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('thumbnail_path')) {
      context.handle(
        _thumbnailPathMeta,
        thumbnailPath.isAcceptableOrUnknown(
          data['thumbnail_path']!,
          _thumbnailPathMeta,
        ),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('caption')) {
      context.handle(
        _captionMeta,
        caption.isAcceptableOrUnknown(data['caption']!, _captionMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReportPhotoEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReportPhotoEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      reportId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}report_id'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      thumbnailPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_path'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      caption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caption'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ReportPhotosTable createAlias(String alias) {
    return $ReportPhotosTable(attachedDatabase, alias);
  }
}

class ReportPhotoEntity extends DataClass
    implements Insertable<ReportPhotoEntity> {
  final String id;
  final String reportId;
  final String filePath;
  final String? thumbnailPath;
  final String category;
  final String? caption;
  final int sortOrder;
  final DateTime createdAt;
  const ReportPhotoEntity({
    required this.id,
    required this.reportId,
    required this.filePath,
    this.thumbnailPath,
    required this.category,
    this.caption,
    required this.sortOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['report_id'] = Variable<String>(reportId);
    map['file_path'] = Variable<String>(filePath);
    if (!nullToAbsent || thumbnailPath != null) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath);
    }
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || caption != null) {
      map['caption'] = Variable<String>(caption);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ReportPhotosCompanion toCompanion(bool nullToAbsent) {
    return ReportPhotosCompanion(
      id: Value(id),
      reportId: Value(reportId),
      filePath: Value(filePath),
      thumbnailPath: thumbnailPath == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailPath),
      category: Value(category),
      caption: caption == null && nullToAbsent
          ? const Value.absent()
          : Value(caption),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
    );
  }

  factory ReportPhotoEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReportPhotoEntity(
      id: serializer.fromJson<String>(json['id']),
      reportId: serializer.fromJson<String>(json['reportId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      thumbnailPath: serializer.fromJson<String?>(json['thumbnailPath']),
      category: serializer.fromJson<String>(json['category']),
      caption: serializer.fromJson<String?>(json['caption']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'reportId': serializer.toJson<String>(reportId),
      'filePath': serializer.toJson<String>(filePath),
      'thumbnailPath': serializer.toJson<String?>(thumbnailPath),
      'category': serializer.toJson<String>(category),
      'caption': serializer.toJson<String?>(caption),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ReportPhotoEntity copyWith({
    String? id,
    String? reportId,
    String? filePath,
    Value<String?> thumbnailPath = const Value.absent(),
    String? category,
    Value<String?> caption = const Value.absent(),
    int? sortOrder,
    DateTime? createdAt,
  }) => ReportPhotoEntity(
    id: id ?? this.id,
    reportId: reportId ?? this.reportId,
    filePath: filePath ?? this.filePath,
    thumbnailPath: thumbnailPath.present
        ? thumbnailPath.value
        : this.thumbnailPath,
    category: category ?? this.category,
    caption: caption.present ? caption.value : this.caption,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  ReportPhotoEntity copyWithCompanion(ReportPhotosCompanion data) {
    return ReportPhotoEntity(
      id: data.id.present ? data.id.value : this.id,
      reportId: data.reportId.present ? data.reportId.value : this.reportId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      thumbnailPath: data.thumbnailPath.present
          ? data.thumbnailPath.value
          : this.thumbnailPath,
      category: data.category.present ? data.category.value : this.category,
      caption: data.caption.present ? data.caption.value : this.caption,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReportPhotoEntity(')
          ..write('id: $id, ')
          ..write('reportId: $reportId, ')
          ..write('filePath: $filePath, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('category: $category, ')
          ..write('caption: $caption, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    reportId,
    filePath,
    thumbnailPath,
    category,
    caption,
    sortOrder,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReportPhotoEntity &&
          other.id == this.id &&
          other.reportId == this.reportId &&
          other.filePath == this.filePath &&
          other.thumbnailPath == this.thumbnailPath &&
          other.category == this.category &&
          other.caption == this.caption &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt);
}

class ReportPhotosCompanion extends UpdateCompanion<ReportPhotoEntity> {
  final Value<String> id;
  final Value<String> reportId;
  final Value<String> filePath;
  final Value<String?> thumbnailPath;
  final Value<String> category;
  final Value<String?> caption;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ReportPhotosCompanion({
    this.id = const Value.absent(),
    this.reportId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.category = const Value.absent(),
    this.caption = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReportPhotosCompanion.insert({
    required String id,
    required String reportId,
    required String filePath,
    this.thumbnailPath = const Value.absent(),
    required String category,
    this.caption = const Value.absent(),
    required int sortOrder,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       reportId = Value(reportId),
       filePath = Value(filePath),
       category = Value(category),
       sortOrder = Value(sortOrder),
       createdAt = Value(createdAt);
  static Insertable<ReportPhotoEntity> custom({
    Expression<String>? id,
    Expression<String>? reportId,
    Expression<String>? filePath,
    Expression<String>? thumbnailPath,
    Expression<String>? category,
    Expression<String>? caption,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reportId != null) 'report_id': reportId,
      if (filePath != null) 'file_path': filePath,
      if (thumbnailPath != null) 'thumbnail_path': thumbnailPath,
      if (category != null) 'category': category,
      if (caption != null) 'caption': caption,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReportPhotosCompanion copyWith({
    Value<String>? id,
    Value<String>? reportId,
    Value<String>? filePath,
    Value<String?>? thumbnailPath,
    Value<String>? category,
    Value<String?>? caption,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ReportPhotosCompanion(
      id: id ?? this.id,
      reportId: reportId ?? this.reportId,
      filePath: filePath ?? this.filePath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      category: category ?? this.category,
      caption: caption ?? this.caption,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (reportId.present) {
      map['report_id'] = Variable<String>(reportId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (thumbnailPath.present) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReportPhotosCompanion(')
          ..write('id: $id, ')
          ..write('reportId: $reportId, ')
          ..write('filePath: $filePath, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('category: $category, ')
          ..write('caption: $caption, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReportMaterialsTable extends ReportMaterials
    with TableInfo<$ReportMaterialsTable, ReportMaterialEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReportMaterialsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reportIdMeta = const VerificationMeta(
    'reportId',
  );
  @override
  late final GeneratedColumn<String> reportId = GeneratedColumn<String>(
    'report_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES reports (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    reportId,
    name,
    quantity,
    unit,
    notes,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'report_materials';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReportMaterialEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('report_id')) {
      context.handle(
        _reportIdMeta,
        reportId.isAcceptableOrUnknown(data['report_id']!, _reportIdMeta),
      );
    } else if (isInserting) {
      context.missing(_reportIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReportMaterialEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReportMaterialEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      reportId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}report_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $ReportMaterialsTable createAlias(String alias) {
    return $ReportMaterialsTable(attachedDatabase, alias);
  }
}

class ReportMaterialEntity extends DataClass
    implements Insertable<ReportMaterialEntity> {
  final String id;
  final String reportId;
  final String name;
  final double quantity;
  final String? unit;
  final String? notes;
  final int sortOrder;
  const ReportMaterialEntity({
    required this.id,
    required this.reportId,
    required this.name,
    required this.quantity,
    this.unit,
    this.notes,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['report_id'] = Variable<String>(reportId);
    map['name'] = Variable<String>(name);
    map['quantity'] = Variable<double>(quantity);
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  ReportMaterialsCompanion toCompanion(bool nullToAbsent) {
    return ReportMaterialsCompanion(
      id: Value(id),
      reportId: Value(reportId),
      name: Value(name),
      quantity: Value(quantity),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      sortOrder: Value(sortOrder),
    );
  }

  factory ReportMaterialEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReportMaterialEntity(
      id: serializer.fromJson<String>(json['id']),
      reportId: serializer.fromJson<String>(json['reportId']),
      name: serializer.fromJson<String>(json['name']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unit: serializer.fromJson<String?>(json['unit']),
      notes: serializer.fromJson<String?>(json['notes']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'reportId': serializer.toJson<String>(reportId),
      'name': serializer.toJson<String>(name),
      'quantity': serializer.toJson<double>(quantity),
      'unit': serializer.toJson<String?>(unit),
      'notes': serializer.toJson<String?>(notes),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  ReportMaterialEntity copyWith({
    String? id,
    String? reportId,
    String? name,
    double? quantity,
    Value<String?> unit = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    int? sortOrder,
  }) => ReportMaterialEntity(
    id: id ?? this.id,
    reportId: reportId ?? this.reportId,
    name: name ?? this.name,
    quantity: quantity ?? this.quantity,
    unit: unit.present ? unit.value : this.unit,
    notes: notes.present ? notes.value : this.notes,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  ReportMaterialEntity copyWithCompanion(ReportMaterialsCompanion data) {
    return ReportMaterialEntity(
      id: data.id.present ? data.id.value : this.id,
      reportId: data.reportId.present ? data.reportId.value : this.reportId,
      name: data.name.present ? data.name.value : this.name,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      notes: data.notes.present ? data.notes.value : this.notes,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReportMaterialEntity(')
          ..write('id: $id, ')
          ..write('reportId: $reportId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, reportId, name, quantity, unit, notes, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReportMaterialEntity &&
          other.id == this.id &&
          other.reportId == this.reportId &&
          other.name == this.name &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.notes == this.notes &&
          other.sortOrder == this.sortOrder);
}

class ReportMaterialsCompanion extends UpdateCompanion<ReportMaterialEntity> {
  final Value<String> id;
  final Value<String> reportId;
  final Value<String> name;
  final Value<double> quantity;
  final Value<String?> unit;
  final Value<String?> notes;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const ReportMaterialsCompanion({
    this.id = const Value.absent(),
    this.reportId = const Value.absent(),
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.notes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReportMaterialsCompanion.insert({
    required String id,
    required String reportId,
    required String name,
    required double quantity,
    this.unit = const Value.absent(),
    this.notes = const Value.absent(),
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       reportId = Value(reportId),
       name = Value(name),
       quantity = Value(quantity),
       sortOrder = Value(sortOrder);
  static Insertable<ReportMaterialEntity> custom({
    Expression<String>? id,
    Expression<String>? reportId,
    Expression<String>? name,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<String>? notes,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reportId != null) 'report_id': reportId,
      if (name != null) 'name': name,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (notes != null) 'notes': notes,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReportMaterialsCompanion copyWith({
    Value<String>? id,
    Value<String>? reportId,
    Value<String>? name,
    Value<double>? quantity,
    Value<String?>? unit,
    Value<String?>? notes,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return ReportMaterialsCompanion(
      id: id ?? this.id,
      reportId: reportId ?? this.reportId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      notes: notes ?? this.notes,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (reportId.present) {
      map['report_id'] = Variable<String>(reportId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReportMaterialsCompanion(')
          ..write('id: $id, ')
          ..write('reportId: $reportId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReportSignaturesTable extends ReportSignatures
    with TableInfo<$ReportSignaturesTable, ReportSignatureEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReportSignaturesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reportIdMeta = const VerificationMeta(
    'reportId',
  );
  @override
  late final GeneratedColumn<String> reportId = GeneratedColumn<String>(
    'report_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES reports (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _signatureTypeMeta = const VerificationMeta(
    'signatureType',
  );
  @override
  late final GeneratedColumn<String> signatureType = GeneratedColumn<String>(
    'signature_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _signerNameMeta = const VerificationMeta(
    'signerName',
  );
  @override
  late final GeneratedColumn<String> signerName = GeneratedColumn<String>(
    'signer_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _signedAtMeta = const VerificationMeta(
    'signedAt',
  );
  @override
  late final GeneratedColumn<DateTime> signedAt = GeneratedColumn<DateTime>(
    'signed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    reportId,
    signatureType,
    signerName,
    filePath,
    signedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'report_signatures';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReportSignatureEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('report_id')) {
      context.handle(
        _reportIdMeta,
        reportId.isAcceptableOrUnknown(data['report_id']!, _reportIdMeta),
      );
    } else if (isInserting) {
      context.missing(_reportIdMeta);
    }
    if (data.containsKey('signature_type')) {
      context.handle(
        _signatureTypeMeta,
        signatureType.isAcceptableOrUnknown(
          data['signature_type']!,
          _signatureTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_signatureTypeMeta);
    }
    if (data.containsKey('signer_name')) {
      context.handle(
        _signerNameMeta,
        signerName.isAcceptableOrUnknown(data['signer_name']!, _signerNameMeta),
      );
    } else if (isInserting) {
      context.missing(_signerNameMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('signed_at')) {
      context.handle(
        _signedAtMeta,
        signedAt.isAcceptableOrUnknown(data['signed_at']!, _signedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_signedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReportSignatureEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReportSignatureEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      reportId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}report_id'],
      )!,
      signatureType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}signature_type'],
      )!,
      signerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}signer_name'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      signedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}signed_at'],
      )!,
    );
  }

  @override
  $ReportSignaturesTable createAlias(String alias) {
    return $ReportSignaturesTable(attachedDatabase, alias);
  }
}

class ReportSignatureEntity extends DataClass
    implements Insertable<ReportSignatureEntity> {
  final String id;
  final String reportId;
  final String signatureType;
  final String signerName;
  final String filePath;
  final DateTime signedAt;
  const ReportSignatureEntity({
    required this.id,
    required this.reportId,
    required this.signatureType,
    required this.signerName,
    required this.filePath,
    required this.signedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['report_id'] = Variable<String>(reportId);
    map['signature_type'] = Variable<String>(signatureType);
    map['signer_name'] = Variable<String>(signerName);
    map['file_path'] = Variable<String>(filePath);
    map['signed_at'] = Variable<DateTime>(signedAt);
    return map;
  }

  ReportSignaturesCompanion toCompanion(bool nullToAbsent) {
    return ReportSignaturesCompanion(
      id: Value(id),
      reportId: Value(reportId),
      signatureType: Value(signatureType),
      signerName: Value(signerName),
      filePath: Value(filePath),
      signedAt: Value(signedAt),
    );
  }

  factory ReportSignatureEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReportSignatureEntity(
      id: serializer.fromJson<String>(json['id']),
      reportId: serializer.fromJson<String>(json['reportId']),
      signatureType: serializer.fromJson<String>(json['signatureType']),
      signerName: serializer.fromJson<String>(json['signerName']),
      filePath: serializer.fromJson<String>(json['filePath']),
      signedAt: serializer.fromJson<DateTime>(json['signedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'reportId': serializer.toJson<String>(reportId),
      'signatureType': serializer.toJson<String>(signatureType),
      'signerName': serializer.toJson<String>(signerName),
      'filePath': serializer.toJson<String>(filePath),
      'signedAt': serializer.toJson<DateTime>(signedAt),
    };
  }

  ReportSignatureEntity copyWith({
    String? id,
    String? reportId,
    String? signatureType,
    String? signerName,
    String? filePath,
    DateTime? signedAt,
  }) => ReportSignatureEntity(
    id: id ?? this.id,
    reportId: reportId ?? this.reportId,
    signatureType: signatureType ?? this.signatureType,
    signerName: signerName ?? this.signerName,
    filePath: filePath ?? this.filePath,
    signedAt: signedAt ?? this.signedAt,
  );
  ReportSignatureEntity copyWithCompanion(ReportSignaturesCompanion data) {
    return ReportSignatureEntity(
      id: data.id.present ? data.id.value : this.id,
      reportId: data.reportId.present ? data.reportId.value : this.reportId,
      signatureType: data.signatureType.present
          ? data.signatureType.value
          : this.signatureType,
      signerName: data.signerName.present
          ? data.signerName.value
          : this.signerName,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      signedAt: data.signedAt.present ? data.signedAt.value : this.signedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReportSignatureEntity(')
          ..write('id: $id, ')
          ..write('reportId: $reportId, ')
          ..write('signatureType: $signatureType, ')
          ..write('signerName: $signerName, ')
          ..write('filePath: $filePath, ')
          ..write('signedAt: $signedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, reportId, signatureType, signerName, filePath, signedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReportSignatureEntity &&
          other.id == this.id &&
          other.reportId == this.reportId &&
          other.signatureType == this.signatureType &&
          other.signerName == this.signerName &&
          other.filePath == this.filePath &&
          other.signedAt == this.signedAt);
}

class ReportSignaturesCompanion extends UpdateCompanion<ReportSignatureEntity> {
  final Value<String> id;
  final Value<String> reportId;
  final Value<String> signatureType;
  final Value<String> signerName;
  final Value<String> filePath;
  final Value<DateTime> signedAt;
  final Value<int> rowid;
  const ReportSignaturesCompanion({
    this.id = const Value.absent(),
    this.reportId = const Value.absent(),
    this.signatureType = const Value.absent(),
    this.signerName = const Value.absent(),
    this.filePath = const Value.absent(),
    this.signedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReportSignaturesCompanion.insert({
    required String id,
    required String reportId,
    required String signatureType,
    required String signerName,
    required String filePath,
    required DateTime signedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       reportId = Value(reportId),
       signatureType = Value(signatureType),
       signerName = Value(signerName),
       filePath = Value(filePath),
       signedAt = Value(signedAt);
  static Insertable<ReportSignatureEntity> custom({
    Expression<String>? id,
    Expression<String>? reportId,
    Expression<String>? signatureType,
    Expression<String>? signerName,
    Expression<String>? filePath,
    Expression<DateTime>? signedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reportId != null) 'report_id': reportId,
      if (signatureType != null) 'signature_type': signatureType,
      if (signerName != null) 'signer_name': signerName,
      if (filePath != null) 'file_path': filePath,
      if (signedAt != null) 'signed_at': signedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReportSignaturesCompanion copyWith({
    Value<String>? id,
    Value<String>? reportId,
    Value<String>? signatureType,
    Value<String>? signerName,
    Value<String>? filePath,
    Value<DateTime>? signedAt,
    Value<int>? rowid,
  }) {
    return ReportSignaturesCompanion(
      id: id ?? this.id,
      reportId: reportId ?? this.reportId,
      signatureType: signatureType ?? this.signatureType,
      signerName: signerName ?? this.signerName,
      filePath: filePath ?? this.filePath,
      signedAt: signedAt ?? this.signedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (reportId.present) {
      map['report_id'] = Variable<String>(reportId.value);
    }
    if (signatureType.present) {
      map['signature_type'] = Variable<String>(signatureType.value);
    }
    if (signerName.present) {
      map['signer_name'] = Variable<String>(signerName.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (signedAt.present) {
      map['signed_at'] = Variable<DateTime>(signedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReportSignaturesCompanion(')
          ..write('id: $id, ')
          ..write('reportId: $reportId, ')
          ..write('signatureType: $signatureType, ')
          ..write('signerName: $signerName, ')
          ..write('filePath: $filePath, ')
          ..write('signedAt: $signedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsageCountersTable extends UsageCounters
    with TableInfo<$UsageCountersTable, UsageCounterEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsageCountersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finalizedReportCountMeta =
      const VerificationMeta('finalizedReportCount');
  @override
  late final GeneratedColumn<int> finalizedReportCount = GeneratedColumn<int>(
    'finalized_report_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, year, month, finalizedReportCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usage_counters';
  @override
  VerificationContext validateIntegrity(
    Insertable<UsageCounterEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('finalized_report_count')) {
      context.handle(
        _finalizedReportCountMeta,
        finalizedReportCount.isAcceptableOrUnknown(
          data['finalized_report_count']!,
          _finalizedReportCountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsageCounterEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsageCounterEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month'],
      )!,
      finalizedReportCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}finalized_report_count'],
      )!,
    );
  }

  @override
  $UsageCountersTable createAlias(String alias) {
    return $UsageCountersTable(attachedDatabase, alias);
  }
}

class UsageCounterEntity extends DataClass
    implements Insertable<UsageCounterEntity> {
  final String id;
  final int year;
  final int month;
  final int finalizedReportCount;
  const UsageCounterEntity({
    required this.id,
    required this.year,
    required this.month,
    required this.finalizedReportCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['year'] = Variable<int>(year);
    map['month'] = Variable<int>(month);
    map['finalized_report_count'] = Variable<int>(finalizedReportCount);
    return map;
  }

  UsageCountersCompanion toCompanion(bool nullToAbsent) {
    return UsageCountersCompanion(
      id: Value(id),
      year: Value(year),
      month: Value(month),
      finalizedReportCount: Value(finalizedReportCount),
    );
  }

  factory UsageCounterEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsageCounterEntity(
      id: serializer.fromJson<String>(json['id']),
      year: serializer.fromJson<int>(json['year']),
      month: serializer.fromJson<int>(json['month']),
      finalizedReportCount: serializer.fromJson<int>(
        json['finalizedReportCount'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'year': serializer.toJson<int>(year),
      'month': serializer.toJson<int>(month),
      'finalizedReportCount': serializer.toJson<int>(finalizedReportCount),
    };
  }

  UsageCounterEntity copyWith({
    String? id,
    int? year,
    int? month,
    int? finalizedReportCount,
  }) => UsageCounterEntity(
    id: id ?? this.id,
    year: year ?? this.year,
    month: month ?? this.month,
    finalizedReportCount: finalizedReportCount ?? this.finalizedReportCount,
  );
  UsageCounterEntity copyWithCompanion(UsageCountersCompanion data) {
    return UsageCounterEntity(
      id: data.id.present ? data.id.value : this.id,
      year: data.year.present ? data.year.value : this.year,
      month: data.month.present ? data.month.value : this.month,
      finalizedReportCount: data.finalizedReportCount.present
          ? data.finalizedReportCount.value
          : this.finalizedReportCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsageCounterEntity(')
          ..write('id: $id, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('finalizedReportCount: $finalizedReportCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, year, month, finalizedReportCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsageCounterEntity &&
          other.id == this.id &&
          other.year == this.year &&
          other.month == this.month &&
          other.finalizedReportCount == this.finalizedReportCount);
}

class UsageCountersCompanion extends UpdateCompanion<UsageCounterEntity> {
  final Value<String> id;
  final Value<int> year;
  final Value<int> month;
  final Value<int> finalizedReportCount;
  final Value<int> rowid;
  const UsageCountersCompanion({
    this.id = const Value.absent(),
    this.year = const Value.absent(),
    this.month = const Value.absent(),
    this.finalizedReportCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsageCountersCompanion.insert({
    required String id,
    required int year,
    required int month,
    this.finalizedReportCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       year = Value(year),
       month = Value(month);
  static Insertable<UsageCounterEntity> custom({
    Expression<String>? id,
    Expression<int>? year,
    Expression<int>? month,
    Expression<int>? finalizedReportCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (year != null) 'year': year,
      if (month != null) 'month': month,
      if (finalizedReportCount != null)
        'finalized_report_count': finalizedReportCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsageCountersCompanion copyWith({
    Value<String>? id,
    Value<int>? year,
    Value<int>? month,
    Value<int>? finalizedReportCount,
    Value<int>? rowid,
  }) {
    return UsageCountersCompanion(
      id: id ?? this.id,
      year: year ?? this.year,
      month: month ?? this.month,
      finalizedReportCount: finalizedReportCount ?? this.finalizedReportCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (finalizedReportCount.present) {
      map['finalized_report_count'] = Variable<int>(finalizedReportCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsageCountersCompanion(')
          ..write('id: $id, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('finalizedReportCount: $finalizedReportCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DatabaseMetadataTable databaseMetadata = $DatabaseMetadataTable(
    this,
  );
  late final $BusinessProfilesTable businessProfiles = $BusinessProfilesTable(
    this,
  );
  late final $AppSettingsEntriesTable appSettingsEntries =
      $AppSettingsEntriesTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $ReportsTable reports = $ReportsTable(this);
  late final $ReportPhotosTable reportPhotos = $ReportPhotosTable(this);
  late final $ReportMaterialsTable reportMaterials = $ReportMaterialsTable(
    this,
  );
  late final $ReportSignaturesTable reportSignatures = $ReportSignaturesTable(
    this,
  );
  late final $UsageCountersTable usageCounters = $UsageCountersTable(this);
  late final Index reportsStatusIdx = Index(
    'reports_status_idx',
    'CREATE INDEX reports_status_idx ON reports (status)',
  );
  late final Index reportsCustomerIdIdx = Index(
    'reports_customer_id_idx',
    'CREATE INDEX reports_customer_id_idx ON reports (customer_id)',
  );
  late final Index reportsUpdatedAtIdx = Index(
    'reports_updated_at_idx',
    'CREATE INDEX reports_updated_at_idx ON reports (updated_at)',
  );
  late final Index reportsReportNumberIdx = Index(
    'reports_report_number_idx',
    'CREATE UNIQUE INDEX reports_report_number_idx ON reports (report_number)',
  );
  late final Index reportPhotosReportIdIdx = Index(
    'report_photos_report_id_idx',
    'CREATE INDEX report_photos_report_id_idx ON report_photos (report_id)',
  );
  late final Index reportPhotosReportCategoryOrderIdx = Index(
    'report_photos_report_category_order_idx',
    'CREATE INDEX report_photos_report_category_order_idx ON report_photos (report_id, category, sort_order)',
  );
  late final Index reportMaterialsReportIdIdx = Index(
    'report_materials_report_id_idx',
    'CREATE INDEX report_materials_report_id_idx ON report_materials (report_id)',
  );
  late final Index reportMaterialsReportOrderIdx = Index(
    'report_materials_report_order_idx',
    'CREATE INDEX report_materials_report_order_idx ON report_materials (report_id, sort_order)',
  );
  late final Index reportSignaturesReportIdIdx = Index(
    'report_signatures_report_id_idx',
    'CREATE INDEX report_signatures_report_id_idx ON report_signatures (report_id)',
  );
  late final Index reportSignaturesReportTypeIdx = Index(
    'report_signatures_report_type_idx',
    'CREATE UNIQUE INDEX report_signatures_report_type_idx ON report_signatures (report_id, signature_type)',
  );
  late final Index usageCountersYearMonthIdx = Index(
    'usage_counters_year_month_idx',
    'CREATE UNIQUE INDEX usage_counters_year_month_idx ON usage_counters (year, month)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    databaseMetadata,
    businessProfiles,
    appSettingsEntries,
    customers,
    reports,
    reportPhotos,
    reportMaterials,
    reportSignatures,
    usageCounters,
    reportsStatusIdx,
    reportsCustomerIdIdx,
    reportsUpdatedAtIdx,
    reportsReportNumberIdx,
    reportPhotosReportIdIdx,
    reportPhotosReportCategoryOrderIdx,
    reportMaterialsReportIdIdx,
    reportMaterialsReportOrderIdx,
    reportSignaturesReportIdIdx,
    reportSignaturesReportTypeIdx,
    usageCountersYearMonthIdx,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'customers',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reports', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'reports',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('report_photos', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'reports',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('report_materials', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'reports',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('report_signatures', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$DatabaseMetadataTableCreateCompanionBuilder =
    DatabaseMetadataCompanion Function({
      required String key,
      Value<String?> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$DatabaseMetadataTableUpdateCompanionBuilder =
    DatabaseMetadataCompanion Function({
      Value<String> key,
      Value<String?> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$DatabaseMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $DatabaseMetadataTable> {
  $$DatabaseMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DatabaseMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $DatabaseMetadataTable> {
  $$DatabaseMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DatabaseMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $DatabaseMetadataTable> {
  $$DatabaseMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DatabaseMetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DatabaseMetadataTable,
          DatabaseMetadataData,
          $$DatabaseMetadataTableFilterComposer,
          $$DatabaseMetadataTableOrderingComposer,
          $$DatabaseMetadataTableAnnotationComposer,
          $$DatabaseMetadataTableCreateCompanionBuilder,
          $$DatabaseMetadataTableUpdateCompanionBuilder,
          (
            DatabaseMetadataData,
            BaseReferences<
              _$AppDatabase,
              $DatabaseMetadataTable,
              DatabaseMetadataData
            >,
          ),
          DatabaseMetadataData,
          PrefetchHooks Function()
        > {
  $$DatabaseMetadataTableTableManager(
    _$AppDatabase db,
    $DatabaseMetadataTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DatabaseMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DatabaseMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DatabaseMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String?> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DatabaseMetadataCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                Value<String?> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DatabaseMetadataCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DatabaseMetadataTable, DatabaseMetadataData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $DatabaseMetadataTable,
                    DatabaseMetadataData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DatabaseMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DatabaseMetadataTable,
      DatabaseMetadataData,
      $$DatabaseMetadataTableFilterComposer,
      $$DatabaseMetadataTableOrderingComposer,
      $$DatabaseMetadataTableAnnotationComposer,
      $$DatabaseMetadataTableCreateCompanionBuilder,
      $$DatabaseMetadataTableUpdateCompanionBuilder,
      (
        DatabaseMetadataData,
        BaseReferences<
          _$AppDatabase,
          $DatabaseMetadataTable,
          DatabaseMetadataData
        >,
      ),
      DatabaseMetadataData,
      PrefetchHooks Function()
    >;
typedef $$BusinessProfilesTableCreateCompanionBuilder =
    BusinessProfilesCompanion Function({
      required String id,
      required String businessName,
      required String technicianName,
      Value<String?> email,
      Value<String?> phone,
      Value<String?> address,
      required String countryCode,
      required String currencyCode,
      required String localeCode,
      Value<String?> logoPath,
      Value<String?> taxLabel,
      Value<String?> taxNumber,
      Value<String> reportPrefix,
      Value<String?> defaultTerms,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$BusinessProfilesTableUpdateCompanionBuilder =
    BusinessProfilesCompanion Function({
      Value<String> id,
      Value<String> businessName,
      Value<String> technicianName,
      Value<String?> email,
      Value<String?> phone,
      Value<String?> address,
      Value<String> countryCode,
      Value<String> currencyCode,
      Value<String> localeCode,
      Value<String?> logoPath,
      Value<String?> taxLabel,
      Value<String?> taxNumber,
      Value<String> reportPrefix,
      Value<String?> defaultTerms,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$BusinessProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $BusinessProfilesTable> {
  $$BusinessProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get businessName => $composableBuilder(
    column: $table.businessName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get technicianName => $composableBuilder(
    column: $table.technicianName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localeCode => $composableBuilder(
    column: $table.localeCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taxLabel => $composableBuilder(
    column: $table.taxLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taxNumber => $composableBuilder(
    column: $table.taxNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reportPrefix => $composableBuilder(
    column: $table.reportPrefix,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultTerms => $composableBuilder(
    column: $table.defaultTerms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BusinessProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $BusinessProfilesTable> {
  $$BusinessProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get businessName => $composableBuilder(
    column: $table.businessName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get technicianName => $composableBuilder(
    column: $table.technicianName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localeCode => $composableBuilder(
    column: $table.localeCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taxLabel => $composableBuilder(
    column: $table.taxLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taxNumber => $composableBuilder(
    column: $table.taxNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reportPrefix => $composableBuilder(
    column: $table.reportPrefix,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultTerms => $composableBuilder(
    column: $table.defaultTerms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BusinessProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BusinessProfilesTable> {
  $$BusinessProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get businessName => $composableBuilder(
    column: $table.businessName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get technicianName => $composableBuilder(
    column: $table.technicianName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localeCode => $composableBuilder(
    column: $table.localeCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get logoPath =>
      $composableBuilder(column: $table.logoPath, builder: (column) => column);

  GeneratedColumn<String> get taxLabel =>
      $composableBuilder(column: $table.taxLabel, builder: (column) => column);

  GeneratedColumn<String> get taxNumber =>
      $composableBuilder(column: $table.taxNumber, builder: (column) => column);

  GeneratedColumn<String> get reportPrefix => $composableBuilder(
    column: $table.reportPrefix,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultTerms => $composableBuilder(
    column: $table.defaultTerms,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BusinessProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BusinessProfilesTable,
          BusinessProfileEntity,
          $$BusinessProfilesTableFilterComposer,
          $$BusinessProfilesTableOrderingComposer,
          $$BusinessProfilesTableAnnotationComposer,
          $$BusinessProfilesTableCreateCompanionBuilder,
          $$BusinessProfilesTableUpdateCompanionBuilder,
          (
            BusinessProfileEntity,
            BaseReferences<
              _$AppDatabase,
              $BusinessProfilesTable,
              BusinessProfileEntity
            >,
          ),
          BusinessProfileEntity,
          PrefetchHooks Function()
        > {
  $$BusinessProfilesTableTableManager(
    _$AppDatabase db,
    $BusinessProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BusinessProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BusinessProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BusinessProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> businessName = const Value.absent(),
                Value<String> technicianName = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String> countryCode = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<String> localeCode = const Value.absent(),
                Value<String?> logoPath = const Value.absent(),
                Value<String?> taxLabel = const Value.absent(),
                Value<String?> taxNumber = const Value.absent(),
                Value<String> reportPrefix = const Value.absent(),
                Value<String?> defaultTerms = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BusinessProfilesCompanion(
                id: id,
                businessName: businessName,
                technicianName: technicianName,
                email: email,
                phone: phone,
                address: address,
                countryCode: countryCode,
                currencyCode: currencyCode,
                localeCode: localeCode,
                logoPath: logoPath,
                taxLabel: taxLabel,
                taxNumber: taxNumber,
                reportPrefix: reportPrefix,
                defaultTerms: defaultTerms,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String businessName,
                required String technicianName,
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                required String countryCode,
                required String currencyCode,
                required String localeCode,
                Value<String?> logoPath = const Value.absent(),
                Value<String?> taxLabel = const Value.absent(),
                Value<String?> taxNumber = const Value.absent(),
                Value<String> reportPrefix = const Value.absent(),
                Value<String?> defaultTerms = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => BusinessProfilesCompanion.insert(
                id: id,
                businessName: businessName,
                technicianName: technicianName,
                email: email,
                phone: phone,
                address: address,
                countryCode: countryCode,
                currencyCode: currencyCode,
                localeCode: localeCode,
                logoPath: logoPath,
                taxLabel: taxLabel,
                taxNumber: taxNumber,
                reportPrefix: reportPrefix,
                defaultTerms: defaultTerms,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BusinessProfilesTable, BusinessProfileEntity>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $BusinessProfilesTable,
                    BusinessProfileEntity
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BusinessProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BusinessProfilesTable,
      BusinessProfileEntity,
      $$BusinessProfilesTableFilterComposer,
      $$BusinessProfilesTableOrderingComposer,
      $$BusinessProfilesTableAnnotationComposer,
      $$BusinessProfilesTableCreateCompanionBuilder,
      $$BusinessProfilesTableUpdateCompanionBuilder,
      (
        BusinessProfileEntity,
        BaseReferences<
          _$AppDatabase,
          $BusinessProfilesTable,
          BusinessProfileEntity
        >,
      ),
      BusinessProfileEntity,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsEntriesTableCreateCompanionBuilder =
    AppSettingsEntriesCompanion Function({
      required String id,
      Value<String> themeMode,
      Value<String> defaultReportType,
      Value<String> defaultPdfTemplate,
      Value<bool> hasCompletedOnboarding,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AppSettingsEntriesTableUpdateCompanionBuilder =
    AppSettingsEntriesCompanion Function({
      Value<String> id,
      Value<String> themeMode,
      Value<String> defaultReportType,
      Value<String> defaultPdfTemplate,
      Value<bool> hasCompletedOnboarding,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AppSettingsEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsEntriesTable> {
  $$AppSettingsEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultReportType => $composableBuilder(
    column: $table.defaultReportType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultPdfTemplate => $composableBuilder(
    column: $table.defaultPdfTemplate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasCompletedOnboarding => $composableBuilder(
    column: $table.hasCompletedOnboarding,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsEntriesTable> {
  $$AppSettingsEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultReportType => $composableBuilder(
    column: $table.defaultReportType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultPdfTemplate => $composableBuilder(
    column: $table.defaultPdfTemplate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasCompletedOnboarding => $composableBuilder(
    column: $table.hasCompletedOnboarding,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsEntriesTable> {
  $$AppSettingsEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<String> get defaultReportType => $composableBuilder(
    column: $table.defaultReportType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultPdfTemplate => $composableBuilder(
    column: $table.defaultPdfTemplate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasCompletedOnboarding => $composableBuilder(
    column: $table.hasCompletedOnboarding,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsEntriesTable,
          AppSettingsEntity,
          $$AppSettingsEntriesTableFilterComposer,
          $$AppSettingsEntriesTableOrderingComposer,
          $$AppSettingsEntriesTableAnnotationComposer,
          $$AppSettingsEntriesTableCreateCompanionBuilder,
          $$AppSettingsEntriesTableUpdateCompanionBuilder,
          (
            AppSettingsEntity,
            BaseReferences<
              _$AppDatabase,
              $AppSettingsEntriesTable,
              AppSettingsEntity
            >,
          ),
          AppSettingsEntity,
          PrefetchHooks Function()
        > {
  $$AppSettingsEntriesTableTableManager(
    _$AppDatabase db,
    $AppSettingsEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String> defaultReportType = const Value.absent(),
                Value<String> defaultPdfTemplate = const Value.absent(),
                Value<bool> hasCompletedOnboarding = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsEntriesCompanion(
                id: id,
                themeMode: themeMode,
                defaultReportType: defaultReportType,
                defaultPdfTemplate: defaultPdfTemplate,
                hasCompletedOnboarding: hasCompletedOnboarding,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> themeMode = const Value.absent(),
                Value<String> defaultReportType = const Value.absent(),
                Value<String> defaultPdfTemplate = const Value.absent(),
                Value<bool> hasCompletedOnboarding = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsEntriesCompanion.insert(
                id: id,
                themeMode: themeMode,
                defaultReportType: defaultReportType,
                defaultPdfTemplate: defaultPdfTemplate,
                hasCompletedOnboarding: hasCompletedOnboarding,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsEntriesTable, AppSettingsEntity>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $AppSettingsEntriesTable,
                    AppSettingsEntity
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsEntriesTable,
      AppSettingsEntity,
      $$AppSettingsEntriesTableFilterComposer,
      $$AppSettingsEntriesTableOrderingComposer,
      $$AppSettingsEntriesTableAnnotationComposer,
      $$AppSettingsEntriesTableCreateCompanionBuilder,
      $$AppSettingsEntriesTableUpdateCompanionBuilder,
      (
        AppSettingsEntity,
        BaseReferences<
          _$AppDatabase,
          $AppSettingsEntriesTable,
          AppSettingsEntity
        >,
      ),
      AppSettingsEntity,
      PrefetchHooks Function()
    >;
typedef $$CustomersTableCreateCompanionBuilder =
    CustomersCompanion Function({
      required String id,
      required String name,
      Value<String?> companyName,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> address,
      Value<String?> notes,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });
typedef $$CustomersTableUpdateCompanionBuilder =
    CustomersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> companyName,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> address,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });

final class $$CustomersTableReferences
    extends BaseReferences<_$AppDatabase, $CustomersTable, CustomerEntity> {
  $$CustomersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ReportsTable, List<ReportEntity>>
  _reportsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reports,
    aliasName: 'customers__id__reports__customer_id',
  );

  $$ReportsTableProcessedTableManager get reportsRefs {
    final manager = $$ReportsTableTableManager(
      $_db,
      $_db.reports,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_reportsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> reportsRefs(
    Expression<bool> Function($$ReportsTableFilterComposer f) f,
  ) {
    final $$ReportsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reports,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReportsTableFilterComposer(
            $db: $db,
            $table: $db.reports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  Expression<T> reportsRefs<T extends Object>(
    Expression<T> Function($$ReportsTableAnnotationComposer a) f,
  ) {
    final $$ReportsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reports,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReportsTableAnnotationComposer(
            $db: $db,
            $table: $db.reports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomersTable,
          CustomerEntity,
          $$CustomersTableFilterComposer,
          $$CustomersTableOrderingComposer,
          $$CustomersTableAnnotationComposer,
          $$CustomersTableCreateCompanionBuilder,
          $$CustomersTableUpdateCompanionBuilder,
          (CustomerEntity, $$CustomersTableReferences),
          CustomerEntity,
          PrefetchHooks Function({bool reportsRefs})
        > {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> companyName = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion(
                id: id,
                name: name,
                companyName: companyName,
                phone: phone,
                email: email,
                address: address,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> companyName = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion.insert(
                id: id,
                name: name,
                companyName: companyName,
                phone: phone,
                email: email,
                address: address,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CustomersTable, CustomerEntity>(table),
                  $$CustomersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({reportsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (reportsRefs) db.reports],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (reportsRefs)
                    await $_getPrefetchedData<
                      CustomerEntity,
                      $CustomersTable,
                      ReportEntity
                    >(
                      currentTable: table,
                      referencedTable: $$CustomersTableReferences
                          ._reportsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CustomersTableReferences(db, table, p0).reportsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.customerId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomersTable,
      CustomerEntity,
      $$CustomersTableFilterComposer,
      $$CustomersTableOrderingComposer,
      $$CustomersTableAnnotationComposer,
      $$CustomersTableCreateCompanionBuilder,
      $$CustomersTableUpdateCompanionBuilder,
      (CustomerEntity, $$CustomersTableReferences),
      CustomerEntity,
      PrefetchHooks Function({bool reportsRefs})
    >;
typedef $$ReportsTableCreateCompanionBuilder =
    ReportsCompanion Function({
      required String id,
      Value<String?> reportNumber,
      Value<String?> customerId,
      Value<String> reportType,
      Value<String> status,
      Value<String> title,
      Value<String?> siteAddress,
      Value<String?> equipmentName,
      Value<String?> equipmentManufacturer,
      Value<String?> equipmentModel,
      Value<String?> equipmentSerial,
      Value<String?> issueReported,
      Value<String?> diagnosis,
      Value<String> workPerformed,
      Value<String?> recommendations,
      Value<String?> internalNotes,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
      Value<DateTime?> finalizedAt,
      Value<String?> finalizedSnapshotJson,
      Value<String> pdfTemplateId,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });
typedef $$ReportsTableUpdateCompanionBuilder =
    ReportsCompanion Function({
      Value<String> id,
      Value<String?> reportNumber,
      Value<String?> customerId,
      Value<String> reportType,
      Value<String> status,
      Value<String> title,
      Value<String?> siteAddress,
      Value<String?> equipmentName,
      Value<String?> equipmentManufacturer,
      Value<String?> equipmentModel,
      Value<String?> equipmentSerial,
      Value<String?> issueReported,
      Value<String?> diagnosis,
      Value<String> workPerformed,
      Value<String?> recommendations,
      Value<String?> internalNotes,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
      Value<DateTime?> finalizedAt,
      Value<String?> finalizedSnapshotJson,
      Value<String> pdfTemplateId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });

final class $$ReportsTableReferences
    extends BaseReferences<_$AppDatabase, $ReportsTable, ReportEntity> {
  $$ReportsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias('reports__customer_id__customers__id');

  $$CustomersTableProcessedTableManager? get customerId {
    final $_column = $_itemColumn<String>('customer_id');
    if ($_column == null) return null;
    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ReportPhotosTable, List<ReportPhotoEntity>>
  _reportPhotosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reportPhotos,
    aliasName: 'reports__id__report_photos__report_id',
  );

  $$ReportPhotosTableProcessedTableManager get reportPhotosRefs {
    final manager = $$ReportPhotosTableTableManager(
      $_db,
      $_db.reportPhotos,
    ).filter((f) => f.reportId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_reportPhotosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReportMaterialsTable, List<ReportMaterialEntity>>
  _reportMaterialsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reportMaterials,
    aliasName: 'reports__id__report_materials__report_id',
  );

  $$ReportMaterialsTableProcessedTableManager get reportMaterialsRefs {
    final manager = $$ReportMaterialsTableTableManager(
      $_db,
      $_db.reportMaterials,
    ).filter((f) => f.reportId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _reportMaterialsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ReportSignaturesTable,
    List<ReportSignatureEntity>
  >
  _reportSignaturesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reportSignatures,
    aliasName: 'reports__id__report_signatures__report_id',
  );

  $$ReportSignaturesTableProcessedTableManager get reportSignaturesRefs {
    final manager = $$ReportSignaturesTableTableManager(
      $_db,
      $_db.reportSignatures,
    ).filter((f) => f.reportId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _reportSignaturesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ReportsTableFilterComposer
    extends Composer<_$AppDatabase, $ReportsTable> {
  $$ReportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reportNumber => $composableBuilder(
    column: $table.reportNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reportType => $composableBuilder(
    column: $table.reportType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get siteAddress => $composableBuilder(
    column: $table.siteAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipmentName => $composableBuilder(
    column: $table.equipmentName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipmentManufacturer => $composableBuilder(
    column: $table.equipmentManufacturer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipmentModel => $composableBuilder(
    column: $table.equipmentModel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipmentSerial => $composableBuilder(
    column: $table.equipmentSerial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get issueReported => $composableBuilder(
    column: $table.issueReported,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get diagnosis => $composableBuilder(
    column: $table.diagnosis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workPerformed => $composableBuilder(
    column: $table.workPerformed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recommendations => $composableBuilder(
    column: $table.recommendations,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get internalNotes => $composableBuilder(
    column: $table.internalNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finalizedAt => $composableBuilder(
    column: $table.finalizedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get finalizedSnapshotJson => $composableBuilder(
    column: $table.finalizedSnapshotJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pdfTemplateId => $composableBuilder(
    column: $table.pdfTemplateId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> reportPhotosRefs(
    Expression<bool> Function($$ReportPhotosTableFilterComposer f) f,
  ) {
    final $$ReportPhotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reportPhotos,
      getReferencedColumn: (t) => t.reportId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReportPhotosTableFilterComposer(
            $db: $db,
            $table: $db.reportPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> reportMaterialsRefs(
    Expression<bool> Function($$ReportMaterialsTableFilterComposer f) f,
  ) {
    final $$ReportMaterialsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reportMaterials,
      getReferencedColumn: (t) => t.reportId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReportMaterialsTableFilterComposer(
            $db: $db,
            $table: $db.reportMaterials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> reportSignaturesRefs(
    Expression<bool> Function($$ReportSignaturesTableFilterComposer f) f,
  ) {
    final $$ReportSignaturesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reportSignatures,
      getReferencedColumn: (t) => t.reportId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReportSignaturesTableFilterComposer(
            $db: $db,
            $table: $db.reportSignatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ReportsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReportsTable> {
  $$ReportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reportNumber => $composableBuilder(
    column: $table.reportNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reportType => $composableBuilder(
    column: $table.reportType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get siteAddress => $composableBuilder(
    column: $table.siteAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipmentName => $composableBuilder(
    column: $table.equipmentName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipmentManufacturer => $composableBuilder(
    column: $table.equipmentManufacturer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipmentModel => $composableBuilder(
    column: $table.equipmentModel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipmentSerial => $composableBuilder(
    column: $table.equipmentSerial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get issueReported => $composableBuilder(
    column: $table.issueReported,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diagnosis => $composableBuilder(
    column: $table.diagnosis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workPerformed => $composableBuilder(
    column: $table.workPerformed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recommendations => $composableBuilder(
    column: $table.recommendations,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get internalNotes => $composableBuilder(
    column: $table.internalNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finalizedAt => $composableBuilder(
    column: $table.finalizedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get finalizedSnapshotJson => $composableBuilder(
    column: $table.finalizedSnapshotJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pdfTemplateId => $composableBuilder(
    column: $table.pdfTemplateId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReportsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReportsTable> {
  $$ReportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get reportNumber => $composableBuilder(
    column: $table.reportNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reportType => $composableBuilder(
    column: $table.reportType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get siteAddress => $composableBuilder(
    column: $table.siteAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get equipmentName => $composableBuilder(
    column: $table.equipmentName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get equipmentManufacturer => $composableBuilder(
    column: $table.equipmentManufacturer,
    builder: (column) => column,
  );

  GeneratedColumn<String> get equipmentModel => $composableBuilder(
    column: $table.equipmentModel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get equipmentSerial => $composableBuilder(
    column: $table.equipmentSerial,
    builder: (column) => column,
  );

  GeneratedColumn<String> get issueReported => $composableBuilder(
    column: $table.issueReported,
    builder: (column) => column,
  );

  GeneratedColumn<String> get diagnosis =>
      $composableBuilder(column: $table.diagnosis, builder: (column) => column);

  GeneratedColumn<String> get workPerformed => $composableBuilder(
    column: $table.workPerformed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recommendations => $composableBuilder(
    column: $table.recommendations,
    builder: (column) => column,
  );

  GeneratedColumn<String> get internalNotes => $composableBuilder(
    column: $table.internalNotes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get finalizedAt => $composableBuilder(
    column: $table.finalizedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get finalizedSnapshotJson => $composableBuilder(
    column: $table.finalizedSnapshotJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pdfTemplateId => $composableBuilder(
    column: $table.pdfTemplateId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> reportPhotosRefs<T extends Object>(
    Expression<T> Function($$ReportPhotosTableAnnotationComposer a) f,
  ) {
    final $$ReportPhotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reportPhotos,
      getReferencedColumn: (t) => t.reportId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReportPhotosTableAnnotationComposer(
            $db: $db,
            $table: $db.reportPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> reportMaterialsRefs<T extends Object>(
    Expression<T> Function($$ReportMaterialsTableAnnotationComposer a) f,
  ) {
    final $$ReportMaterialsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reportMaterials,
      getReferencedColumn: (t) => t.reportId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReportMaterialsTableAnnotationComposer(
            $db: $db,
            $table: $db.reportMaterials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> reportSignaturesRefs<T extends Object>(
    Expression<T> Function($$ReportSignaturesTableAnnotationComposer a) f,
  ) {
    final $$ReportSignaturesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reportSignatures,
      getReferencedColumn: (t) => t.reportId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReportSignaturesTableAnnotationComposer(
            $db: $db,
            $table: $db.reportSignatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ReportsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReportsTable,
          ReportEntity,
          $$ReportsTableFilterComposer,
          $$ReportsTableOrderingComposer,
          $$ReportsTableAnnotationComposer,
          $$ReportsTableCreateCompanionBuilder,
          $$ReportsTableUpdateCompanionBuilder,
          (ReportEntity, $$ReportsTableReferences),
          ReportEntity,
          PrefetchHooks Function({
            bool customerId,
            bool reportPhotosRefs,
            bool reportMaterialsRefs,
            bool reportSignaturesRefs,
          })
        > {
  $$ReportsTableTableManager(_$AppDatabase db, $ReportsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> reportNumber = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                Value<String> reportType = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> siteAddress = const Value.absent(),
                Value<String?> equipmentName = const Value.absent(),
                Value<String?> equipmentManufacturer = const Value.absent(),
                Value<String?> equipmentModel = const Value.absent(),
                Value<String?> equipmentSerial = const Value.absent(),
                Value<String?> issueReported = const Value.absent(),
                Value<String?> diagnosis = const Value.absent(),
                Value<String> workPerformed = const Value.absent(),
                Value<String?> recommendations = const Value.absent(),
                Value<String?> internalNotes = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime?> finalizedAt = const Value.absent(),
                Value<String?> finalizedSnapshotJson = const Value.absent(),
                Value<String> pdfTemplateId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReportsCompanion(
                id: id,
                reportNumber: reportNumber,
                customerId: customerId,
                reportType: reportType,
                status: status,
                title: title,
                siteAddress: siteAddress,
                equipmentName: equipmentName,
                equipmentManufacturer: equipmentManufacturer,
                equipmentModel: equipmentModel,
                equipmentSerial: equipmentSerial,
                issueReported: issueReported,
                diagnosis: diagnosis,
                workPerformed: workPerformed,
                recommendations: recommendations,
                internalNotes: internalNotes,
                startedAt: startedAt,
                completedAt: completedAt,
                finalizedAt: finalizedAt,
                finalizedSnapshotJson: finalizedSnapshotJson,
                pdfTemplateId: pdfTemplateId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> reportNumber = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                Value<String> reportType = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> siteAddress = const Value.absent(),
                Value<String?> equipmentName = const Value.absent(),
                Value<String?> equipmentManufacturer = const Value.absent(),
                Value<String?> equipmentModel = const Value.absent(),
                Value<String?> equipmentSerial = const Value.absent(),
                Value<String?> issueReported = const Value.absent(),
                Value<String?> diagnosis = const Value.absent(),
                Value<String> workPerformed = const Value.absent(),
                Value<String?> recommendations = const Value.absent(),
                Value<String?> internalNotes = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime?> finalizedAt = const Value.absent(),
                Value<String?> finalizedSnapshotJson = const Value.absent(),
                Value<String> pdfTemplateId = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReportsCompanion.insert(
                id: id,
                reportNumber: reportNumber,
                customerId: customerId,
                reportType: reportType,
                status: status,
                title: title,
                siteAddress: siteAddress,
                equipmentName: equipmentName,
                equipmentManufacturer: equipmentManufacturer,
                equipmentModel: equipmentModel,
                equipmentSerial: equipmentSerial,
                issueReported: issueReported,
                diagnosis: diagnosis,
                workPerformed: workPerformed,
                recommendations: recommendations,
                internalNotes: internalNotes,
                startedAt: startedAt,
                completedAt: completedAt,
                finalizedAt: finalizedAt,
                finalizedSnapshotJson: finalizedSnapshotJson,
                pdfTemplateId: pdfTemplateId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReportsTable, ReportEntity>(table),
                  $$ReportsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                customerId = false,
                reportPhotosRefs = false,
                reportMaterialsRefs = false,
                reportSignaturesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (reportPhotosRefs) db.reportPhotos,
                    if (reportMaterialsRefs) db.reportMaterials,
                    if (reportSignaturesRefs) db.reportSignatures,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (customerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.customerId,
                                    referencedTable: $$ReportsTableReferences
                                        ._customerIdTable(db),
                                    referencedColumn: $$ReportsTableReferences
                                        ._customerIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (reportPhotosRefs)
                        await $_getPrefetchedData<
                          ReportEntity,
                          $ReportsTable,
                          ReportPhotoEntity
                        >(
                          currentTable: table,
                          referencedTable: $$ReportsTableReferences
                              ._reportPhotosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ReportsTableReferences(
                                db,
                                table,
                                p0,
                              ).reportPhotosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.reportId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (reportMaterialsRefs)
                        await $_getPrefetchedData<
                          ReportEntity,
                          $ReportsTable,
                          ReportMaterialEntity
                        >(
                          currentTable: table,
                          referencedTable: $$ReportsTableReferences
                              ._reportMaterialsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ReportsTableReferences(
                                db,
                                table,
                                p0,
                              ).reportMaterialsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.reportId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (reportSignaturesRefs)
                        await $_getPrefetchedData<
                          ReportEntity,
                          $ReportsTable,
                          ReportSignatureEntity
                        >(
                          currentTable: table,
                          referencedTable: $$ReportsTableReferences
                              ._reportSignaturesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ReportsTableReferences(
                                db,
                                table,
                                p0,
                              ).reportSignaturesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.reportId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ReportsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReportsTable,
      ReportEntity,
      $$ReportsTableFilterComposer,
      $$ReportsTableOrderingComposer,
      $$ReportsTableAnnotationComposer,
      $$ReportsTableCreateCompanionBuilder,
      $$ReportsTableUpdateCompanionBuilder,
      (ReportEntity, $$ReportsTableReferences),
      ReportEntity,
      PrefetchHooks Function({
        bool customerId,
        bool reportPhotosRefs,
        bool reportMaterialsRefs,
        bool reportSignaturesRefs,
      })
    >;
typedef $$ReportPhotosTableCreateCompanionBuilder =
    ReportPhotosCompanion Function({
      required String id,
      required String reportId,
      required String filePath,
      Value<String?> thumbnailPath,
      required String category,
      Value<String?> caption,
      required int sortOrder,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ReportPhotosTableUpdateCompanionBuilder =
    ReportPhotosCompanion Function({
      Value<String> id,
      Value<String> reportId,
      Value<String> filePath,
      Value<String?> thumbnailPath,
      Value<String> category,
      Value<String?> caption,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$ReportPhotosTableReferences
    extends
        BaseReferences<_$AppDatabase, $ReportPhotosTable, ReportPhotoEntity> {
  $$ReportPhotosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ReportsTable _reportIdTable(_$AppDatabase db) =>
      db.reports.createAlias('report_photos__report_id__reports__id');

  $$ReportsTableProcessedTableManager get reportId {
    final $_column = $_itemColumn<String>('report_id')!;

    final manager = $$ReportsTableTableManager(
      $_db,
      $_db.reports,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_reportIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReportPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $ReportPhotosTable> {
  $$ReportPhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ReportsTableFilterComposer get reportId {
    final $$ReportsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reportId,
      referencedTable: $db.reports,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReportsTableFilterComposer(
            $db: $db,
            $table: $db.reports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReportPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $ReportPhotosTable> {
  $$ReportPhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ReportsTableOrderingComposer get reportId {
    final $$ReportsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reportId,
      referencedTable: $db.reports,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReportsTableOrderingComposer(
            $db: $db,
            $table: $db.reports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReportPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReportPhotosTable> {
  $$ReportPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ReportsTableAnnotationComposer get reportId {
    final $$ReportsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reportId,
      referencedTable: $db.reports,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReportsTableAnnotationComposer(
            $db: $db,
            $table: $db.reports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReportPhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReportPhotosTable,
          ReportPhotoEntity,
          $$ReportPhotosTableFilterComposer,
          $$ReportPhotosTableOrderingComposer,
          $$ReportPhotosTableAnnotationComposer,
          $$ReportPhotosTableCreateCompanionBuilder,
          $$ReportPhotosTableUpdateCompanionBuilder,
          (ReportPhotoEntity, $$ReportPhotosTableReferences),
          ReportPhotoEntity,
          PrefetchHooks Function({bool reportId})
        > {
  $$ReportPhotosTableTableManager(_$AppDatabase db, $ReportPhotosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReportPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReportPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReportPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> reportId = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> caption = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReportPhotosCompanion(
                id: id,
                reportId: reportId,
                filePath: filePath,
                thumbnailPath: thumbnailPath,
                category: category,
                caption: caption,
                sortOrder: sortOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String reportId,
                required String filePath,
                Value<String?> thumbnailPath = const Value.absent(),
                required String category,
                Value<String?> caption = const Value.absent(),
                required int sortOrder,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ReportPhotosCompanion.insert(
                id: id,
                reportId: reportId,
                filePath: filePath,
                thumbnailPath: thumbnailPath,
                category: category,
                caption: caption,
                sortOrder: sortOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReportPhotosTable, ReportPhotoEntity>(table),
                  $$ReportPhotosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({reportId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (reportId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.reportId,
                                referencedTable: $$ReportPhotosTableReferences
                                    ._reportIdTable(db),
                                referencedColumn: $$ReportPhotosTableReferences
                                    ._reportIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReportPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReportPhotosTable,
      ReportPhotoEntity,
      $$ReportPhotosTableFilterComposer,
      $$ReportPhotosTableOrderingComposer,
      $$ReportPhotosTableAnnotationComposer,
      $$ReportPhotosTableCreateCompanionBuilder,
      $$ReportPhotosTableUpdateCompanionBuilder,
      (ReportPhotoEntity, $$ReportPhotosTableReferences),
      ReportPhotoEntity,
      PrefetchHooks Function({bool reportId})
    >;
typedef $$ReportMaterialsTableCreateCompanionBuilder =
    ReportMaterialsCompanion Function({
      required String id,
      required String reportId,
      required String name,
      required double quantity,
      Value<String?> unit,
      Value<String?> notes,
      required int sortOrder,
      Value<int> rowid,
    });
typedef $$ReportMaterialsTableUpdateCompanionBuilder =
    ReportMaterialsCompanion Function({
      Value<String> id,
      Value<String> reportId,
      Value<String> name,
      Value<double> quantity,
      Value<String?> unit,
      Value<String?> notes,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$ReportMaterialsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ReportMaterialsTable,
          ReportMaterialEntity
        > {
  $$ReportMaterialsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ReportsTable _reportIdTable(_$AppDatabase db) =>
      db.reports.createAlias('report_materials__report_id__reports__id');

  $$ReportsTableProcessedTableManager get reportId {
    final $_column = $_itemColumn<String>('report_id')!;

    final manager = $$ReportsTableTableManager(
      $_db,
      $_db.reports,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_reportIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReportMaterialsTableFilterComposer
    extends Composer<_$AppDatabase, $ReportMaterialsTable> {
  $$ReportMaterialsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$ReportsTableFilterComposer get reportId {
    final $$ReportsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reportId,
      referencedTable: $db.reports,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReportsTableFilterComposer(
            $db: $db,
            $table: $db.reports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReportMaterialsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReportMaterialsTable> {
  $$ReportMaterialsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$ReportsTableOrderingComposer get reportId {
    final $$ReportsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reportId,
      referencedTable: $db.reports,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReportsTableOrderingComposer(
            $db: $db,
            $table: $db.reports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReportMaterialsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReportMaterialsTable> {
  $$ReportMaterialsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$ReportsTableAnnotationComposer get reportId {
    final $$ReportsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reportId,
      referencedTable: $db.reports,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReportsTableAnnotationComposer(
            $db: $db,
            $table: $db.reports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReportMaterialsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReportMaterialsTable,
          ReportMaterialEntity,
          $$ReportMaterialsTableFilterComposer,
          $$ReportMaterialsTableOrderingComposer,
          $$ReportMaterialsTableAnnotationComposer,
          $$ReportMaterialsTableCreateCompanionBuilder,
          $$ReportMaterialsTableUpdateCompanionBuilder,
          (ReportMaterialEntity, $$ReportMaterialsTableReferences),
          ReportMaterialEntity,
          PrefetchHooks Function({bool reportId})
        > {
  $$ReportMaterialsTableTableManager(
    _$AppDatabase db,
    $ReportMaterialsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReportMaterialsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReportMaterialsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReportMaterialsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> reportId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReportMaterialsCompanion(
                id: id,
                reportId: reportId,
                name: name,
                quantity: quantity,
                unit: unit,
                notes: notes,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String reportId,
                required String name,
                required double quantity,
                Value<String?> unit = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => ReportMaterialsCompanion.insert(
                id: id,
                reportId: reportId,
                name: name,
                quantity: quantity,
                unit: unit,
                notes: notes,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReportMaterialsTable, ReportMaterialEntity>(
                    table,
                  ),
                  $$ReportMaterialsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({reportId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (reportId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.reportId,
                                referencedTable:
                                    $$ReportMaterialsTableReferences
                                        ._reportIdTable(db),
                                referencedColumn:
                                    $$ReportMaterialsTableReferences
                                        ._reportIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReportMaterialsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReportMaterialsTable,
      ReportMaterialEntity,
      $$ReportMaterialsTableFilterComposer,
      $$ReportMaterialsTableOrderingComposer,
      $$ReportMaterialsTableAnnotationComposer,
      $$ReportMaterialsTableCreateCompanionBuilder,
      $$ReportMaterialsTableUpdateCompanionBuilder,
      (ReportMaterialEntity, $$ReportMaterialsTableReferences),
      ReportMaterialEntity,
      PrefetchHooks Function({bool reportId})
    >;
typedef $$ReportSignaturesTableCreateCompanionBuilder =
    ReportSignaturesCompanion Function({
      required String id,
      required String reportId,
      required String signatureType,
      required String signerName,
      required String filePath,
      required DateTime signedAt,
      Value<int> rowid,
    });
typedef $$ReportSignaturesTableUpdateCompanionBuilder =
    ReportSignaturesCompanion Function({
      Value<String> id,
      Value<String> reportId,
      Value<String> signatureType,
      Value<String> signerName,
      Value<String> filePath,
      Value<DateTime> signedAt,
      Value<int> rowid,
    });

final class $$ReportSignaturesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ReportSignaturesTable,
          ReportSignatureEntity
        > {
  $$ReportSignaturesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ReportsTable _reportIdTable(_$AppDatabase db) =>
      db.reports.createAlias('report_signatures__report_id__reports__id');

  $$ReportsTableProcessedTableManager get reportId {
    final $_column = $_itemColumn<String>('report_id')!;

    final manager = $$ReportsTableTableManager(
      $_db,
      $_db.reports,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_reportIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReportSignaturesTableFilterComposer
    extends Composer<_$AppDatabase, $ReportSignaturesTable> {
  $$ReportSignaturesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get signatureType => $composableBuilder(
    column: $table.signatureType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get signerName => $composableBuilder(
    column: $table.signerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get signedAt => $composableBuilder(
    column: $table.signedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ReportsTableFilterComposer get reportId {
    final $$ReportsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reportId,
      referencedTable: $db.reports,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReportsTableFilterComposer(
            $db: $db,
            $table: $db.reports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReportSignaturesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReportSignaturesTable> {
  $$ReportSignaturesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get signatureType => $composableBuilder(
    column: $table.signatureType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get signerName => $composableBuilder(
    column: $table.signerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get signedAt => $composableBuilder(
    column: $table.signedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ReportsTableOrderingComposer get reportId {
    final $$ReportsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reportId,
      referencedTable: $db.reports,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReportsTableOrderingComposer(
            $db: $db,
            $table: $db.reports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReportSignaturesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReportSignaturesTable> {
  $$ReportSignaturesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get signatureType => $composableBuilder(
    column: $table.signatureType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get signerName => $composableBuilder(
    column: $table.signerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<DateTime> get signedAt =>
      $composableBuilder(column: $table.signedAt, builder: (column) => column);

  $$ReportsTableAnnotationComposer get reportId {
    final $$ReportsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reportId,
      referencedTable: $db.reports,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReportsTableAnnotationComposer(
            $db: $db,
            $table: $db.reports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReportSignaturesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReportSignaturesTable,
          ReportSignatureEntity,
          $$ReportSignaturesTableFilterComposer,
          $$ReportSignaturesTableOrderingComposer,
          $$ReportSignaturesTableAnnotationComposer,
          $$ReportSignaturesTableCreateCompanionBuilder,
          $$ReportSignaturesTableUpdateCompanionBuilder,
          (ReportSignatureEntity, $$ReportSignaturesTableReferences),
          ReportSignatureEntity,
          PrefetchHooks Function({bool reportId})
        > {
  $$ReportSignaturesTableTableManager(
    _$AppDatabase db,
    $ReportSignaturesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReportSignaturesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReportSignaturesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReportSignaturesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> reportId = const Value.absent(),
                Value<String> signatureType = const Value.absent(),
                Value<String> signerName = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<DateTime> signedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReportSignaturesCompanion(
                id: id,
                reportId: reportId,
                signatureType: signatureType,
                signerName: signerName,
                filePath: filePath,
                signedAt: signedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String reportId,
                required String signatureType,
                required String signerName,
                required String filePath,
                required DateTime signedAt,
                Value<int> rowid = const Value.absent(),
              }) => ReportSignaturesCompanion.insert(
                id: id,
                reportId: reportId,
                signatureType: signatureType,
                signerName: signerName,
                filePath: filePath,
                signedAt: signedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReportSignaturesTable, ReportSignatureEntity>(
                    table,
                  ),
                  $$ReportSignaturesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({reportId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (reportId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.reportId,
                                referencedTable:
                                    $$ReportSignaturesTableReferences
                                        ._reportIdTable(db),
                                referencedColumn:
                                    $$ReportSignaturesTableReferences
                                        ._reportIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReportSignaturesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReportSignaturesTable,
      ReportSignatureEntity,
      $$ReportSignaturesTableFilterComposer,
      $$ReportSignaturesTableOrderingComposer,
      $$ReportSignaturesTableAnnotationComposer,
      $$ReportSignaturesTableCreateCompanionBuilder,
      $$ReportSignaturesTableUpdateCompanionBuilder,
      (ReportSignatureEntity, $$ReportSignaturesTableReferences),
      ReportSignatureEntity,
      PrefetchHooks Function({bool reportId})
    >;
typedef $$UsageCountersTableCreateCompanionBuilder =
    UsageCountersCompanion Function({
      required String id,
      required int year,
      required int month,
      Value<int> finalizedReportCount,
      Value<int> rowid,
    });
typedef $$UsageCountersTableUpdateCompanionBuilder =
    UsageCountersCompanion Function({
      Value<String> id,
      Value<int> year,
      Value<int> month,
      Value<int> finalizedReportCount,
      Value<int> rowid,
    });

class $$UsageCountersTableFilterComposer
    extends Composer<_$AppDatabase, $UsageCountersTable> {
  $$UsageCountersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get finalizedReportCount => $composableBuilder(
    column: $table.finalizedReportCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsageCountersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsageCountersTable> {
  $$UsageCountersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get finalizedReportCount => $composableBuilder(
    column: $table.finalizedReportCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsageCountersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsageCountersTable> {
  $$UsageCountersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get finalizedReportCount => $composableBuilder(
    column: $table.finalizedReportCount,
    builder: (column) => column,
  );
}

class $$UsageCountersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsageCountersTable,
          UsageCounterEntity,
          $$UsageCountersTableFilterComposer,
          $$UsageCountersTableOrderingComposer,
          $$UsageCountersTableAnnotationComposer,
          $$UsageCountersTableCreateCompanionBuilder,
          $$UsageCountersTableUpdateCompanionBuilder,
          (
            UsageCounterEntity,
            BaseReferences<
              _$AppDatabase,
              $UsageCountersTable,
              UsageCounterEntity
            >,
          ),
          UsageCounterEntity,
          PrefetchHooks Function()
        > {
  $$UsageCountersTableTableManager(_$AppDatabase db, $UsageCountersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsageCountersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsageCountersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsageCountersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<int> month = const Value.absent(),
                Value<int> finalizedReportCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsageCountersCompanion(
                id: id,
                year: year,
                month: month,
                finalizedReportCount: finalizedReportCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int year,
                required int month,
                Value<int> finalizedReportCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsageCountersCompanion.insert(
                id: id,
                year: year,
                month: month,
                finalizedReportCount: finalizedReportCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UsageCountersTable, UsageCounterEntity>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $UsageCountersTable,
                    UsageCounterEntity
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsageCountersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsageCountersTable,
      UsageCounterEntity,
      $$UsageCountersTableFilterComposer,
      $$UsageCountersTableOrderingComposer,
      $$UsageCountersTableAnnotationComposer,
      $$UsageCountersTableCreateCompanionBuilder,
      $$UsageCountersTableUpdateCompanionBuilder,
      (
        UsageCounterEntity,
        BaseReferences<_$AppDatabase, $UsageCountersTable, UsageCounterEntity>,
      ),
      UsageCounterEntity,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DatabaseMetadataTableTableManager get databaseMetadata =>
      $$DatabaseMetadataTableTableManager(_db, _db.databaseMetadata);
  $$BusinessProfilesTableTableManager get businessProfiles =>
      $$BusinessProfilesTableTableManager(_db, _db.businessProfiles);
  $$AppSettingsEntriesTableTableManager get appSettingsEntries =>
      $$AppSettingsEntriesTableTableManager(_db, _db.appSettingsEntries);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$ReportsTableTableManager get reports =>
      $$ReportsTableTableManager(_db, _db.reports);
  $$ReportPhotosTableTableManager get reportPhotos =>
      $$ReportPhotosTableTableManager(_db, _db.reportPhotos);
  $$ReportMaterialsTableTableManager get reportMaterials =>
      $$ReportMaterialsTableTableManager(_db, _db.reportMaterials);
  $$ReportSignaturesTableTableManager get reportSignatures =>
      $$ReportSignaturesTableTableManager(_db, _db.reportSignatures);
  $$UsageCountersTableTableManager get usageCounters =>
      $$UsageCountersTableTableManager(_db, _db.usageCounters);
}
