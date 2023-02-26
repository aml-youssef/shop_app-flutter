import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/orders.dart' show Order;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _ordersFuture;

  Future obtainOrdersDuture() {
    return Provider.of<Order>(context, listen: false).fetchOrders();
  }

  @override
  void initState() {
    _ordersFuture = obtainOrdersDuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('your orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        //////////////////////////////////////////////
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.error != null) {
              //if (error == null) --> everything is fine
              return Center(
                child: Text('something went wrong !'),
              );
            } else {
              return Consumer<Order>(
                builder: (ctx, orderData, child) {
                  return ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (ctx, i) => OrderItem(
                      orderData.orders[i],
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
