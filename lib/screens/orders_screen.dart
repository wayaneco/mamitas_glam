import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop_app/widgets/order.dart';

import '../providers/orders_provider.dart';

import '../widgets/drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _initLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initLoading == true) {
      Provider.of<OrderProvider>(context).fetchOrders(initFetch: true);
      setState(() {
        _initLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrderProvider>(context).getAllOrders();
    final isLoading = Provider.of<OrderProvider>(context).loading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Order\'s'),
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Provider.of<OrderProvider>(
              context,
              listen: false,
            ).fetchOrders();
          },
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : orders.isEmpty
                  ? const Center(child: Text('No order\'s'))
                  : ListView.builder(
                      itemBuilder: (_, index) => OrderItem(
                        index: index,
                        date: orders[index]['dateOrdered'],
                        children: orders[index]['orders'],
                        totalPrice: orders[index]['total'],
                        status: orders[index]['status'],
                      ),
                      itemCount: orders.length,
                    ),
        ),
      ),
    );
  }
}
