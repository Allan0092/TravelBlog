import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/post_model.dart';
import '../../services/file_upload.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/global_ui_viewmodel.dart';
import '../../viewmodels/post_viewmodel.dart';

class CreatePostScreen extends StatefulWidget{
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  TextEditingController _postNameController = TextEditingController();
  TextEditingController _postDescriptionController = TextEditingController();
  void savePost() async{
    _ui.loadState(true);
    try{
      final PostModel data= PostModel(
        imagePath: imagePath,
        imageUrl: imageUrl,
        postDescription: _postDescriptionController.text,
        postName: _postNameController.text,
        userId: _authViewModel.loggedInUser!.userId,
      );
      await _authViewModel.addMyProduct(data);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Success")));
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed("dashboard");
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error")));
    }
    _ui.loadState(false);
  }
  late GlobalUIViewModel _ui;
  late AuthViewModel _authViewModel;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      getInit();
    });
    super.initState();
  }

  getInit() async {

    _ui.loadState(false);
  }
  String? selectedCategory;

  // image uploader
  String? imageUrl;
  String? imagePath;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    var selected = await _picker.pickImage(source: source, imageQuality: 100);
    if (selected != null) {
      setState(() {
        imageUrl = null;
        imagePath=null;
      });

      _ui.loadState(true);
      try{
        ImagePath? image = await FileUpload().uploadImage(selectedPath: selected.path);
        if(image!=null){
          setState(() {
            imageUrl = image.imageUrl;
            imagePath = image.imagePath;
          });
        }
      }catch(e){}

      _ui.loadState(false);
    }
  }

  void deleteImage() async {

    _ui.loadState(true);
    try{

      await FileUpload().deleteImage(deletePath: imagePath.toString()).then((value){
        setState(() {
          imagePath=null;
          imageUrl=null;
        });
      });
    }catch(e){}

    _ui.loadState(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text("Create A Post"),
      ),
      body: Consumer<PostViewModel>(
          builder: (context, categoryVM, child) {
            return SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SizedBox(height: 10,),

                      TextFormField(
                        controller: _postNameController,
                        // validator: ValidateProduct.username,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          border: InputBorder.none,
                          label: Text("Post Title"),
                          hintText: 'Enter post title',
                        ),
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        controller: _postDescriptionController,
                        // validator: ValidateProduct.username,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          border: InputBorder.none,
                          label: Text("Post Description"),
                          hintText: 'Enter post description',
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Add Image"),
                            SizedBox(width: 10,),
                            IconButton(onPressed: (){
                              _pickImage(ImageSource.camera);
                            },
                                icon: Icon(Icons.camera)),
                            SizedBox(width: 5,),
                            IconButton(onPressed: (){
                              _pickImage(ImageSource.gallery);
                            },
                                icon: Icon(Icons.photo))
                          ],
                        ),
                      ),
                      imageUrl !=null ?
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Image.network(imageUrl!, height: 50, width: 50,),
                          Text(imagePath.toString()),
                          IconButton(onPressed: (){
                            deleteImage();
                          },
                              icon: Icon(Icons.delete, color: Colors.red,)),
                        ],
                      )
                          : Container(),
                      SizedBox(height: 10,),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                            key: Key('addProduct'),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(color: Colors.blue)
                                  )
                              ),
                              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 10)),
                            ),
                            onPressed: (){
                              savePost();
                            }, child: Text("Post", style: TextStyle(
                            fontSize: 20
                        ),)),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.orange) ,
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(color: Colors.orange)
                                  )
                              ),
                              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 10)),
                            ),
                            onPressed: (){
                              Navigator.of(context).pop();
                              Navigator.of(context).pushNamed("/dashboard");

                            }, child: Text("Cancel", style: TextStyle(
                            fontSize: 20
                        ),)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
      ),
    );
  }

}
