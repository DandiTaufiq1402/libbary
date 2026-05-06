// ... rute lama kamu ...
  static const String cart         = '/cart';
  static const String checkout     = '/checkout';
  static const String orderSuccess = '/order-success';
  static const String myOrders     = '/my-orders';

  // Tambahkan ini di dalam Map<String, WidgetBuilder> get routes => { ... }
  /* Pastikan kamu sudah membuat file UI page-nya terlebih dahulu sebelum meng-uncomment bagian ini:
    cart:         (_) => const CartPage(),
    checkout:     (_) => const CheckoutPage(),
    myOrders:     (_) => const MyOrdersPage(),
    orderSuccess: (context) {
      final order = ModalRoute.of(context)!.settings.arguments as OrderModel;
      return OrderSuccessPage(order: order);
    },
  */