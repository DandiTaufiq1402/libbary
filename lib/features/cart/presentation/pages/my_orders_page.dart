import 'package:flutter/material.dart';

// Letakkan fungsi ini di dalam class MyOrdersPage kamu untuk styling status
Color _statusColor(String status) {
  return switch (status) {
    'pending'    => Colors.orange,
    'processing' => Colors.blue,
    'shipped'    => Colors.purple,
    'delivered'  => Colors.green,
    'cancelled'  => Colors.red,
    _            => Colors.grey,
  };
}