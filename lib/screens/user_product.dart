import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping/providers/products_provider.dart';
import 'package:shoping/screens/edit_product_screen.dart';
import 'package:shoping/widgets/app_drawer.dart';
import 'package:shoping/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user_products';

  const UserProductScreen({super.key});

    Future<void> _refreshProduct(BuildContext context) async{
    await Provider.of<ProductsProvider>(context,listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, EditProductScreen.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () =>_refreshProduct(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: (context, index) => Column(
              children: [
                UserProductItem(id: productData.items[index].id,
                    title: productData.items[index].title,
                    imageUrl: productData.items[index].imageUrl),
                const Divider(),
              ],
            ),
            itemCount: productData.items.length,
          ),
        ),
      ),
    );
  }
}
