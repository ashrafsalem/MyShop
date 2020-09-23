import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import './product.dart';

class Products extends ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // var _Favorite = false;

  final String token;
  final String userId;
  Products(this.token, this.userId, this._items);

  List<Product> get items {
    return [..._items];
    // if(_Favorite) {
    //   return _items.where((item) => item.isFavorite).toList();
    // } else {
    //  return [..._items];
    // }
  }

  List<Product> get favoriteItems {
    return _items.where((pro) => pro.isFavorite).toList();
  }

  Product findByID(String id) {
    return items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly(){
  //   _Favorite = true;
  //   notifyListeners();
  // }
  //
  // void showAll() {
  //   _Favorite = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProduct([bool filtered = false]) async {
    final filteredString =
        filtered ? 'orderBy="creatorId"&equalTo=$userId' : '';
    var url =
        'https://flutter-update-9681a.firebaseio.com/products.json?auth=$token&$filteredString'; // orderBy="creatorId"&equalTo=$userId that way only firebase offer to do filtering by user
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedData = [];
      if (extractedData == null) {
        return;
      }
      // here we change url declaration to var to re-use it in this location
      url =
          'https://flutter-update-9681a.firebaseio.com/userFavorites/$userId.json?auth=$token';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);

      extractedData.forEach((prodId, prodData) {
        loadedData.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite: favoriteData == null
              ? false
              : favoriteData[prodId] ??
                  false, // just get the value umder fav -> with the user id -> for this product, ?? operator if the left oprand is true ok if not return the right oprand
        ));
      });

      _items = loadedData;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://flutter-update-9681a.firebaseio.com/products.json?auth=$token';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'creatorId': userId,
        }),
      );

      final newProduct = Product(
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String productID, Product newProduct) async {
    final productIndex = _items.indexWhere((prod) => prod.id == productID);
    if (productIndex >= 0) {
      final url =
          'https://flutter-update-9681a.firebaseio.com/products/$productID.json?auth=$token';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[productIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String productID) async {
    final url =
        'https://flutter-update-9681a.firebaseio.com/products/$productID.json?auth=$token';
    final productIndex = _items.indexWhere((prod) => prod.id == productID);
    var existingItem = _items[productIndex];
    _items.removeWhere((prod) => prod.id == productID);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(productIndex, existingItem);
      notifyListeners();
      throw HttpException('delete faild!');
    }
  }
}
