import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../screens/product_details_screen.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<Product>(
      context,
      listen: false,
    );
    final cart = Provider.of<Cart>(
      context,
      listen: false,
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: Image.network(
            pro.imageUrl,
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailsScreen.routeName,
              arguments: pro.id,
            );
          },
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, pro, _) => IconButton(
              color: Theme.of(context).accentColor,
              icon:
                  Icon(pro.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                pro.toggleFavoriteStatus();
              },
            ),
          ),
          title: Column(
            children: [
              Text(
                pro.title,
                textAlign: TextAlign.center,
              ),
              Text(
                pro.price.toStringAsFixed(2),
                textAlign: TextAlign.end,
              ),
            ],
          ),
          trailing: IconButton(
            color: Theme.of(context).accentColor,
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              cart.addItem(pro.id, pro.title, pro.price);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added Item To the card!'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(pro.id);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
