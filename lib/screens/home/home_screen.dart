


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:travelblog/models/post_model.dart';
import 'package:travelblog/viewmodels/auth_viewmodel.dart';
import 'package:travelblog/viewmodels/post_viewmodel.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({Key? key}): super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  late AuthViewModel _authViewModel;
  late PostViewModel _postViewModel;

  @override
  void initState(){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      _postViewModel = Provider.of<PostViewModel>(context, listen: false);
      refresh();
    });
    super.initState();
  }

  Future<void> refresh() async {
    _postViewModel.getPosts();
    _authViewModel.getMyPosts();
  }

  @override
  Widget build(BuildContext context){
    return Consumer2<AuthViewModel, PostViewModel>(
      builder: (context, authVM, postVM, child){
        return Stack(
          children: [
            Positioned.fill(
                child: Container(
              margin: const EdgeInsets.only(top:60),
              child: RefreshIndicator(
                onRefresh: refresh,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/banner.jpg",
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      WelcomeText(authVM),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Blog Posts"
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: GridView.count(
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.7,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          children: [
                            ...postVM.posts.map((e) => PostCard(e))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ),
            HomeHeader()
          ],
        );
      },
    );
  }

  Widget HomeHeader() {
    return Align(
        alignment: Alignment.topCenter,
        child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black26,
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(child: Container()),
                Expanded(child: Image.asset("assets/images/logo.jpg", height: 50, width: 50,)),
                Expanded(
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Container()
                      // Icon(Icons.search, size: 30,)
                    )),
              ],
            )));
  }

  Widget WelcomeText(AuthViewModel authVM) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Welcome,",
              style: GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.bold),
            )),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              authVM.loggedInUser != null ? authVM.loggedInUser!.name.toString() : "Guest",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )),
      ],
    );
  }

  Widget PostCard(PostModel postModel){
    return InkWell(
      onTap: (){
        Navigator.of(context).pushNamed("/single-post", arguments: postModel.id);
      },
      child: Container(
        width: 250,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Card(
          elevation: 5,
          child: Stack(
            children: [ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                postModel.imageUrl.toString(),
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception, StackTrace? stacktrace){
                  return Image.asset(
                    'assets/images/logo.jpg',
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Positioned.fill(
                child: Align(
              alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(color: Colors.white),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          postModel.postName.toString(),
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                        Text(
                          postModel.postDescription.toString(),
                          style: TextStyle(fontSize: 15, color: Colors.green),
                          textAlign: TextAlign.left,
                          maxLines: 2,
                        )
                      ],
                    ),
                  )
            ))],
          ),
        ),
      ),
    );
  }

































}