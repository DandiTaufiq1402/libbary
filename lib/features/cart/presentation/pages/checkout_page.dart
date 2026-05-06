import 'package:flutter/material.dart';
// import provider dan model yang dibutuhkan

class _PaymentOption {
  final String value, label, subtitle;
  final IconData icon;
  final Color iconColor;
  const _PaymentOption({required this.value, required this.label, required this.subtitle, required this.icon, required this.iconColor});
}

// Letakkan di dalam class _CheckoutPageState:
  static const List<_PaymentOption> _paymentOptions = [
    _PaymentOption(
      value: 'gopay',                           // ← dikirim ke API
      label: 'GoPay',                           // ← ditampilkan ke user
      subtitle: 'Bayar instant dengan GoPay',
      icon: Icons.account_balance_wallet,
      iconColor: Color(0xFF00ADB5),             // ← hijau teal
    ),
    _PaymentOption(
      value: 'bank_transfer',
      label: 'Transfer Bank',
      subtitle: 'BCA, Mandiri, BNI, BRI',
      icon: Icons.account_balance,
      iconColor: Color(0xFF1565C0),             // ← biru
    ),
    _PaymentOption(
      value: 'virtual_account',
      label: 'Virtual Account',
      subtitle: 'Nomor VA otomatis digenerate',
      icon: Icons.credit_card,
      iconColor: Color(0xFFE65100),             // ← oranye
    ),
  ];

  // Fungsi validasi dan checkout
  Future<void> _placeOrder(BuildContext context, OrderProvider orderProv, CartProvider cartProv) async {
    // 1. Validasi form (alamat pengiriman) - pastikan kamu punya _formKey dan _addressCtrl
    // if (!_formKey.currentState!.validate()) return;
    
    // 2. Validasi metode pembayaran dipilih
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih metode pembayaran terlebih dahulu')),
      );
      return;
    }
    
    // 3. Tampilkan loading dialog
    showDialog(context: context, builder: (_) => const Center(
      child: CircularProgressIndicator(),
    ));
    
    // 4. Panggil API checkout
    final success = await orderProv.checkout(
      shippingAddress: _addressCtrl.text.trim(),
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      paymentMethod: _selectedPaymentMethod!,
    );
    Navigator.pop(context); // tutup loading
    
    if (success) {
      // 5. Bersihkan cart
      await cartProv.clearCart();
      // 6. Navigate ke halaman sukses, hapus stack checkout & cart
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRouter.orderSuccess, // Sesuaikan dengan nama rute kamu
        (route) => route.settings.name == AppRouter.dashboard, // Asumsi dashboard adalah rute awal
        arguments: orderProv.lastOrder,
      );
    }
  }