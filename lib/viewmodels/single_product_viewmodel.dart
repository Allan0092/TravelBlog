import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travelblog/models/product_model.dart';
import 'package:travelblog/models/user_model.dart';
import 'package:travelblog/repositories/auth_repositories.dart';
import 'package:travelblog/services/firebase_service.dart';
import 'package:travelblog/viewmodels/global_ui_viewmodel.dart';

import '../repositories/product_repositories.dart';

class SingleProductViewModel with ChangeNotifier {
  final ProductRepository _productRepository = ProductRepository();
  ProductModel? _product = ProductModel();
  ProductModel? get product => _product;

  Future<void> getProducts(String productId) async{
    _product=ProductModel();
    notifyListeners();
    try{
      var response = await _productRepository.getOneProduct(productId);
      _product = response.data();
      notifyListeners();
    }catch(e){
      _product = null;
      notifyListeners();
    }
  }

  Future<void> addProduct(ProductModel product) async{
    try{
      var response = await _productRepository.addProducts(product: product);
    }catch(e){
      notifyListeners();
    }
  }

}
