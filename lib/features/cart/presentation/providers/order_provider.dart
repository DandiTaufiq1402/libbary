import 'package:flutter/material.dart';
import '../../domain/repositories/order_repository.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../data/models/order_model.dart';

enum OrderStatus { initial, loading, success, error }

class OrderProvider extends ChangeNotifier {
  final OrderRepository _repository = OrderRepositoryImpl();
  OrderStatus _checkoutStatus = OrderStatus.initial;
  OrderModel? _lastOrder;      // ← order terakhir berhasil dibuat
  List<OrderModel> _orders = [];
  String? _error;

  OrderStatus get checkoutStatus => _checkoutStatus;
  OrderModel? get lastOrder => _lastOrder;
  List<OrderModel> get orders => _orders;
  String? get error => _error;

  void _setLoading() {
    _checkoutStatus = OrderStatus.loading;
    notifyListeners();
  }

  void _setError(String msg) {
    _error = msg;
    _checkoutStatus = OrderStatus.error;
    notifyListeners();
  }

  Future<bool> checkout({
    required String shippingAddress,
    String? notes,
    required String paymentMethod,
  }) async {
    _setLoading();
    try {
      _lastOrder = await _repository.checkout(
        shippingAddress: shippingAddress,
        notes: notes,
        paymentMethod: paymentMethod,
      );
      _checkoutStatus = OrderStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<void> fetchMyOrders() async {
    try {
      _orders = await _repository.getMyOrders();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }
}