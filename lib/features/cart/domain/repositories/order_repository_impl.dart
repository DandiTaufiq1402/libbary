import '../../domain/repositories/order_repository.dart';
import '../models/order_model.dart';
// import '...'; // Pastikan kamu meng-import DioClient dan ApiConstants milikmu

class OrderRepositoryImpl implements OrderRepository {
  @override
  Future<OrderModel> checkout({
    required String shippingAddress,
    String? notes,
    required String paymentMethod,
  }) async {
    final response = await DioClient.instance.post(
      ApiConstants.checkout,          // POST /v1/orders/checkout
      data: {
        'shipping_address': shippingAddress,
        'notes': notes ?? '',
        'payment_method': paymentMethod,
      },
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return OrderModel.fromJson(data);
  }
  @override
  Future<List<OrderModel>> getMyOrders({int page = 1, int limit = 10}) async {
    final response = await DioClient.instance.get(
      ApiConstants.orders,
      queryParameters: {'page': page, 'limit': limit},
    );
    final List<dynamic> data = response.data['data'] ?? [];
    return data.map((e) => OrderModel.fromJson(e)).toList();
  }
  
  // Menambahkan stub untuk getOrderDetail agar sesuai dengan kontrak abstract class
  @override
  Future<OrderModel> getOrderDetail(int orderId) async {
    final response = await DioClient.instance.get('${ApiConstants.orders}/$orderId');
    final data = response.data['data'] as Map<String, dynamic>;
    return OrderModel.fromJson(data);
  }
}