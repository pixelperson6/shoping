import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping/providers/orders.dart';
import 'package:shoping/widgets/app_drawer.dart';

import '../widgets/orders_item_widget.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _orderFuture;

  //var _isLoading = false;

  @override
  void initState() {
    // setState(() {
    //   _isLoading = true;
    // });
    // Future.delayed(Duration.zero).then((value) async {
    //   await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });
    _orderFuture =
        Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Ordesr"),
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
            future: _orderFuture,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Consumer<Orders>(
                      builder: (context, orderData, child) => ListView.builder(
                        itemBuilder: (context, index) => OrdersItemWidget(
                          orders: orderData.orders[index],
                        ),
                        itemCount: orderData.orders.length,
                      ),
                    );
                  }
              }
            }));
  }
}
