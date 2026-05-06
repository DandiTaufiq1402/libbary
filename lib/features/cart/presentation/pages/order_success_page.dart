// Letakkan fungsi ini di dalam class OrderSuccessPage kamu
String _statusLabel(String status) {
  return switch (status) {
    'pending'    => 'Menunggu Pembayaran',
    'processing' => 'Sedang Diproses',
    'shipped'    => 'Dikirim',
    'delivered'  => 'Diterima',
    'cancelled'  => 'Dibatalkan',
    _            => status,          // ← fallback: tampilkan apa adanya
  };
}