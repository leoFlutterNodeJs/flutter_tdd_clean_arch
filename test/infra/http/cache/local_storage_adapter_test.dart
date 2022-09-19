import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:tdd_clean_arch/data/cache/cache.dart';

class LocalStorageAdapter implements SaveSecureCacheStorage {
  final FlutterSecureStorage secureStorage;

  LocalStorageAdapter({required this.secureStorage});

  @override
  Future<void>? saveSecure({required String key, required String value}) async {
    await secureStorage.write(key: key, value: value);
  }
}

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {
  FlutterSecureStorageSpy() {
    When mockDeleteCall() => when(() => delete(key: any(named: 'key')));
    void mockDelete() => mockDeleteCall().thenAnswer((_) async => _);
    When mockSaveCall() => when(() => write(key: any(named: 'key'), value: any(named: 'value')));
    void mockSave() =>mockSaveCall().thenAnswer((_) async => _);

    mockDelete();
    mockSave();
  }
}

void main() {
  test('Should call save secure with correct values', () async {
    final key = faker.lorem.word();
    final value = faker.guid.guid();
    final secureStorage = FlutterSecureStorageSpy();
    final sut = LocalStorageAdapter(secureStorage: secureStorage);
    await sut.saveSecure(key: key, value: value);
    verify(() => secureStorage.write(key: key, value: value));
  });
}