import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../providers/products.dart';

enum filterOptions{
  favoritesOnly,
  allItem
}

class ProductOverViewScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
          title: Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (filterOptions selectedCase){
              if(selectedCase == filterOptions.favoritesOnly){
                productData.showFavoritesOnly();
              } else if(selectedCase == filterOptions.allItem){
                productData.showAll();
              }
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(child: Text('Only Favorites'), value: filterOptions.favoritesOnly,),
              PopupMenuItem(child: Text('Show All'), value: filterOptions.allItem,),
            ],
          ),
        ],
      ),
      body: ProductsGrids(),
    );
  }
}


