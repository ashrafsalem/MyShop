import 'package:MyShop/widgets/badge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../providers/products.dart';
import '../providers/cart.dart';
import './cart_screen.dart';
import '../widgets/app_drawer.dart';

enum filterOptions{
  favoritesOnly,
  allItem
}

class ProductOverViewScreen extends StatefulWidget {

  @override
  _ProductOverViewScreenState createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
   bool _favoriteOnly = false;
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
          title: Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (filterOptions selectedCase){
             setState(() {
               if(selectedCase == filterOptions.favoritesOnly){
                 // productData.showFavoritesOnly();
                 this._favoriteOnly =true;
               } else if(selectedCase == filterOptions.allItem){
                 // productData.showAll();
                 this._favoriteOnly =false;
               }
             });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(child: Text('Only Favorites'), value: filterOptions.favoritesOnly,),
              PopupMenuItem(child: Text('Show All'), value: filterOptions.allItem,),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch)=>Badge(
              child: ch,
              value: cart.cartItemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: (){
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrids(_favoriteOnly),
    );
  }
}


