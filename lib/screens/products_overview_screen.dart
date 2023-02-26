import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/products.dart';
import 'package:flutter_complete_guide/screens/Card_screen.dart';
import 'package:provider/provider.dart';
import '../widgets/product_grid.dart';
import '../widgets/badge.dart';
import '../provider/Cart.dart';
import './Card_screen.dart';
import '../widgets/app_drawer.dart';

enum FilterOptions {
  favorite,
  all,
}

class ProductsOverViewScreen extends StatefulWidget {
  @override
  State<ProductsOverViewScreen> createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  bool _isLoading = false;
  bool showAll = true;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Products>(context, listen: false).fetchAndSetData().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final productsContainer = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('MYSHOP'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selected) {
              setState(
                () {
                  if (selected == FilterOptions.all) {
                    showAll = true;
                  } else {
                    showAll = false;
                  }
                },
              );
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Only favorite"),
                value: FilterOptions.favorite,
              ),
              PopupMenuItem(
                child: Text("All items"),
                value: FilterOptions.all,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CardScreen.routName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(showAll),
    );
  }
}
