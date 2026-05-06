import '../models/cart_model.dart'; // Sesuaikan lokasi import jika perlu

abstract class CartRepository {
  Future<CartModel> getCart();
  Future<void> addToCart(int productId, int quantity);
  Future<void> updateCartItem(int cartItemId, int quantity);
  Future<void> removeCartItem(int cartItemId);
  Future<void> clearCart();
}