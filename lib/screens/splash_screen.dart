import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travelblog/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';

import '../services/local_notification_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AuthViewModel _authViewModel;

  void checkLogin() async{
    String? token = await FirebaseMessaging.instance.getToken();

    await Future.delayed(Duration(seconds: 2));
    // check for user detail first
    try{
      await _authViewModel.checkLogin(token);
      if(_authViewModel.user==null){
        Navigator.of(context).pushReplacementNamed("/login");
      }else{
        NotificationService.display(
          title: "Welcome back",
          body: "Welcome back ${_authViewModel.loggedInUser?.name}",
        );
        Navigator.of(context).pushReplacementNamed("/dashboard");
      }
    }catch(e){
      Navigator.of(context).pushReplacementNamed("/login");
    }

  }
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    });
    checkLogin();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/images/splash.jpg"),
              SizedBox(height: 100,),
              Text("Travel Blog", style: TextStyle(
                fontSize: 22
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
