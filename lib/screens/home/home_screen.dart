


import 'package:flutter/cupertino.dart';
import 'package:travelblog/viewmodels/auth_viewmodel.dart';
import 'package:travelblog/viewmodels/post_viewmodel.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({Key? key}): super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  late AuthViewModel _authViewModel;
  late PostViewModel productViewModel;
}