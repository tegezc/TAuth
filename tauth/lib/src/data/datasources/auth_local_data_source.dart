// file: lib/src/data/datasources/auth_local_data_source.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/error/exceptions.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheData(String key, String value);
  Future<void> clearAllData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSourceImpl(this.secureStorage);

  @override
  Future<void> cacheData(String key, String value) async {
    try {
      await secureStorage.write(key: key, value: value);
    } catch (e) {
      throw CacheException('Gagal menyimpan data lokal terenkripsi.');
    }
  }

  @override
  Future<void> clearAllData() async {
    try {
      await secureStorage.deleteAll();
    } catch (e) {
      throw CacheException('Gagal menghapus data lokal.');
    }
  }
}