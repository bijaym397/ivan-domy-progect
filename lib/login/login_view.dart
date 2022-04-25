import 'package:flutter/material.dart';
import 'package:ivan_infotech/profile_view/profile_view.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:ivan_infotech/sign_up/sign_up.dart';
import '../widgets.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _loginFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              const TextWithStyle(
                text: "Sign in",
                fontSize: 24,
                padding: EdgeInsets.only(left: 16),
              ),
              const TextWithStyle(
                text: "to your account",
                fontSize: 24,
                padding: EdgeInsets.only(left: 16),
              ),
              CustomTextField(
                controller: emailController,
                hintText: "Email",
                textInputAction: TextInputAction.next,
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Enter your Email id";
                  }
                  if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9+_.-]+.[a-z]")
                      .hasMatch(value)) {
                    return "Please Enter a valid Email id";
                  }
                  return null;
                },
                onSaved: (value) {
                  emailController.text = value;
                },
              ),
              CustomTextField(
                controller: passwordController,
                hintText: "Enter your password ",
                textInputAction: TextInputAction.done,
                validator: (value) {
                  RegExp regExp = new RegExp(r"^.{6,}$");
                  if (value!.isEmpty) {
                    return ("password is required for login");
                  }
                  if (!regExp.hasMatch(value)) {
                    return ("Enter valid password (min. 6)");
                  }
                },
                onSaved: (value) {
                  passwordController.text = value;
                },
              ),
              GestureDetector(
                onTap: () {
                  signIn(emailController.text, passwordController.text);
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.indigoAccent,
                  ),
                  margin: const EdgeInsets.only(left: 8, right: 8, top: 36),
                  padding: const EdgeInsets.only(left: 18, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      TextWithStyle(
                        text: "Sign in to your account",
                        color: Colors.white,
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 5,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignUp()),
              );},
              child: Container(
                  decoration: const BoxDecoration(
                  border: Border(
                top: BorderSide(
                  color: Colors.black26,
                  width: 1,
                ),
              )),
              height: 50,
              child: const Center(
                child: TextWithStyle(
                  text: "Create new Account",
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signIn(String email, String password) async {
    if ((_loginFormKey.currentState!.validate())) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                Fluttertoast.showToast(msg: "Login Successful"),
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => ProfileView())),
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }
}
