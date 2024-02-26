import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:travelblog/services/firebase_service.dart';

class FileUpload{
  Reference storage = FirebaseService.storageRef;

  Future<ImagePath?> uploadImage({required String selectedPath , String? deletePath}) async{
    try{
      String dt = DateTime.now().millisecondsSinceEpoch.toString();
      if(deletePath !=null){
        storage.child(deletePath).delete();
      }
      var photo = await storage.child("posts").child("$dt.jpg").putFile(File(selectedPath));
      String photoUrl = await photo.ref.getDownloadURL();
      return ImagePath(
        imageUrl: photoUrl,
        imagePath: photo.ref.fullPath
      );
    }catch(e){
      print(e.toString());
      return null;
    }
  }


  Future<bool?> deleteImage({String? deletePath}) async{
    try{
      if(deletePath !=null){
        await storage.child(deletePath).delete();
      }
      return true;
    }catch(e){
      print(e.toString());
      return false;
    }
  }
}

class ImagePath {
  ImagePath({
    this.imageUrl,
    this.imagePath,
  });
  String? imageUrl;
  String? imagePath;
}
