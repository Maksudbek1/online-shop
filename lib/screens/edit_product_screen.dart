import 'package:flutter/material.dart';
import 'package:online_magazin/models/product.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});
  static const routeName = "/edit-products";
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _form = GlobalKey<FormState>();
  final _imageForm = GlobalKey<FormState>();

  var _product = Product(
    id: "",
    title: "",
    description: "",
    price: 0.0,
    imageUrl: "",
  );

  var _hasImage = true;
  var _init = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_init) {
      final productId = ModalRoute.of(context)!.settings.arguments;
      if (productId != null) {
        //mahsulot eski malumotini olish
        final _editingProduct =
            Provider.of<Products>(context).findById(productId as String);
        _product = _editingProduct;
      }
    }
    _init = false;
  }
  // final _priceFocus = FocusNode();

  // @override
  // void dispose() {
  //   super.dispose();
  //   _priceFocus.dispose();
  // }

  void _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Rasm URL ni kiriting"),
          content: Form(
            key: _imageForm,
            child: TextFormField(
              initialValue: _product.imageUrl,
              decoration: const InputDecoration(
                labelText: "Rasm URL",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Iltimos rasm URL kiriting!";
                } else if (!value.startsWith("http")) {
                  return "Iltimos, to'g'ri URL kiriting";
                }
                return null;
              },
              onSaved: (newValue) {
                _product = Product(
                  id: _product.id,
                  title: _product.title,
                  description: _product.description,
                  price: _product.price,
                  imageUrl: newValue!,
                  isFavorite: _product.isFavorite,
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Bekor qilish"),
            ),
            ElevatedButton(
              onPressed: _saveImageForm,
              child: const Text("Saqlash"),
            )
          ],
        );
      },
    );
  }

  void _saveImageForm() {
    final isValid = _imageForm.currentState!.validate();
    if (isValid) {
      _imageForm.currentState!.save();
      setState(() {
        _hasImage = true;
      });
      Navigator.of(context).pop();
    }
  }

  Future<void> _saveForm() async {
    FocusScope.of(context).unfocus();
    final isValid = _form.currentState!.validate();
    setState(() {
      _hasImage = _product.imageUrl.isNotEmpty;
    });
    if (isValid && _hasImage) {
      _form.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      if (_product.id.isEmpty) {
        try {
          await Provider.of<Products>(context, listen: false)
              .addProduct(_product);
        } catch (error) {
          await showDialog<Null>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Xatolik"),
                  content:
                      const Text("Mahsulot qo'shihsda xatolik sodir bo'ldi"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Ok"),
                    ),
                  ],
                );
              });
        }
        // finally {
        //   setState(() {
        //     _isLoading = false;
        //   });
        //   Navigator.of(context).pop();
        // }
      } else {
        try {
          await Provider.of<Products>(context, listen: false)
              .updateProduct(_product);
        } catch (e) {
          await showDialog<Null>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Xatolik"),
                  content:
                      const Text("Mahsulot qo'shihsda xatolik sodir bo'ldi"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Ok"),
                    ),
                  ],
                );
              });
        }
      }
      setState(() {
        _isLoading = true;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mahsulot qo'shish"),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Form(
                  key: _form,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: _product.title,
                          decoration: const InputDecoration(
                            labelText: "Nomi",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Iltimos, mahsulot nomini kiritng.";
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          onSaved: (newValue) {
                            _product = Product(
                              id: _product.id,
                              title: newValue!,
                              description: _product.description,
                              price: _product.price,
                              imageUrl: _product.imageUrl,
                              isFavorite: _product.isFavorite,
                            );
                          },
                          // onFieldSubmitted: (_) {
                          //   FocusScope.of(context).requestFocus(_priceFocus);
                          // },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          initialValue: _product.price == 0
                              ? ""
                              : _product.price.toStringAsFixed(2),
                          decoration: const InputDecoration(
                            labelText: "Narxi",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          onSaved: (newValue) {
                            _product = Product(
                              id: _product.id,
                              title: _product.title,
                              description: _product.description,
                              price: double.parse(newValue!),
                              imageUrl: _product.imageUrl,
                              isFavorite: _product.isFavorite,
                            );
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Iltimos, mahsulot narxini kiritng.";
                            } else if (double.tryParse(value) == null) {
                              return "Iltimos to'g'ri narx kiriting!";
                            } else if (double.parse(value) <= 0) {
                              return "Mahsulot narxi 0 dan katta bo'lishi kerak!";
                            }
                            return null;
                          },
                          // focusNode: _priceFocus,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          initialValue: _product.description,
                          decoration: const InputDecoration(
                            labelText: "Qo'shimcha malumot",
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          onSaved: (newValue) {
                            _product = Product(
                              id: _product.id,
                              title: _product.title,
                              description: newValue!,
                              price: _product.price,
                              imageUrl: _product.imageUrl,
                              isFavorite: _product.isFavorite,
                            );
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Iltimos, mahsulot tarifini kiritng.";
                            } else if (value.length < 10) {
                              return "Iltimos, batafsil ma'lumot kiriting!";
                            }
                            return null;
                          },
                          // focusNode: _priceFocus,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          margin: const EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(
                              color: _hasImage
                                  ? Colors.grey
                                  : Theme.of(context).errorColor,
                            ),
                          ),
                          child: InkWell(
                            onTap: () => _showImageDialog(context),
                            splashColor:
                                Theme.of(context).primaryColor.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(5),
                            highlightColor: Colors.transparent,
                            child: Container(
                              height: 180,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: _product.imageUrl.isEmpty
                                  ? Text(
                                      "Asosiy rasm URL ni kiriting!",
                                      style: TextStyle(
                                          color: _hasImage
                                              ? Colors.black
                                              : Theme.of(context).errorColor),
                                    )
                                  : Image.network(
                                      _product.imageUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            ),
    );
  }
}
