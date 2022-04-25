import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ivan_infotech/model/user_model.dart';
import '../login/login_view.dart';
import '../widgets.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  final signUpFormKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("user")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            Center(
                child: GestureDetector(
              onTap: () {
                logout(context);
              },
              child: const TextWithStyle(
                text: "Logout",
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 26,
                padding: EdgeInsets.only(right: 16),
              ),
            )),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // UserImage(
              //   onFileChange: (String imgUrl) {},
              // ),
              CustomTextField(
                controller: nameController,
                hintText: "Yor Name",
                textInputAction: TextInputAction.next,
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                onChanged: (value) {},
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
              Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.indigoAccent,
                ),
                margin: const EdgeInsets.only(left: 8, right: 8, top: 36),
                padding: const EdgeInsets.only(left: 24, right: 8),
                child: const Center(
                  child: TextWithStyle(
                    text: "Save",
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
    );
  }
}
