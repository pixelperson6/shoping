import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping/models/cart.dart' show Cart;

import '../providers/orders.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(children: [
        Card(
          margin: const EdgeInsets.all(15),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 20),
                ),
                const Spacer(),
                Chip(
                  label: Text(
                    '\$${cart.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                OrderButton(cart: cart)
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
            child: ListView.builder(
          itemBuilder: ((context, index) => CartItem(
              id: cart.items.values.toList()[index].id,
              productId: cart.items.keys.toList()[index],
              title: cart.items.values.toList()[index].title,
              quantity: cart.items.values.toList()[index].quantity,
              price: cart.items.values.toList()[index].price)),
          itemCount: cart.itemCount,
        ))
      ]),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });

              try {
                await Provider.of<Orders>(context, listen: false).addOrder(
                    widget.cart.items.values.toList(), widget.cart.totalAmount);
              } catch (error) {
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('An error occurred!'),
                    content: const Text('Something went wrong!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Okey'),
                      )
                    ],
                  ),
                );
              }

              setState(() {
                _isLoading = false;
              });
              widget.cart.clear();
            },
      style: ButtonStyle(
        foregroundColor:
            MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
      ),
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text('ORDER NOW'),
    );
  }
}
