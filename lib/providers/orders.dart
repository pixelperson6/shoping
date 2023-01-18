import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:shoping/models/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.https(
        'shoping-flutter-bc891-default-rtdb.firebaseio.com', '/orders.json');
    try {
      final response = await get(url);
      final List<OrderItem> loadedOrders = [];

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((key, value) {
        loadedOrders.add(OrderItem(
          id: key,
          amount: value['amount'],
          dateTime: DateTime.parse(value['dateTeme']),
          products: (value['products'] as List<dynamic>)
              .map(
                (e) => CartItem(
                  id: e['id'],
                  title: e['title'],
                  quantity: e['quantity'],
                  price: e['price'],
                ),
              )
              .toList(),
        ));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    // final url = Uri.https(
    //     'shoping-flutter-bc891-default-rtdb.firebaseio.com', '/orders.json');

    final url = Uri.https(
        'shoping-flutter-bc891-default-rtdb.firebaseio.com', '/orders.json');

    final timeStamp = DateTime.now();

    try {
      final response = await post(url,
          body: ({
            'amount': total,
            'dateTime': timeStamp.toIso8601String(),
            'products': cartProducts
                .map((e) => {
                      'id': e.id,
                      'title': e.title,
                      'quantity': e.quantity,
                      'price': e.price,
                    })
                .toList(),
          }));

      _orders.insert(
          0,
          OrderItem(
              id: json.decode(response.body)['name'],
              amount: total,
              products: cartProducts,
              dateTime: timeStamp));

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
