import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/provider/products.dart';
import 'package:provider/provider.dart';
import '../provider/product.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key key}) : super(key: key);
  static const String routeName = '/edit';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURLFocusNode = FocusNode();
  final _ImageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editProduct =
      Product(id: null, title: '', price: 0, description: '', imageUrl: '');
  var _isInit = true;
  var _Isloading = false;
  var _initvalues = {
    'id': '',
    'title': '',
    'price': '',
    'description': '',
    'imageURL': '',
  };

  @override
  void initState() {
    _imageURLFocusNode.addListener(_updateImageURL);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final ProductId = ModalRoute.of(context).settings.arguments as String;
      if (ProductId != null) {
        _editProduct =
            Provider.of<Products>(context, listen: false).findById(ProductId);
        _initvalues = {
          'id': _editProduct.id,
          'title': _editProduct.title,
          'price': _editProduct.price.toString(),
          'description': _editProduct.description,
          'imageURL': '',
        };
        _ImageUrlController.text = _editProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageURL() {
    if (!_imageURLFocusNode.hasFocus) {
      if (!_ImageUrlController.text.startsWith('http')) {
        return;
      }
      if (!_ImageUrlController.text.endsWith('.png') &&
          !_ImageUrlController.text.endsWith('.jpg') &&
          !_ImageUrlController.text.endsWith('.jpeg')) {
        return;
      }

      setState(() {}); // it just refreshs the UI
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _Isloading = true;
    });

    if (_editProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editProduct.id, _editProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editProduct);
      } catch (error) {
        await showDialog<Null>(
            context: context,
            builder: (cxt) => AlertDialog(
                  title: Text('something went wrong'),
                  content: Text('an error accurred'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(cxt).pop();
                      },
                      child: Text('ok'),
                    ),
                  ],
                ));
      }
      // finally {
      //   //finally runs any way
      //   setState(() {
      //     _Isloading = false;
      //   });
      //   Navigator.of(context).pop();
      // }

      setState(() {
        _Isloading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _imageURLFocusNode.removeListener(_updateImageURL);
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    _ImageUrlController.dispose();
    _imageURLFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _Isloading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('edit product'),
              actions: [
                IconButton(
                  onPressed: _saveForm,
                  icon: Icon(Icons.save),
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initvalues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction
                          .next, //it presents the enter button in the keyboard in the phone
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                          id: _editProduct.id,
                          isFavorite: _editProduct.isFavorite,
                          title: value,
                          price: _editProduct.price,
                          description: _editProduct.description,
                          imageUrl: _editProduct.imageUrl,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'provie a value here';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initvalues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                          id: _editProduct.id,
                          isFavorite: _editProduct.isFavorite,
                          title: _editProduct.title,
                          price: double.parse(value),
                          description: _editProduct.description,
                          imageUrl: _editProduct.imageUrl,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'enter a number. ';
                        }
                        if (double.tryParse(value) == null) {
                          return 'enter a valid number. ';
                        }
                        if (double.parse(value) <= 0) {
                          return 'enter a greater numer. ';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initvalues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) {
                        _editProduct = Product(
                          id: _editProduct.id,
                          isFavorite: _editProduct.isFavorite,
                          title: _editProduct.title,
                          price: _editProduct.price,
                          description: value,
                          imageUrl: _editProduct.imageUrl,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'enter a value. ';
                        }
                        if (value.length < 10) {
                          return 'at least 10 characters long. ';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 10, right: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _ImageUrlController.text.isEmpty
                              ? Text('Enter image URL')
                              : FittedBox(
                                  child: Image.network(
                                    _ImageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            controller: _ImageUrlController,
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageURLFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) {
                              _editProduct = Product(
                                id: _editProduct.id,
                                isFavorite: _editProduct.isFavorite,
                                title: _editProduct.title,
                                price: _editProduct.price,
                                description: _editProduct.description,
                                imageUrl: value,
                              );
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'enter an URL';
                              }
                              if (!value.startsWith('http')) {
                                return 'enter a valid URL';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'enter a valid image';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
