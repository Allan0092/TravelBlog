import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:travelblog/models/post_model.dart';
import 'package:travelblog/models/user_model.dart';
import 'package:travelblog/repositories/auth_repositories.dart';
import 'package:travelblog/services/firebase_service.dart';
import 'package:travelblog/viewmodels/global_ui_viewmodel.dart';
import '../repositories/post_repositories.dart';

class PostViewModel with ChangeNotifier {
  PostRepository _postRepository = PostRepository();
  List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;

  Future<void> getPosts() async{
    _posts=[];
    notifyListeners();
    try{
      var response = await _postRepository.getAllPosts();
      for (var element in response) {
        print(element.id);
        _posts.add(element.data());
      }
      notifyListeners();
    }catch(e){
      print(e);
      _posts = [];
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
