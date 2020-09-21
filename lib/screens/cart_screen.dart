import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalCartAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderNowWidget(cart),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (ctx, i) => CartItem(
                      cart.items.values.toList()[i].id,
                      cart.items.keys.toList()[i],
                      cart.items.values.toList()[i].title,
                      cart.items.values.toList()[i].price,
                      cart.items.values.toList()[i].quantity,
                    )),
          ),
        ],
      ),
    );
  }
}

class OrderNowWidget extends StatefulWidget {
  final Cart cart;

  OrderNowWidget(this.cart);
  @override
  _OrderNowWidgetState createState() => _OrderNowWidgetState();
}

class _OrderNowWidgetState extends State<OrderNowWidget> {
  var _isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoaded ? CircularProgressIndicator() : Text('ORDER NOW'),
      onPressed: widget.cart.totalCartAmount <= 0
          ? null
          : () async {
              setState(() {
                _isLoaded = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.cart.items.values.toList(),
                  widget.cart.totalCartAmount);
              setState(() {
                _isLoaded = false;
              });
              widget.cart.clear();
            },
    );
  }
}
