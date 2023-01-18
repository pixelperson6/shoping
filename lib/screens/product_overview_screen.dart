import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping/models/cart.dart';
import 'package:shoping/providers/products_provider.dart';
import 'package:shoping/screens/cart_sccreen.dart';
import 'package:shoping/widgets/app_drawer.dart';
import 'package:shoping/widgets/badge.dart';
import 'package:shoping/widgets/product_item.dart';

enum FilterOptions { favorite, all }

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = '/';
  const ProductOverviewScreen({super.key});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorite = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
      _isLoading = true;
        
      });
      Provider.of<ProductsProvider>(context)
          .fetchAndSetProducts()
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final productContainer =
    //     Provider.of<ProductsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: ((FilterOptions value) {
              setState(() {
                switch (value) {
                  case FilterOptions.favorite:
                    {
                      //productContainer.showFavoritesOnly();
                      _showOnlyFavorite = true;
                    }
                    break;
                  case FilterOptions.all:
                    {
                      //productContainer.showAll();
                      _showOnlyFavorite = false;
                    }
                    break;
                }
              });
            }),
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: FilterOptions.favorite,
                child: Text('Only Favorites'),
              ),
              PopupMenuItem(
                value: FilterOptions.all,
                child: Text('Show all'),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (context, value, child) =>
                Badge(value: value.itemCount.toString(), child: child),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading ? const Center(
              child: CircularProgressIndicator(),
            ):ProductGrid(
        showFav: _showOnlyFavorite,
      ),
    );
  }
}

class ProductGrid extends StatelessWidget {
  final bool showFav;

  const ProductGrid({super.key, required this.showFav});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final loadedProducts =
        showFav ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: loadedProducts[index],
        child: const ProductItem(
            // loadedProducts[index].id,
            // loadedProducts[index].title,
            // loadedProducts[index].imageUrl,
            ),
      ),
      itemCount: loadedProducts.length,
    );
  }
}
