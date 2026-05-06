import 'package:local_auth/local_auth.dart';

enum BiometricErrorCode {
  noBiometricHardware,  // Tidak ada sensor biometrik di perangkat
  notEnrolled,          // Sensor ada, tapi belum ada data sidik jari/wajah terdaftar
  temporaryLockout,     // Terkunci sementara (terlalu banyak percobaan gagal)
  biometricLockout,     // Terkunci permanen (butuh buka kunci perangkat dengan PIN dulu)
  userCanceled,         // User menekan tombol Batal
  systemCanceled,       // Sistem membatalkan (mis. ada telepon masuk)
  unknown,
}

class BiometricException implements Exception {
  final BiometricErrorCode code;    // kategori error
  final String message;             // pesan teknis (untuk debugging/log)
  final String userMessage;         // pesan untuk ditampilkan ke user

  BiometricException({
    required this.code,
    required this.message,
    required this.userMessage,
  });

  // Constructor dari LocalAuthException (konversi error OS → custom model)
  factory BiometricException.fromLocalAuthException(LocalAuthException e) {
    switch (e.code) {
      case LocalAuthExceptionCode.noHardware:
        return BiometricException(
          code: BiometricErrorCode.noBiometricHardware,
          message: e.message,
          userMessage: 'Perangkat tidak memiliki sensor biometrik.',
        );
      case LocalAuthExceptionCode.notEnrolled:
        return BiometricException(
          code: BiometricErrorCode.notEnrolled,
          message: e.message,
          userMessage: 'Belum ada sidik jari tersimpan. Daftarkan di Pengaturan.',
        );
      case LocalAuthExceptionCode.lockedOut:
        return BiometricException(
          code: BiometricErrorCode.temporaryLockout,
          message: e.message,
          userMessage: 'Terlalu banyak percobaan. Coba lagi nanti.',
        );
      case LocalAuthExceptionCode.permanentlyLockedOut:
        return BiometricException(
          code: BiometricErrorCode.biometricLockout,
          message: e.message,
          userMessage: 'Sensor terkunci permanen. Buka dengan PIN/Password.',
        );
      default:
        return BiometricException(
          code: BiometricErrorCode.unknown,
          message: e.message,
          userMessage: 'Terjadi kesalahan biometrik yang tidak diketahui.',
        );
    }
  }

  // Tampilkan tombol "Coba Lagi"?
  bool get isRetryable => code == BiometricErrorCode.userCanceled ||
      code == BiometricErrorCode.systemCanceled ||
      code == BiometricErrorCode.unknown;
  // Tampilkan tombol "Buka Pengaturan"?
  bool get requiresSettings => code == BiometricErrorCode.notEnrolled;
  // Otomatis pindah ke form password?
  bool get requiresFallback => code == BiometricErrorCode.noBiometricHardware ||
      code == BiometricErrorCode.biometricLockout;
}