import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travelblog/models/post_model.dart';
import 'package:travelblog/models/user_model.dart';
import 'package:travelblog/repositories/auth_repositories.dart';
import 'package:travelblog/services/firebase_service.dart';
import 'package:travelblog/viewmodels/global_ui_viewmodel.dart';

import '../repositories/post_repositories.dart';

class SinglePostViewModel with ChangeNotifier {
  final PostRepository _postRepository = PostRepository();
  PostModel? _post = PostModel();
  PostModel? get product => _post;

  Future<void> getPosts(String postId) async{
    _post=PostModel();
    notifyListeners();
    try{
      var response = await _postRepository.getOnePost(postId);
      _post = response.data();
      notifyListeners();
    }catch(e){
      _post = null;
      notifyListeners();
    }
  }

  Future<void> addPost(PostModel post) async{
    try{
      var response = await _postRepository.addPosts(post: post);
    }catch(e){
      notifyListeners();
    }
  }

}
