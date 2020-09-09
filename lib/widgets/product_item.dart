import 'package:flutter/material.dart';
import '../screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {


  final String id;
  final String title;
  final String imageUrl;

  ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child:Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
          onTap: (){
            Navigator.of(context).pushNamed(
              ProductDetailsScreen.routeName,
              arguments: id,
            );
          },
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            color: Theme.of(context).accentColor,
            icon: Icon(Icons.favorite),
            onPressed: (){},
          ),
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            color: Theme.of(context).accentColor,
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: (){},
          ),
        ),
      ),
    );
  }
}
