import 'package:flutter/material.dart';

class SingleProductScreen extends StatelessWidget {
  static const routeName = 'product';

  const SingleProductScreen();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: Hero(
        tag: args['id'],
        child: SizedBox(
          height: 200,
          width: double.infinity,
          child: Image.memory(args['image']),
        ),
      ),
    );
  }
}
