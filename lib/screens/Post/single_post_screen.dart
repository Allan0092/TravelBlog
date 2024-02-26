import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:travelblog/viewmodels/auth_viewmodel.dart';
import 'package:travelblog/viewmodels/global_ui_viewmodel.dart';
import 'package:travelblog/viewmodels/single_post_viewmodel.dart';

class SinglePostScreen extends StatefulWidget {
  const SinglePostScreen({Key? key}): super(key: key);

  @override
  State<SinglePostScreen> createState() => _SinglePostScreenState();
}

class _SinglePostScreenState extends State<SinglePostScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SinglePostScreen>(
        create: (_) => SinglePostViewModel(), child: SinglePostBody());
  }
}

class SinglePostBody extends StatefulWidget {
  const SinglePostBody({Key? key}) : super(key: key);

  @override
  State<SinglePostBody> createState() => _SinglePostBodyState();
}

class _SinglePostBodyState extends State<SinglePostBody> {
  late SinglePostViewModel _singlePostViewModel;
  late GlobalUIViewModel _ui;
  late AuthViewModel _authViewModel;
  String? postId;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _singlePostViewModel = Provider.of<SinglePostViewModel>(context, listen: false);
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
      final args = ModalRoute.of(context)!.settings.arguments.toString();
      setState(() {
        postId = args;
      });
      print(args);
      getData(args);
    });
    super.initState();
  }

  Future<void> getData(String postId) async {
    _ui.loadState(true);
    try{
      await _singlePostViewModel.getPosts(postId);
    }catch(e){
      print(e.toString());
    }
    _ui.loadState(false);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }



}
































