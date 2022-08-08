import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../providers/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final List<FocusNode> _focusInput =
      List<FocusNode>.generate(4, (_) => FocusNode());
  final _form = GlobalKey<FormState>();

  late Map<String, dynamic> productData = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  bool _loadInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final productId = ModalRoute.of(context)?.settings.arguments;
    if (_loadInit) {
      if (productId != null) {
        final ProductModel product =
            Provider.of<ProductProvider>(context, listen: false)
                .findById(productId as String);

        productData = {
          'title': product.title,
          'description': product.description,
          'price': product.price.toString(),
          'imageUrl': product.imageUrl,
        };
      }
    }
    _loadInit = false;
  }

  @override
  void dispose() {
    super.dispose();
    _form.currentState!.dispose();

    FocusScope.of(context).requestFocus(FocusNode());
    productData = {
      'title': '',
      'description': '',
      'price': '',
      'imageUrl': '',
    };
  }

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final productId = ModalRoute.of(context)?.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('${productId != null ? 'Edit' : 'Add'} Product'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentScope = FocusScope.of(context);

          if (!currentScope.hasPrimaryFocus) {
            currentScope.unfocus();
          }
        },
        child: LoaderOverlay(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
            child: Form(
              key: _form,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Title'),
                        hintText: 'Enter title',
                        alignLabelWithHint: true,
                      ),
                      initialValue: productData['title'],
                      textInputAction: TextInputAction.next,
                      focusNode: _focusInput[0],
                      onFieldSubmitted: (_) {
                        _focusInput[1].requestFocus();
                      },
                      onSaved: (value) {
                        productData['title'] = value;
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'This field is required!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Price'),
                        alignLabelWithHint: true,
                        prefixText: '\$',
                      ),
                      initialValue: productData['price'],
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r"(^\d*\.?\d*)"),
                        ),
                      ],
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      focusNode: _focusInput[1],
                      onFieldSubmitted: (_) {
                        _focusInput[2].requestFocus();
                      },
                      onSaved: (value) {
                        productData['price'] = value;
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'This field is required!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Image URL'),
                        hintText: 'Enter image url',
                        alignLabelWithHint: true,
                      ),
                      initialValue: productData['imageUrl'],
                      keyboardType: TextInputType.url,
                      // textInputAction: TextInputAction.next,
                      focusNode: _focusInput[2],
                      onFieldSubmitted: (_) {
                        _focusInput[3].requestFocus();
                      },
                      onSaved: (value) {
                        productData['imageUrl'] = value;
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'This field is required!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Description'),
                        hintText: 'Enter description',
                        alignLabelWithHint: true,
                      ),
                      initialValue: productData['description'],
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.done,
                      focusNode: _focusInput[3],
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      onSaved: (value) {
                        productData['description'] = value;
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'This field is required!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          _form.currentState!.save();

                          final bool isValidated =
                              _form.currentState!.validate();

                          if (isValidated) {
                            if (productId == null) {
                              await productProvider.addProduct(
                                productData['title'],
                                productData['description'],
                                double.parse(productData['price']),
                                productData['imageUrl'],
                                context.loaderOverlay,
                              );
                            } else {
                              await productProvider.updateProduct(
                                productId as String,
                                productData['title'],
                                productData['description'],
                                double.parse(productData['price']),
                                productData['imageUrl'],
                                context.loaderOverlay,
                              );
                            }

                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('SUBMIT'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
