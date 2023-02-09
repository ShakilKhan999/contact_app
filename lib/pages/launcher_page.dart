import 'package:contact_app/auth_prefs.dart';
import 'package:contact_app/pages/contact_list_page.dart';
import 'package:contact_app/pages/login_page.dart';
import 'package:flutter/material.dart';

class LauncherPage extends StatefulWidget {
  static const String routename = '/launcher';
  const LauncherPage({Key? key}) : super(key: key);


  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
 @override
  void initState() {
   getLoginStatus().then((value){
     if(value){
       Navigator.pushReplacementNamed(context, ContactList.routename);
     }else{
       Navigator.pushReplacementNamed(context, LoginPage.routename);
     }
   });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
