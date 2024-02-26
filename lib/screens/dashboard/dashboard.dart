import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelblog/screens/account/account_screen.dart';
import 'package:travelblog/viewmodels/auth_viewmodel.dart';
import 'package:travelblog/viewmodels/global_ui_viewmodel.dart';
import 'package:travelblog/viewmodels/product_viewmodel.dart';

class DashboardScreen extends StatefulWidget{
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>{
  PageController pageController = PageController();
  int selectedIndex = 0;
  _onPageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  _itemTapped(int selectedIndex){
    pageController.jumpToPage(selectedIndex);
    setState(() {
      this.selectedIndex = selectedIndex;
    });
  }
  late GlobalUIViewModel _ui;
  late AuthViewModel _authViewModel;
  late ProductViewModel _productViewModel;

  @override
  void initState(){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      _productViewModel = Provider.of<ProductViewModel>(context, listen: false);
      getInit();
    });
    super.initState();
  }
  void getInit(){
    try{
      _productViewModel.getProducts();
    }
    catch (e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFFf5f5f5),
      body: SafeArea(
        child: PageView(
          controller: pageController,
          children: <Widget>[AccountScreen()],
          onPageChanged: _onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(color: Colors.blue),
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        type: BottomNavigationBarType.fixed,
        onTap: _itemTapped,
        items:[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.add_photo_alternate), label: "Create Post"),
          BottomNavigationBarItem(icon: Icon(Icons.person_2), label: "Account"),

        ],
      ),
    );
  }
}