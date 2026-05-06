import 'package:flutter/foundation.dart';
import 'biometric_service.dart';
import 'biometric_exception.dart';

class BiometricLockProvider extends ChangeNotifier {
  final BiometricService _service = BiometricService();
  bool _isLocked = false;
  bool _isBiometricAvailable = false;
  String? _errorMessage;

  bool get isLocked => _isLocked;
  bool get isBiometricAvailable => _isBiometricAvailable;
  String? get errorMessage => _errorMessage;

  // Panggil saat app init — cek apakah biometrik tersedia
  Future<void> initialize() async {
    _isBiometricAvailable = await _service.isBiometricAvailable();
    notifyListeners();
  }

  // Panggil saat app masuk background
  void lock() {
    if (_isBiometricAvailable) {
      _isLocked = true;
      notifyListeners();
    }
  }

  // Panggil untuk mulai proses unlock
  Future<void> unlock() async {
    if (!_isBiometricAvailable) {
      _isLocked = false;
      notifyListeners();
      return;
    }
    try {
      await _service.authenticate(reason: 'Verifikasi untuk membuka aplikasi');
      _isLocked = false;
      _errorMessage = null;
    } on BiometricException catch (e) {
      _errorMessage = e.userMessage;
    } finally {
      notifyListeners();
    }
  }
}