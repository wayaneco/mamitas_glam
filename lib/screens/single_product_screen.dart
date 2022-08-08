import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class SingleProductScreen extends StatelessWidget {
  static const routeName = 'product';

  const SingleProductScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
    );
  }
}
