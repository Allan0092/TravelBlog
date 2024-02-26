import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travelblog/models/post_model.dart';
import 'package:travelblog/models/user_model.dart';
import 'package:travelblog/repositories/auth_repositories.dart';
import 'package:travelblog/services/firebase_service.dart';
import 'package:travelblog/viewmodels/global_ui_viewmodel.dart';


import '../repositories/post_repositories.dart';

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


  List<PostModel>? _favoriteProduct;
  List<PostModel>? get favoriteProduct => _favoriteProduct;





  List<PostModel>? _myPost;
  List<PostModel>? get myPost => _myPost;

  Future<void> getMyPosts() async {
    try {
      var productResponse =
          await PostRepository().getMyPosts(loggedInUser!.userId!);
      _myPost = [];
      for (var element in productResponse) {
        _myPost!.add(element.data());
      }
      notifyListeners();
    } catch (e) {
      print(e);
      _myPost = null;
      notifyListeners();
    }
  }

  Future<void> addMyPost(PostModel post) async {
    try {
      await PostRepository().addPosts(post: post);

      await getMyPosts();
      notifyListeners();
    } catch (e) {}
  }

  Future<void> editMyPost(PostModel post, String postId) async {
    try {
      await PostRepository()
          .editPost(post: post, postId: postId);
      await getMyPosts();
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteMyPost(String postId) async {
    try {
      await PostRepository().removePost(postId, loggedInUser!.userId!);
      await getMyPosts();
      notifyListeners();
    } catch (e) {
      print(e.toString());
      _myPost = null;
      notifyListeners();
    }
  }
}
