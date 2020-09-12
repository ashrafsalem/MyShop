import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../screens/product_details_screen.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<Product>(context, listen: false,);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child:Image.network(
            pro.imageUrl,
            fit: BoxFit.cover,
          ),
          onTap: (){
            Navigator.of(context).pushNamed(
              ProductDetailsScreen.routeName,
              arguments: pro.id,
            );
          },
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder:(ctx, pro, _) => IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(pro.isFavorite ? Icons.favorite: Icons.favorite_border),
              onPressed: (){
                pro.toggleFavoriteStatus();
              },
            ) ,
          ),
          title: Text(
            pro.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            color: Theme.of(context).accentColor,
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: (){
              cart.addItem(pro.id, pro.title, pro.price);
            },
          ),
        ),
      ),
    );
  }
}
