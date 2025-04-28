import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:refresher/constants/color_scheme.dart';

class LoginPageView extends StatefulWidget {
  const LoginPageView({super.key});

  @override
  State<LoginPageView> createState() => _LoginPageViewState();
}

// when register now is pressed
_registerNow() {}

class _LoginPageViewState extends State<LoginPageView> {
  // form key
  final _formKey = GlobalKey<FormState>();
  // controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = false;

  // when login button is pressed
  void _loginButton() async {
    Navigator.pushNamed(context, 'event_list_screen');
    // if (_formKey.currentState!.validate()) {
    //   // Add your login logic here
    //   try {
    //     final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
    //       email: emailController.text,
    //       password: passwordController.text,
    //     );

    //     if (user.user != null) {

    //     }
    //   } on FirebaseAuthException catch (e) {
    //     if (e.code == 'weak-password') {
    //       print('The password provided is too weak.');
    //     } else if (e.code == 'email-already-in-use') {
    //       print('The account already exists for that email.');
    //     }
    //   } catch (e) {
    //     print("This is the error: $e");
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // image logo
              SizedBox(
                width: 200,
                height: 100,
                child: const Image(
                  image: AssetImage('assets/images/refresher-logo.png'),
                ),
              ),
              SizedBox(height: 15),
              // login
              Text(
                "LOGIN",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // email field
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  hintText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email";
                  }

                  if (!value.contains('@')) {
                    return "Please enter a valid email";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // password field
              TextFormField(
                controller: passwordController,
                obscureText: isPasswordVisible,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  hintText: 'Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password can't be empty";
                  }

                  if (value.length < 8) {
                    return "Password must be at least 8 characters";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // login button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loginButton,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Login', style: TextStyle(fontSize: 16)),
                ),
              ),

              // forgot password & remember
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 12),
                  ),
                  TextButton(
                    onPressed: _registerNow,
                    child: Text(
                      "Register Now",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
