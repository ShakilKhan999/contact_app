import 'package:contact_app/auth_prefs.dart';
import 'package:contact_app/pages/contact_list_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static const String routename = '/login';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emaiController = TextEditingController();
  final passController = TextEditingController();
  bool isObscure = true;

  @override
  void dispose() {
    emaiController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emaiController,
                decoration: const InputDecoration(
                    labelText: 'Email', prefixIcon: Icon(Icons.email)),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: passController,
                keyboardType: TextInputType.phone,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                          isObscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                  child:
                      TextButton(onPressed: () {
                        setLoginStatus(true).then((value){
                          Navigator.pushReplacementNamed(context, ContactList.routename);
                        });
                      },
                          child: const Text('LogIn')))
            ],
          ),
        ),
      ),
    );
  }
}
