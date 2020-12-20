import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:ratingApp/route_paths.dart' as routes;

import '../../../locator.dart';
import '../../../navigation_service.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

//2
class SignIn extends StatefulWidget {
  final String title = 'Sign In';

  @override
  State<StatefulWidget> createState() =>
      _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success;
  String _userEmail;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText:
              'Password'),
              obscureText: true,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              alignment: Alignment.center,
              child: RaisedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _signIn();
                  }
                },
                child: const Text('Login'),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              alignment: Alignment.center,
              child: RaisedButton(
                onPressed: () async {
                  registerPage();
                },
                child: const Text('Register'),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(_success == null
                  ? ''
                  : (_success
                  ? 'Successfully signed in ' + _userEmail
                  : 'Sign in failed')),
            )
          ],
        ),
      ),
    );
  }

  void _signIn() async {
    try {
      final User user = (await
      _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      )
      ).user;

      if (user != null) {
        setState(() {
          _success = true;
          _userEmail = user.email;
          locator<NavigationService>().navigateTo(routes.HomeRoute);
        });
      } else {
        setState(() {
          _success = false;
        });
      }
    } catch (error) {
      setState(() {
        _success = false;
      });
      print(error);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void registerPage() {
    locator<NavigationService>().navigateTo(routes.RegisterRoute);
  }
}