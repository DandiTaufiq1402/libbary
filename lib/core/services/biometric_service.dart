import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'biometric_exception.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isBiometricAvailable() async {
    final bool canCheck = await _auth.canCheckBiometrics;
    // Ada sensor?
    final bool isSupported = await _auth.isDeviceSupported(); // Device mendukung?
    return canCheck && isSupported;
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    return await _auth.getAvailableBiometrics();
    // Mengembalikan list: [BiometricType.fingerprint, BiometricType.face, ...]
  }

  Future<bool> authenticate({String reason = 'Verifikasi dibutuhkan'}) async {
    try {
      // 1. Pre-check: apakah hardware tersedia?
      final bool available = await isBiometricAvailable();
      if (!available) throw BiometricException(
        code: BiometricErrorCode.noBiometricHardware,
        message: 'No hardware',
        userMessage: 'Perangkat tidak memiliki sensor biometrik.',
      );

      // 2. Pre-check: apakah sudah ada biometrik terdaftar?
      final List<BiometricType> types = await getAvailableBiometrics();
      if (types.isEmpty) throw BiometricException(
        code: BiometricErrorCode.notEnrolled,
        message: 'Not enrolled',
        userMessage: 'Belum ada sidik jari/wajah tersimpan.',
      );

      // 3. Tampilkan dialog biometrik OS
      final bool result = await _auth.authenticate(
        localizedReason: reason,           // Teks yang muncul di dialog
        authMessages: const [
          AndroidAuthMessages(
            signInTitle: 'Verifikasi Diperlukan',
            cancelButton: 'Batal',
          ),
        ],
        options: const AuthenticationOptions(
          biometricOnly: false,              // false = izinkan fallback PIN/pattern OS
          sensitiveTransaction: true,        // true = tidak izinkan face 2D Android
          useErrorDialogs: true,
          stickyAuth: true,                  // dialog tetap muncul setelah app di-background
        ),
      );

      // 4. result=false tanpa exception = user tekan Batal
      if (!result) throw BiometricException(
        code: BiometricErrorCode.userCanceled,
        message: 'User canceled',
        userMessage: 'Verifikasi dibatalkan',
      );

      return true;
    } on LocalAuthException catch (e) {
      throw BiometricException.fromLocalAuthException(e);
    }
  }
}