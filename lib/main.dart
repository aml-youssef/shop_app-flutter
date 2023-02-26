import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detailes_screen.dart';
import './provider/products.dart';
import './provider/Cart.dart';
import './screens/Card_screen.dart';
import './provider/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_product_screen.dart';
import './screens/edit_product_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (cxt) => Products(),
        ),
        ChangeNotifierProvider(
          create: (cxt) => Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Order(),
        ),
        //create and value is the same but create is recommended
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverViewScreen(),
        routes: {
          ProductDetailesScreen.routName: (cxt) => ProductDetailesScreen(),
          CardScreen.routName: (cxt) => CardScreen(),
          OrdersScreen.routName: (cxt) => OrdersScreen(),
          UserProductScreen.routName: (cxt) => UserProductScreen(),
          EditProductScreen.routeName: (cxt) => EditProductScreen(),
        },
      ),
    );
  }
}
