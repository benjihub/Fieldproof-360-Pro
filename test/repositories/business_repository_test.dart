import 'package:fieldproof_360/features/business/data/repositories/drift_business_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_data.dart';

void main() {
  test(
    'saves, loads, watches, and updates the single business profile',
    () async {
      final database = createTestDatabase();
      addTearDown(database.close);
      final repository = DriftBusinessRepository(database);

      final saved = await repository.saveBusinessProfile(createTestProfile());
      expect(saved.businessName, 'Ben Electrical Services');
      expect(await repository.hasBusinessProfile(), isTrue);
      expect((await repository.getBusinessProfile())?.currencyCode, 'UGX');

      final watched = repository.watchBusinessProfile().firstWhere(
        (profile) => profile?.businessName == 'BenatTech Field Services',
      );
      final updated = createTestProfile(
        id: saved.id,
        businessName: 'BenatTech Field Services',
      );
      await repository.saveBusinessProfile(updated);

      expect((await watched)?.businessName, 'BenatTech Field Services');
      expect((await repository.getBusinessProfile())?.id, saved.id);
    },
  );
}
