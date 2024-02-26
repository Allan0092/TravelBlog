import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelblog/models/post_model.dart';
import 'package:travelblog/viewmodels/auth_viewmodel.dart';
import 'package:travelblog/viewmodels/global_ui_viewmodel.dart';

class MyPostScreen extends StatefulWidget {
  const MyPostScreen({Key? key}) : super(key: key);

  @override
  State<MyPostScreen> createState() => _MyPostScreenState();
}

class _MyPostScreenState extends State<MyPostScreen> {
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

  Future<void> getInit() async {
    _ui.loadState(true);
    try{
      await _authViewModel.getMyPosts();
    }catch(e){
      print(e);
    }
    _ui.loadState(false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(builder: (context, authVM, child){
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("My Posts"),
        ),
        body: RefreshIndicator(
          onRefresh: getInit,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                if (_authViewModel.myPost != null && _authViewModel.myPost!.isEmpty) Center(child: Text("You can add your posts here")),
                if (_authViewModel.myPost != null) ...authVM.myPost!.map((e) => PostWidgetList(context, e))
              ],
            ),
          ),
        )
      );
    });
  }

  InkWell PostWidgetList(BuildContext context, PostModel postModel){
    return InkWell(
      onTap: (){
        Navigator.of(context).pushNamed("/single-product", arguments: postModel.id);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Card(
          elevation: 5,
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                postModel.imageUrl.toString(),
                height: 300,
                width: 100,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object excepiton, StackTrace? stackTrace){
                  return Image.asset(
                    'assets/images/logo.jpg',
                    height: 300,
                    width: 100,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            title: Text(postModel.postName.toString()),
            subtitle: Text(postModel.postDescription.toString()),
            trailing: Wrap(
              children: [
                IconButton(onPressed: (){
                  Navigator.of(context).pushNamed("/edit-post", arguments: postModel.id);
                },
                    icon: Icon(Icons.edit),
                ),
                IconButton(onPressed: (){
                  deletePost(postModel.id.toString());
                }, icon: Icon(Icons.delete),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> deletePost(String id) async{
    var response = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete post?'),
            content: Text('Are you sure you want to delete this post?'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close')),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  deleteFunction(id);
                },
                child: Text('Delete'),
              )
            ],
          );
        });
  }
  deleteFunction(String id) async{

    _ui.loadState(true);
    try{
      await _authViewModel.deleteMyPost(id);
    }catch(e){
      print(e);
    }
    _ui.loadState(false);
  }




































}