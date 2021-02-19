
import 'dart:io';

import 'package:images/src/blocs/validators.dart';
import 'package:images/src/models/product_model.dart';
import 'package:images/src/providers/products_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc with Validators{
  final _productsController = BehaviorSubject<List<Product>>();
  final _loadingController = BehaviorSubject<bool>();

  final productProvider = ProductsProvider();

  Stream<List<Product>> get getProducts =>_productsController.stream;
  Stream<bool> get loading =>_loadingController.stream;

  getProds() async {
    _productsController.sink.add(await productProvider.getProducts());
  }

  createProduct(Product product) async {
    _loadingController.sink.add(true);
    await productProvider.createProduct(product);
    getProds();
    _loadingController.sink.add(false);
  }

  editProduct(Product product) async {
    _loadingController.sink.add(true);
    await productProvider.editProduct(product);
    getProds();
    _loadingController.sink.add(false);
  }

  deleteProduct(String id) async {
    await productProvider.deleteProduct(id);
  }

  Future<String> uploadImage(File file) async {
    _loadingController.sink.add(true);
    final foto = await productProvider.uploadImage(file);
    _loadingController.sink.add(false);
    return foto;
  }

  dispose(){
    _productsController?.close();
    _loadingController?.close();
  }
}