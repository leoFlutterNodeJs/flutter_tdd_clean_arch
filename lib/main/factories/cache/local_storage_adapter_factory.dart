import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:tdd_clean_arch/infra/cache/local_storage_adapter.dart';

LocalStorageAdapter makeLocalStorageAdapter() {
  const secureStorage = FlutterSecureStorage();
  return LocalStorageAdapter(secureStorage: secureStorage);
}