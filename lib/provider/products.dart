import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_complete_guide/models/http_exeption.dart';
import './product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
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

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favorite {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Future<void> addProduct(Product product) async {
    final Uri url = Uri.parse(
        'https://shop-app-68554-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite,
          }));
      final newProduct = Product(
          id: json.decode(response.body)['name'], // this may be an error
          title: product.title,
          price: product.price,
          description: product.description,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
//Map<String, String> map = Map.castFrom(json.decode(jsonString))

  Future<void> fetchAndSetData() async {
    final Uri url = Uri.parse(
        'https://shop-app-68554-default-rtdb.firebaseio.com/products.json');
    //try {
    final response = await http.get(url);
    final Map<String, dynamic> extractedData =
        json.decode(response.body) //may be decode
            as Map<String, dynamic>; // this may be an error
    List<Product> loadedProduct = [];
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((id, productData) {
      loadedProduct.add(Product(
        id: id,
        title: productData['title'],
        description: productData['description'],
        price: double.parse(productData['price'].toString()),
        imageUrl: productData['imageUrl'],
        isFavorite: productData['isFavorite'],
      ));
    });
    _items = loadedProduct;
    notifyListeners();
    // } catch (e) {
    //   throw e;
    // }
  }

  Product findById(id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    int productIndex = _items.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      final Uri url = Uri.parse(
          'https://shop-app-68554-default-rtdb.firebaseio.com/products/$id.json');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
            'isFavorite': newProduct.isFavorite,
          }));
      _items[productIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final Uri url = Uri.parse(
        'https://shop-app-68554-default-rtdb.firebaseio.com/products/$id.json');
    var existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existionProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existionProduct);
      notifyListeners();
      throw HttpExeption("Could not delete the product");
    }
    existionProduct = null;
    // _items.removeWhere((prod) => prod.id == id);
  }
}


// {
//   "rules": {
//     ".read": "now < 1660687200000",  // 2022-8-17
//     ".write": "now < 1660687200000",  // 2022-8-17
//   }
// }