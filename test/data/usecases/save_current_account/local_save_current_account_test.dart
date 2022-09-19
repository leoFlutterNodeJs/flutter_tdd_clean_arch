import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_clean_arch/domain/helpers/helpers.dart';
import 'package:test/test.dart';

import 'package:tdd_clean_arch/domain/usecases/usecases.dart';
import 'package:tdd_clean_arch/domain/entities/entities.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({required this.saveSecureCacheStorage});

  @override
  Future<void>? save(AccountEntity account) async {
    try {
      await saveSecureCacheStorage.saveSecure(key: 'token', value: account.token);
    } catch(error) {
      throw DomainError.unexpected;
    }
  }
}

abstract class SaveSecureCacheStorage {
  Future<void>? saveSecure({required String key, required String value});
}

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {}

void main() {
  late SaveSecureCacheStorageSpy saveSecureCacheStorage;
  late LocalSaveCurrentAccount sut;
  late AccountEntity account;

  void mockError() {
    when(() => saveSecureCacheStorage.saveSecure(key: any(named: 'key'), value: any(named: 'value')))
    .thenThrow(Exception());
  }

  setUp(() {
    saveSecureCacheStorage = SaveSecureCacheStorageSpy();
    sut = LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    account = AccountEntity(faker.guid.guid());
  });

  test('Should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(account);
    verify(() => saveSecureCacheStorage.saveSecure(key: 'token', value: account.token));
  });

  test('Should throw UnexpectedError if SaveSecureCacheStorage throws', () async {
    mockError();
    final future = sut.save(account);
    expect(future, throwsA(DomainError.unexpected));
  });
}