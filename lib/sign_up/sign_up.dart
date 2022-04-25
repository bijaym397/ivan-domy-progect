import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:ivan_infotech/model/user_model.dart';
import '../login/login_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../profile_view/profile_view.dart';
import '../widgets.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final signUpFormKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController conPasswordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
              );
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        body: Form(
          key: signUpFormKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextWithStyle(
                  text: "Create",
                  fontSize: 24,
                  padding: EdgeInsets.only(left: 16, top: 50),
                ),
                const TextWithStyle(
                  text: "new account",
                  fontSize: 24,
                  padding: EdgeInsets.only(left: 16),
                ),
                CustomTextField(
                  controller: nameController,
                  hintText: "Yor Name",
                  textInputAction: TextInputAction.next,
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                  validator: (value) {
                    RegExp regExp = RegExp(r"^.{3,}$");
                    if (value!.isEmpty) {
                      return "Name can't empty";
                    }
                    if (!regExp.hasMatch(value)) {
                      return ("Enter valid Name (min. 6)");
                    }
                  },
                  onSaved: (value) {
                    nameController.text = value;
                  },
                ),
                CustomTextField(
                  controller: emailController,
                  hintText: "Email",
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Email can't Empty");
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
                  hintText: "Password ",
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    RegExp regExp = new RegExp(r"^.{6,}$");
                    if (value!.isEmpty) {
                      return ("password is required");
                    }
                    if (!regExp.hasMatch(value)) {
                      return ("Enter valid password (min. 6)");
                    }
                  },
                  onSaved: (value) {
                    passwordController.text = value;
                  },
                ),
                CustomTextField(
                  controller: conPasswordController,
                  hintText: "Conform Password ",
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("password is required");
                    }
                    if (passwordController.text != conPasswordController.text) {
                      return ("Password don't match");
                    }
                    return null;
                  },
                  onSaved: (value) {
                    conPasswordController.text = value;
                  },
                ),
                GestureDetector(
                  onTap: () {
                    signUp(emailController.text, passwordController.text);
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
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                  border: Border(
                top: BorderSide(
                  color: Colors.black26,
                  width: 1,
                ),
              )),
              height: 50,
              child: Center(
                  child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "already have an account?  ",
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.w500),
                    ),
                    TextSpan(
                      text: "sign in",
                      style: TextStyle(
                          color: Colors.indigoAccent,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )),
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if ((signUpFormKey.currentState!.validate())) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.name = nameController.text;
    userModel.name = nameController.text;

    await firebaseFirestore
        .collection("user")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account create successfully");
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ProfileView()));
  }
}
