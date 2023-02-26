import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import '../screens/edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetData();
  }
//E/flutter ( 3203): [ERROR:flutter/lib/ui/ui_dart_state.cc(198)]
//Unhandled Exception: type 'String' is not a subtype of type 'Map<String, dynamic>' in type cast

  static const routName = '/user';
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: Icon(Icons.add),
          ),
        ],
        title: Text(
          'Your products ',
        ),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.separated(
            physics: BouncingScrollPhysics(),
            separatorBuilder: (context, index) => Divider(),
            itemCount: productData.items.length,
            itemBuilder: (_, i) => UserProductItem(
              id: productData.items[i].id,
              imageUrl: productData.items[i].imageUrl,
              title: productData.items[i].title,
            ),
          ),
        ),
      ),
    );
  }
}
