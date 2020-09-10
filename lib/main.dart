import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import './screens/product_overview_screen.dart';
import './screens/product_details_screen.dart';
import './providers/products.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Products(),
      child:MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.orangeAccent,
          fontFamily: 'Lato',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ProductOverViewScreen(),
        routes: {
          ProductDetailsScreen.routeName: (cts) => ProductDetailsScreen(),
        },
      ),
    );
  }
}

