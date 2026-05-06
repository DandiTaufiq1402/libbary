import 'package:flutter/material.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../data/models/cart_model.dart';

enum CartStatus { initial, loading, loaded, error }

class CartProvider extends ChangeNotifier {
  final CartRepository _repository = CartRepositoryImpl();
  CartStatus _status = CartStatus.initial;
  CartModel? _cart;
  String? _error;
  bool _isAdding = false;   // ← flag khusus saat tambah ke cart

  CartStatus get status => _status;
  CartModel? get cart => _cart;
  String? get error => _error;
  bool get isAdding => _isAdding;
  
  // Getter untuk badge di bottom nav
  int get itemCount => _cart?.itemCount ?? 0;

  Future<void> fetchCart() async {
    _status = CartStatus.loading;
    notifyListeners();
    try {
      _cart = await _repository.getCart();
      _status = CartStatus.loaded;
    } catch (e) {
      _error = e.toString();
      _status = CartStatus.error;
    }
    notifyListeners();
  }

  Future<bool> addToCart(int productId, int quantity) async {
    _isAdding = true;           // ← Tombol "Tambah ke Keranjang" menampilkan spinner
    notifyListeners();
    try {
      await _repository.addToCart(productId, quantity);
      await fetchCart();        // ← Refresh data cart setelah berhasil
      _isAdding = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isAdding = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> updateItem(int cartItemId, int quantity) async {
    try {
      await _repository.updateCartItem(cartItemId, quantity);
      await fetchCart();
    } catch (e) {
      debugPrint("Gagal update item: $e");
    }
  }

  Future<void> removeItem(int cartItemId) async {
    try {
      await _repository.removeCartItem(cartItemId);
      await fetchCart();
    } catch (e) {
      debugPrint("Gagal hapus item: $e");
    }
  }

  Future<void> clearCart() async {
    await _repository.clearCart();
    // Langsung set state ke kosong tanpa fetch ulang — lebih cepat
    _cart = const CartModel(items: [], total: 0, itemCount: 0);
    _status = CartStatus.loaded;
    notifyListeners();
  }
}