import 'package:flutter/material.dart';
import 'package:refresher/components/app_button.dart';

class RegisterPageView extends StatefulWidget {
  const RegisterPageView({super.key});

  @override
  State<RegisterPageView> createState() => _RegisterPageViewState();
}

// when register now is pressed
_login() {}

class _RegisterPageViewState extends State<RegisterPageView> {
  // form key
  final _formKey = GlobalKey<FormState>();
  // controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  // password visibility
  bool isPasswordVisible = false;

  // reusable outline input border
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
  );

  // when login button is pressed
  void _registerButton() async {
    if (_formKey.currentState!.validate()) {
      // Add your login logic here
      // try {
      //   final newUser = await FirebaseAuth.instance
      //       .createUserWithEmailAndPassword(
      //         email: emailController.text,
      //         password: passwordController.text,
      //       );

      //   if (newUser.user != null) {
      //     Navigator.pushNamed(context, 'home_page');
      //   }
      // } on FirebaseAuthException catch (e) {
      //   if (e.code == 'weak-password') {
      //     print('The password provided is too weak.');
      //   } else if (e.code == 'email-already-in-use') {
      //     print('The account already exists for that email.');
      //   }
      // } catch (e) {
      //   print("This is the error: $e");
      // }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
                "REGISTER",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // name field
              // TextFormField(
              //   controller: nameController,
              //   decoration: InputDecoration(
              //     prefixIcon: Icon(Icons.account_circle_sharp),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(16),
              //     ),
              //     hintText: 'Name',
              //   ),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return "Please enter your name";
              //     }
              //     return null;
              //   },
              // ),
              // SizedBox(height: 20),

              // email field
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  border: outlineInputBorder,
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
                  border: outlineInputBorder,
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

              // confirm password field
              TextFormField(
                controller: confirmPasswordController,
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
                  border: outlineInputBorder,
                  hintText: 'Confirm Password',
                ),
                validator: (value) {
                  if (passwordController.text != value) {
                    return "Password does not match";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // login button
              AppButton(onPressed: _registerButton, buttonText: "Register"),

              // forgot password & remember
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(fontSize: 12),
                  ),
                  TextButton(
                    onPressed: _login,
                    child: Text(
                      "Login",
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
