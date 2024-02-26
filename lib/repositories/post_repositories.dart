import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class PostRepository {
  CollectionReference<PostModel> postRef =
     FirebaseService.db.collection("posts").withConverter<PostModel>(
            fromFirestore: (snapshot, _) {
              return PostModel.fromFirebaseSnapshot(snapshot);
            },
            toFirestore: (model, _) => model.toJson(),
          );

  Future<List<QueryDocumentSnapshot<PostModel>>> getAllPosts() async {
    try {
      final response = await postRef.get();
      var posts = response.docs;
      return posts;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<List<QueryDocumentSnapshot<PostModel>>> getPostByCategory(
      String id) async {
    try {
      final response =
          await postRef.where("category_id", isEqualTo: id.toString()).get();
      var posts = response.docs;
      return posts;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<List<QueryDocumentSnapshot<PostModel>>> getPostFromList(
      List<String> productIds) async {
    try {
      final response = await postRef
          .where(FieldPath.documentId, whereIn: productIds)
          .get();
      var posts = response.docs;
      return posts;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<List<QueryDocumentSnapshot<PostModel>>> getMyPosts(
      String userId) async {
    try {
      final response =
          await postRef.where("user_id", isEqualTo: userId).get();
      var posts = response.docs;
      return posts;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<bool> removePost(String postId, String userId) async {
    try {
      final response = await postRef.doc(postId).get();
      if (response.data()!.userId != userId) {
        return false;
      }
      await postRef.doc(postId).delete();
      return true;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<DocumentSnapshot<PostModel>> getOnePost(String id) async {
    try {
      final response = await postRef.doc(id).get();
      if (!response.exists) {
        throw Exception("Product doesnot exists");
      }
      return response;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<bool?> addPosts({required PostModel post}) async {
    try {
      final response = await postRef.add(post);
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<bool?> editPost(
      {required PostModel post, required String postId}) async {
    try {
      final response = await postRef.doc(postId).set(post);
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<bool?> favorites({required PostModel product}) async {
    try {
      final response = await postRef.add(product);
      return true;
    } catch (err) {
      return false;
      rethrow;
    }
  }
}
