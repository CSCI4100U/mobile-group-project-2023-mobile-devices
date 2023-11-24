import 'package:elevar_fitness_tracker/components/rounded_button.dart';
import 'package:elevar_fitness_tracker/components/rounded_input_field.dart';
import 'package:flutter/material.dart';
import 'package:elevar_fitness_tracker/materials/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:elevar_fitness_tracker/home_page/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginSignupPage extends StatefulWidget {
  const LoginSignupPage({super.key});

  @override
  LoginSignupPageState createState() => LoginSignupPageState();
}

class LoginSignupPageState extends State<LoginSignupPage> {
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((sharedPrefs) {
      setState(() {
        prefs = sharedPrefs;
      });
    });
    
    // If we somehow get here despite being logged in, just go to home screen
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _navigateToHomeIfLoggedIn();
    });
  }

  void _navigateToHomeIfLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String username = prefs.getString('username') ?? "";
    String password = prefs.getString('password') ?? "";

    if (username.isNotEmpty && password.isNotEmpty) {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    }
  }

  bool isOnLogin = true;

  @override
  Widget build(BuildContext context) {
    return LoginBody(prefs);
  }
}

enum LoginResult { success, emptyUsername, emptyPassword, noAccount, incorrectPassword }

class LoginBody extends StatefulWidget {
  const LoginBody(this.prefs, {super.key});
  final SharedPreferences? prefs;

  @override
  LoginBodyState createState() => LoginBodyState();
}

class LoginBodyState extends State<LoginBody> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<LoginResult> tryLogin() async {
    if (usernameController.text.isEmpty) {
      return LoginResult.emptyUsername;
    } else if (passwordController.text.isEmpty) {
      return LoginResult.emptyPassword;
    }

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final emailResult = await users.doc(usernameController.text).get();

    if (!emailResult.exists) {
      return LoginResult.noAccount;
    }

    Map<String, dynamic> data = emailResult.data() as Map<String, dynamic>;
    if (data['password'] == passwordController.text) {
      return LoginResult.success;
    } else {
      return LoginResult.incorrectPassword;
    }
  }

  String? usernameError;
  String? passwordError;

  bool hidePassword = true;
  void flipHidePassword() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isDarkMode = widget.prefs?.getBool('darkmode') ?? false;
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppStyles.backgroundColor(isDarkMode),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, top: size.height / 4, bottom: 10),
            child: Text(
              "Login",
              style: TextStyle(
                fontFamily: 'Geologica',
                fontSize: 48,
                fontWeight: FontWeight.w800,
                color: AppStyles.textColor(isDarkMode)
              )
            ),
          ),
          RoundedInputField(
            hintText: "Username",
            controller: usernameController,
            icon: CupertinoIcons.person_crop_circle_fill,
            onChanged: (value) {},
            errorText: usernameError,
            prefs: widget.prefs
          ),
          RoundedInputField(
            hintText: "Password",
            controller: passwordController,
            icon: CupertinoIcons.lock_fill,
            onChanged: (value) {},
            errorText: passwordError,
            prefs: widget.prefs,
            hidden: hidePassword,
            updateHiddenFn: flipHidePassword,
          ),
          RoundedButton("Login", () {
            tryLogin().then((result) {
              switch (result) {
                case LoginResult.success:
                  setState(() {
                    usernameError = null;
                    passwordError = null;
                  });

                  widget.prefs?.setString('username', usernameController.text);
                  widget.prefs?.setString('password', passwordController.text);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                case LoginResult.emptyUsername:
                  setState(() {
                    usernameError = "Username cannot be empty";
                    passwordError = null;
                  });
                case LoginResult.emptyPassword:
                  setState(() {
                    usernameError = null;
                    passwordError = "Password cannot be empty";
                  });
                case LoginResult.incorrectPassword:
                  setState(() {
                    usernameError = null;
                    passwordError = "Incorrect password";
                  });
                case LoginResult.noAccount:
                  setState(() {
                    usernameError = "Username not found";
                    passwordError = null;
                  });
                default:
                  setState(() {
                    usernameError = null;
                    passwordError = null;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Error occured while logging in."),)
                  );
              }
            });
          }, widget.prefs),
          const Spacer(),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: TextStyle(
                    fontFamily: 'Geologica',
                    fontSize: 14,
                    color: AppStyles.accentColor(isDarkMode).withOpacity(0.5)
                  )
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontFamily: 'Geologica',
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppStyles.accentColor(isDarkMode)
                    )
                  )
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}