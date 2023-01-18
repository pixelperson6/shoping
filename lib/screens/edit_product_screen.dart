import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping/models/product.dart';
import 'package:shoping/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_product';
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();

  final _imageUrlCOntroller = TextEditingController();

  final _form = GlobalKey<FormState>();

  var _editedProduct =
      Product(id: '', title: '', description: '', imageUrl: '', price: 0);

  var _isInit = true;
  var _initValue = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments as String;

      if (productId != null) {
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _initValue = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': ''
          // 'imageUrl': _editedProduct.imageUrl,
        };
        _imageUrlCOntroller.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlCOntroller.text.startsWith('http') &&
              !_imageUrlCOntroller.text.startsWith('https')) ||
          (!_imageUrlCOntroller.text.endsWith('.jpg') &&
              !_imageUrlCOntroller.text.endsWith('.jpeg') &&
              !_imageUrlCOntroller.text.endsWith('.png'))) {
        return;
      }

      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlCOntroller.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async{
    final isValid = _form.currentState?.validate();
    if (isValid != null) {
      if (isValid) {
        _form.currentState?.save();
        setState(() {
          _isLoading = true;
        });
        if (_editedProduct.id.isNotEmpty) {
          await Provider.of<ProductsProvider>(context, listen: false)
              .updateProduct(_editedProduct.id, _editedProduct);
        
        } else {

          try{
            await Provider.of<ProductsProvider>(context, listen: false)
              .addProduct(_editedProduct);

          }catch(error){
            await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('An error occurred!'),
                content: const Text('Something went wrong!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Okey'),
                  )
                ],
              ),
            );

          }
          // finally{
            
          //   setState(() {
          //     _isLoading = false;
          //   });
          //   Navigator.of(context).pop();

          // }
        }
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop();
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit product'),
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save)),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initValue['title'],
                        decoration: const InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please provide a value.';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                              title: newValue!,
                              description: _editedProduct.description,
                              imageUrl: _editedProduct.imageUrl,
                              price: _editedProduct.price);
                        },
                      ),
                      TextFormField(
                        initialValue: _initValue['price'],
                        decoration: const InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please provide a price.';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please provide a valid number.';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please provide a price greater than zero.';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              imageUrl: _editedProduct.imageUrl,
                              price: double.parse(newValue!));
                        },
                        focusNode: _priceFocusNode,
                      ),
                      TextFormField(
                        initialValue: _initValue['description'],
                        decoration:
                            const InputDecoration(labelText: 'Discription'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please provide a value.';
                          }
                          if (value.length < 10) {
                            return 'Too short, enter at least 10 letter';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                              title: _editedProduct.title,
                              description: newValue!,
                              imageUrl: _editedProduct.imageUrl,
                              price: _editedProduct.price);
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: _imageUrlCOntroller.text.isEmpty
                                ? const Text('Enter URL')
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlCOntroller.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              // initialValue: _initValue['imageUrl'],
                              decoration:
                                  const InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlCOntroller,
                              focusNode: _imageUrlFocusNode,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please provide an image URL.';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Please enter a valid image URL';
                                }
                                if (!value.endsWith('.jpg') &&
                                    !value.endsWith('.jpeg') &&
                                    !value.endsWith('.png')) {
                                  return 'Please enter a valid image URL';
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) {
                                _saveForm();
                              },
                              onSaved: (newValue) {
                                _editedProduct = Product(
                                    id: _editedProduct.id,
                                    isFavorite: _editedProduct.isFavorite,
                                    title: _editedProduct.title,
                                    description: _editedProduct.description,
                                    imageUrl: _editedProduct.imageUrl,
                                    price: _editedProduct.price);
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
