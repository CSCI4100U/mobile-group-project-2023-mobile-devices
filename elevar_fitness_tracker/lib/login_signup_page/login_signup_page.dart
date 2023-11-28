import 'package:elevar_fitness_tracker/components/rounded_button.dart';
import 'package:elevar_fitness_tracker/components/rounded_date_field.dart';
import 'package:elevar_fitness_tracker/components/rounded_input_field.dart';
import 'package:elevar_fitness_tracker/home_page/page_bodies/account_body.dart';
import 'package:flutter/material.dart';
import 'package:elevar_fitness_tracker/materials/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:elevar_fitness_tracker/home_page/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginSignupPage extends StatefulWidget {
  const LoginSignupPage({
    this.username = "",
    this.email = "",
    this.password = "",
    this.showSignup = false,
    super.key}
  );
  final String username;
  final String email;
  final String password;
  final bool showSignup;

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

  @override
  Widget build(BuildContext context) {
    return widget.showSignup ? SignupBody(
      prefs: prefs,
      username: widget.username,
      email: widget.email,
      password: widget.password) : LoginBody(prefs);
  }
}

Route _createSlidingRoute(Widget page, bool slideRight) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      Offset begin = slideRight ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                          
      return SlideTransition(
        position: animation.drive(tween),
        child: child
      );
    }
  );
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
    final userResult = await users.doc(usernameController.text).get();

    if (!userResult.exists) {
      return LoginResult.noAccount;
    }

    Map<String, dynamic> data = userResult.data() as Map<String, dynamic>;
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
            padding: EdgeInsets.only(left: 20, top: size.height / 3.65, bottom: 10),
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
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      _createSlidingRoute(const LoginSignupPage(showSignup: true,), true),
                    );
                  },
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

enum SignupResult { success, emptyUsername, emptyEmail, emptyPassword, usernameExists }

class SignupBody extends StatefulWidget {
  const SignupBody(
    {
      this.username = "",
      this.email = "",
      this.password = "",
      this.prefs,
      super.key
    }
  );
  final String username;
  final String email;
  final String password;
  final SharedPreferences? prefs;

  @override
  State<SignupBody> createState() => SignupBodyState();
}

class SignupBodyState extends State<SignupBody> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? usernameError;
  String? emailError;
  String? passwordError;

  @override
  void initState() {
    super.initState();
    usernameController.text = widget.username;
    emailController.text = widget.email;
    passwordController.text = widget.password;
  }

  bool hidePassword = true;
  void flipHidePassword() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  Future<SignupResult> trySignup() async {
    if (usernameController.text.isEmpty) {
      return SignupResult.emptyUsername;
    }

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final userResult = await users.doc(usernameController.text).get();

    if (userResult.exists) {
      return SignupResult.usernameExists;
    } else if (emailController.text.isEmpty) {
      return SignupResult.emptyEmail;
    } else if (passwordController.text.isEmpty) {
      return SignupResult.emptyPassword;
    }

    return SignupResult.success;
  }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isDarkMode = widget.prefs?.getBool('darkmode') ?? false;
    double offset = MediaQuery.of(context).viewInsets.bottom > 0 ? 5.2 : 3.65;
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppStyles.backgroundColor(isDarkMode),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, top: size.height / offset, bottom: 10),
            child: Text(
              "Sign Up",
              style: TextStyle(
                fontFamily: 'Geologica',
                fontSize: 48,
                fontWeight: FontWeight.w800,
                color: AppStyles.textColor(isDarkMode)
              )
            ),
          ),
          ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: [
              RoundedInputField(
                hintText: "Username",
                controller: usernameController,
                icon: CupertinoIcons.person_crop_circle_fill,
                onChanged: (value) {},
                errorText: usernameError,
                prefs: widget.prefs
              ),
              RoundedInputField(
                hintText: "E-mail",
                controller: emailController,
                icon: CupertinoIcons.mail_solid,
                onChanged: (value) {},
                errorText: emailError,
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
              RoundedButton("Continue", () {
                trySignup().then((result) {
                  switch (result) {
                    case SignupResult.success:
                      setState(() {
                        usernameError = null;
                        emailError = null;
                        passwordError = null;
                      });

                      Navigator.pushReplacement(
                        context,
                        _createSlidingRoute(AccountInfoBody(
                          usernameController.text,
                          emailController.text,
                          passwordController.text,
                          widget.prefs), true),
                      );
                    case SignupResult.emptyUsername:
                      setState(() {
                        usernameError = "Username cannot be empty";
                        emailError = null;
                        passwordError = null;
                      });
                    case SignupResult.emptyEmail:
                      setState(() {
                        usernameError = null;
                        emailError = "E-mail cannot be empty";
                        passwordError = null;
                      });
                    case SignupResult.emptyPassword:
                      setState(() {
                        usernameError = null;
                        emailError = null;
                        passwordError = "Password cannot be empty";
                      });
                    case SignupResult.usernameExists:
                      setState(() {
                        usernameError = "Username already exists";
                        emailError = null;
                        passwordError = null;
                      });
                    default:
                      setState(() {
                        usernameError = null;
                        emailError = null;
                        passwordError = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Error occured while signing up."),)
                      );
                  }
                });
              }, widget.prefs),
            ],
          ),
          const Spacer(),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(
                      fontFamily: 'Geologica',
                      fontSize: 14,
                      color: AppStyles.accentColor(isDarkMode).withOpacity(0.5)
                    )
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        _createSlidingRoute(const LoginSignupPage(), false),
                      );
                    },
                    child: Text(
                      "Log In",
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
      )
    );
  }
}

enum AccountInfoResult { success, emptyFirstName, emptyLastName, emptyBirthdate }

class AccountInfoBody extends StatefulWidget {
  const AccountInfoBody(
    this.username,
    this.email,
    this.password,
    this.prefs,
    {super.key});

  final String username;
  final String email;
  final String password;

  final SharedPreferences? prefs;

  @override
  State<AccountInfoBody> createState() => AccountInfoState();
}

class AccountInfoState extends State<AccountInfoBody> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final birthdateController = TextEditingController();
  DateTime? birthdate;

  String? firstNameError;
  String? lastNameError;
  String? birthdateError;

  Future<DateTime> pickBirthdate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      cancelText: "Cancel",
      confirmText: "Confirm",
      helpText: "Edit Birthdate",
    );

    return picked ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = widget.prefs?.getBool('darkmode') ?? false;

    Future<AccountInfoResult> trySignup() async {
      if (firstNameController.text.isEmpty) {
        return AccountInfoResult.emptyFirstName;
      } else if (lastNameController.text.isEmpty) {
        return AccountInfoResult.emptyLastName;
      } else if (birthdate == null) {
        return AccountInfoResult.emptyBirthdate;
      }

      return AccountInfoResult.success;
    }

    Future<void> completeSignup() async {
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      await users.doc(widget.username).set({
        'email': widget.email,
        'password': widget.password,
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'birthdate': Timestamp.fromDate(birthdate ?? DateTime.now())
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppStyles.backgroundColor(isDarkMode),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: AppStyles.textColor(isDarkMode),
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              _createSlidingRoute(
                LoginSignupPage(
                  showSignup: true,
                  username: widget.username,
                  email: widget.email,
                  password: widget.password,
              ), true),
            );
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 70, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi, ${widget.username}!",
                  style: TextStyle(
                    fontFamily: 'Geologica',
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppStyles.accentColor(isDarkMode)
                  )
                ),
                Text(
                  "Tell us about yourself",
                  style: TextStyle(
                    fontFamily: 'Geologica',
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppStyles.textColor(isDarkMode)
                  )
                )
              ],
            ),
          ),
          RoundedInputField(
            hintText: "First Name",
            controller: firstNameController,
            icon: CupertinoIcons.person_crop_circle_fill,
            onChanged: (value) {},
            errorText: firstNameError,
            prefs: widget.prefs
          ),
          RoundedInputField(
            hintText: "Last Name",
            controller: lastNameController,
            icon: CupertinoIcons.mail_solid,
            onChanged: (value) {},
            errorText: lastNameError,
            prefs: widget.prefs
          ),
          RoundedDateField(
            hintText: "Birthdate",
            controller: birthdateController,
            onPress: () {
              pickBirthdate().then((date) {
                birthdateController.text = AccountBody.formatTimestamp(date, asText: true);
                birthdate = date;
              });
            },
            errorText: birthdateError,
            prefs: widget.prefs
          ),
          RoundedButton("Continue", () {
            trySignup().then((result) {
              switch (result) {
                case AccountInfoResult.success:
                  setState(() {
                    firstNameError = null;
                    lastNameError = null;
                    birthdateError = null;
                  });

                  completeSignup().then((value) {
                    widget.prefs?.setString('username', widget.username);
                    widget.prefs?.setString('password', widget.password);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  });
                case AccountInfoResult.emptyFirstName:
                  setState(() {
                    firstNameError = "First name cannot be empty";
                    lastNameError = null;
                    birthdateError = null;
                  });
                case AccountInfoResult.emptyLastName:
                  setState(() {
                    firstNameError = null;
                    lastNameError = "Last name cannot be empty";
                    birthdateError = null;
                  });
                case AccountInfoResult.emptyBirthdate:
                  setState(() {
                    firstNameError = null;
                    lastNameError = null;
                    birthdateError = "Birthdate cannot be empty";
                  });
                default:
                  setState(() {
                    firstNameError = null;
                    lastNameError = null;
                    birthdateError = null;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Error occured while signing up."),)
                  );
              }
            });
          }, widget.prefs)
        ]
      )
    );
  }

}