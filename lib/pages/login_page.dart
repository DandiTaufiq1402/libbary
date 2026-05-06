// Tambahkan enum ini di luar class atau di bagian atas file
enum _AuthMethod { face, fingerprint, password }

// Di dalam State class LoginPage kamu (_LoginPageState):
  _AuthMethod? _activeMethod;
  bool _isLoading = false;
  String? _errorMessage;
  BiometricErrorCode? _errorCode;
  List<_AuthMethod> _availableMethods = [];

  // Panggil saat halaman pertama kali dibuka
  @override
  void initState() {
    super.initState();
    _initBiometrics();
  }

  Future<void> _initBiometrics() async {
    final service = BiometricService(); // Pastikan kamu import service-nya
    final available = await service.isBiometricAvailable();
    final types = await service.getAvailableBiometrics();
    
    // Cek ketersediaan sensor
    final hasFace = types.contains(BiometricType.face) || types.contains(BiometricType.weak);
    final hasFingerprint = types.contains(BiometricType.fingerprint) || types.contains(BiometricType.strong);
    
    setState(() { 
      // Masukkan metode yang didukung oleh HP user
      if (hasFace) _availableMethods.add(_AuthMethod.face);
      if (hasFingerprint) _availableMethods.add(_AuthMethod.fingerprint);
      _availableMethods.add(_AuthMethod.password); // Password selalu ada
    });
  }

  // Fungsi penanganan jika sensor gagal/ditolak
  void _handleError(BiometricException e) {
    setState(() {
      _errorMessage = e.userMessage;
      _errorCode = e.code;
      // Jika error butuh fallback (terkunci permanen/tidak ada hardware),
      // otomatis pindah ke form password biasa
      if (e.requiresFallback) _activeMethod = _AuthMethod.password;
    });
  }