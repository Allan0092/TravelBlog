// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

PostModel? postModelFromJson(String str) => PostModel.fromJson(json.decode(str));

String postModelToJson(PostModel? data) => json.encode(data!.toJson());

class PostModel {
  PostModel({
    this.id,
    this.userId,
    this.postName,
    this.postDescription,
    this.imageUrl,
    this.imagePath,
  });

  String? id;
  String? userId;
  String? postName;
  String? postDescription;
  String? imageUrl;
  String? imagePath;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    id: json["id"],
    userId: json["user_id"],
    postName: json["postName"],
    postDescription: json["postDescription"],
    imageUrl: json["imageUrl"],
    imagePath: json["imagePath"],
  );



  factory PostModel.fromFirebaseSnapshot(DocumentSnapshot<Map<String, dynamic>> json) => PostModel(
    id: json.id,
    userId: json["user_id"],
    postName: json["postName"],
    postDescription: json["postDescription"],
    imageUrl: json["imageUrl"],
    imagePath: json["imagePath"],
  );


  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "postName": postName,
    "postDescription": postDescription,
    "imageUrl": imageUrl,
    "imagePath": imagePath,
  };
}
