import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping/models/cart.dart';
import 'package:shoping/providers/orders.dart';
import 'package:shoping/providers/products_provider.dart';
import 'package:shoping/screens/cart_sccreen.dart';
import 'package:shoping/screens/edit_product_screen.dart';
import 'package:shoping/screens/orders_screen.dart';
import 'package:shoping/screens/product_detail_screen.dart';
import 'package:shoping/screens/product_overview_screen.dart';
import 'package:shoping/screens/user_product.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ProductsProvider()),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProvider(create: (ctx) => Orders()),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              primarySwatch: Colors.purple,
              colorScheme:
                  const ColorScheme.light(secondary: Colors.deepOrange),
              fontFamily: 'Lato                        '),
          routes: {
            ProductOverviewScreen.routeName: (context) =>
                const ProductOverviewScreen(),
            ProductDetailScreen.routeName: (context) =>
                const ProductDetailScreen(),
            CartScreen.routeName: (context) => const CartScreen(),
            OrdersScreen.routeName: (context) => const OrdersScreen(),
            UserProductScreen.routeName: (context) => const UserProductScreen(),
            EditProductScreen.routeName: (context) => const EditProductScreen(),
          }),
    );
  }
}
