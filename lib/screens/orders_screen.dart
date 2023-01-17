import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shoping/providers/orders.dart';
import 'package:shoping/widgets/app_drawer.dart';

import '../widgets/orders_item_widget.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Ordesr"),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemBuilder: (context, index) => OrdersItemWidget(
          orders: orderData.orders[index],
        ),
        itemCount: orderData.orders.length,
      ),
    );
  }
}
