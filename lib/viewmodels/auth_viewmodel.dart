import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travelblog/models/product_model.dart';
import 'package:travelblog/models/user_model.dart';
import 'package:travelblog/repositories/auth_repositories.dart';
import 'package:travelblog/services/firebase_service.dart';
import 'package:travelblog/viewmodels/global_ui_viewmodel.dart';


import '../repositories/product_repositories.dart';

class AuthViewModel with ChangeNotifier {
  int _a = 1;
  int get a => _a;

  addValue() {
    _a++;
  }

  User? _user = FirebaseService.firebaseAuth.currentUser;

  User? get user => _user;

  UserModel? _loggedInUser;
  UserModel? get loggedInUser => _loggedInUser;

  Future<void> login(String email, String password) async {
    try {
      var response = await AuthRepository().login(email, password);
      _user = response.user;
      _loggedInUser = await AuthRepository().getUserDetail(_user!.uid, _token);
      notifyListeners();
    } catch (err) {
      AuthRepository().logout();
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await AuthRepository().resetPassword(email);
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  Future<void> register(UserModel user) async {
    try {
      var response = await AuthRepository().register(user);
      _user = response!.user;
      _loggedInUser = await AuthRepository().getUserDetail(_user!.uid, _token);
      notifyListeners();
    } catch (err) {
      AuthRepository().logout();
      rethrow;
    }
  }

  String? _token;
  String? get token => _token;
  Future<void> checkLogin(String? token) async {
    try {
      _loggedInUser = await AuthRepository().getUserDetail(_user!.uid, token);
      _token = token;
      notifyListeners();
    } catch (err) {
      _user = null;
      AuthRepository().logout();
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await AuthRepository().logout();
      _user = null;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }


  List<ProductModel>? _favoriteProduct;
  List<ProductModel>? get favoriteProduct => _favoriteProduct;





  List<ProductModel>? _myProduct;
  List<ProductModel>? get myProduct => _myProduct;

  Future<void> getMyProducts() async {
    try {
      var productResponse =
          await ProductRepository().getMyProducts(loggedInUser!.userId!);
      _myProduct = [];
      for (var element in productResponse) {
        _myProduct!.add(element.data());
      }
      notifyListeners();
    } catch (e) {
      print(e);
      _myProduct = null;
      notifyListeners();
    }
  }

  Future<void> addMyProduct(ProductModel product) async {
    try {
      await ProductRepository().addProducts(product: product);

      await getMyProducts();
      notifyListeners();
    } catch (e) {}
  }

  Future<void> editMyProduct(ProductModel product, String productId) async {
    try {
      await ProductRepository()
          .editProduct(product: product, productId: productId);
      await getMyProducts();
      notifyListeners();
    } catch (e) {}
  }

  Future<void> deleteMyProduct(String productId) async {
    try {
      await ProductRepository().removeProduct(productId, loggedInUser!.userId!);
      await getMyProducts();
      notifyListeners();
    } catch (e) {
      print(e);
      _myProduct = null;
      notifyListeners();
    }
  }
}