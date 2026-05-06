import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/biometric_lock_provider.dart';

class BiometricLockScreen extends StatefulWidget {
  final Widget child;
  const BiometricLockScreen({super.key, required this.child});

  @override
  State<BiometricLockScreen> createState() => _BiometricLockScreenState();
}

class _BiometricLockScreenState extends State<BiometricLockScreen>
    with WidgetsBindingObserver {
  DateTime? _backgroundedAt;
  static const _lockTimeout = Duration(seconds: 30); // Atur waktu tunggu aplikasi di-background

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Trigger unlock saat pertama buka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BiometricLockProvider>().unlock();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final provider = context.read<BiometricLockProvider>();
    if (state == AppLifecycleState.paused) {
      _backgroundedAt = DateTime.now(); // Catat waktu saat app keluar
    } else if (state == AppLifecycleState.resumed) {
      final backgrounded = _backgroundedAt;
      if (backgrounded != null) {
        final elapsed = DateTime.now().difference(backgrounded);
        if (elapsed >= _lockTimeout) {
          provider.lock();
          provider.unlock();  // Langsung tampilkan dialog
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BiometricLockProvider>();
    
    // Tampilan layar saat aplikasi terkunci
    if (provider.isLocked) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 64, color: Colors.teal),
              const SizedBox(height: 16),
              const Text('Aplikasi Terkunci',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (provider.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(provider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red)),
                ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: provider.unlock,
                icon: const Icon(Icons.fingerprint),
                label: const Text('Buka Kunci'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal,
                    foregroundColor: Colors.white),
              ),
            ],
          ),
        ),
      );
    }
    
    // Jika tidak terkunci, kembalikan ke halaman biasa
    return widget.child;
  }
}