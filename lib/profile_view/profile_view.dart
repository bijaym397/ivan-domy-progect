import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../login/login_view.dart';
import '../widgets.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final profileFormKey = GlobalKey<FormState>();

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
          child: Form(
            key: profileFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UserImage(),
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
                  keyboardType: TextInputType.emailAddress,
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
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  hintText: "PhoneNumber ",
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    RegExp regExp = new RegExp(r"^.{10,}$");
                    if (value!.isEmpty) {
                      return ("Phone No is required");
                    }
                    if (!regExp.hasMatch(value)) {
                      return ("Enter valid Phone No");
                    }
                  },
                  onSaved: (value) {
                    phoneController.text = value;
                  },
                ),
                GestureDetector(
                  onTap: (){
                    profileSave();
                  },
                  child: Container(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void profileSave() async {
    if ((profileFormKey.currentState!.validate())) {}
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
    );
  }
}
