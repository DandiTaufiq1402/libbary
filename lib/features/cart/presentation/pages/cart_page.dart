// Sisipkan fungsi ini di dalam class CartPage kamu atau di widget item keranjangnya
// Pastikan kamu sudah memanggil provider: final cartProv = context.read<CartProvider>();

void _onDecrease(CartItemModel item, CartProvider cartProv) {
  final qty = item.quantity - 1;
  if (qty <= 0) {
    cartProv.removeItem(item.id);    // ← qty = 0 → hapus item
  } else {
    cartProv.updateItem(item.id, qty);
  }
}

void _onIncrease(CartItemModel item, CartProvider cartProv) {
  cartProv.updateItem(item.id, item.quantity + 1);
}