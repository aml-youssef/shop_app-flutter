import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_complete_guide/provider/Cart.dart';
import 'package:flutter_complete_guide/provider/product.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final Uri url = Uri.parse(
        'https://shop-app-68554-default-rtdb.firebaseio.com/orders.json');
    final response = await http.get(url);
    final List<OrderItem> loadedData = [];
    final Map<String, dynamic> extractedData =
        json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((id, orderData) => {
          loadedData.add(OrderItem(
              id: id,
              amount: orderData['amount'],
              dateTime: DateTime.parse(orderData['dateTime']),
              products: (orderData['products'] as List<dynamic>)
                  .map((item) => CartItem(
                      id: id,
                      title: item['title'],
                      quantity: item['quantity'],
                      price: item['price']))
                  .toList()))
        });
    _orders = loadedData.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> orders, double total) async {
    final Uri url = Uri.parse(
        'https://shop-app-68554-default-rtdb.firebaseio.com/orders.json');
    final timeStamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          // 'id': DateTime.now().toString(),
          'amount': total,
          'products': orders
              .map((order) => {
                    'id': order.id,
                    'title': order.title,
                    'quantity': order.quantity,
                    'price': order.price,
                  })
              .toList(),
          'dateTime': timeStamp.toIso8601String(),
        }));
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: orders,
        dateTime: timeStamp,
      ),
    );
    notifyListeners();
  }
}
