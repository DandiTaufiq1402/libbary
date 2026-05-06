import '../models/order_model.dart'; // Sesuaikan lokasi import jika perlu

abstract class OrderRepository {
  Future<OrderModel> checkout({
    required String shippingAddress,
    String? notes,
    required String paymentMethod,
  });
  Future<List<OrderModel>> getMyOrders({int page, int limit});
  Future<OrderModel> getOrderDetail(int orderId);
}