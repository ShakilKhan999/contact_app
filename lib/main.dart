import 'package:contact_app/pages/contact_details_page.dart';
import 'package:contact_app/pages/contact_list_page.dart';
import 'package:contact_app/pages/launcher_page.dart';
import 'package:contact_app/pages/login_page.dart';
import 'package:contact_app/pages/new_contact_page.dart';
import 'package:contact_app/providers/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> ContactProvider() .. getAllContact())
      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      initialRoute: LauncherPage.routename,
      routes: {
        ContactList.routename :(context)=> ContactList(),
        NewContact.routename: (context)=> NewContact(),
        ContactDetails.routename:(context) =>ContactDetails(),
        LoginPage.routename:(context) => LoginPage(),
        LauncherPage.routename:(context)=> LauncherPage()
      },
    );
  }
}

