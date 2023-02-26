import 'package:flutter/material.dart';
import '../widgets/product_item.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';

class ProductsGrid extends StatelessWidget {
  final bool showAll;
  ProductsGrid(this.showAll);

  @override
  Widget build(BuildContext context) {
    final products = showAll
        ? Provider.of<Products>(context).items
        : Provider.of<Products>(context).favorite;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 3 / 2,
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (cxt, i) => ChangeNotifierProvider.value(
        value: products[i], //it will return a product
        //use (.value) when it is a part of a list or something that already exist
        child: ProductItem(),
      ),
    );
  }
}
