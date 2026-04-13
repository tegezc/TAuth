// lib/src/core/error/exceptions.dart

class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Terjadi kesalahan pada server']);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Terjadi kesalahan pada penyimpanan lokal']);
}