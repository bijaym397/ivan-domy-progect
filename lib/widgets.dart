import 'package:flutter/material.dart';

class TextWithStyle extends StatelessWidget {
  const TextWithStyle(
      {Key? key,
      this.text = "",
      this.color = Colors.black,
      this.fontSize = 16,
      this.fontWeight = FontWeight.w500,
      this.padding = const EdgeInsets.all(0)})
      : super(key: key);
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        text,
        textAlign: TextAlign.left,
        style:
            TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
      required this.controller,
      this.title = "",
      this.hintText = "Type",
      this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.textInputAction = TextInputAction.done,
      required this.onSaved,
      this.validator,
      this.onChanged})
      : super(key: key);
  final TextEditingController controller;
  final String title;
  final String hintText;
  final EdgeInsetsGeometry padding;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextInputAction textInputAction;
  final onSaved;
  final validator;
  final onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            TextWithStyle(
              text: title,
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          TextFormField(
            controller: controller,
            onSaved: onSaved,
            autofocus: false,
            textInputAction: textInputAction,
            obscureText: obscureText,
            onChanged: onChanged,
            validator: validator,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: hintText,
            ),
          ),
        ],
      ),
    );
  }
}

class UserImage extends StatefulWidget {
  @override
  State<UserImage> createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 38, bottom: 26),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const CircleAvatar(
            backgroundColor: Colors.black26,
            radius: 55,
            backgroundImage: NetworkImage(
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSlR3hMw_3daUL3Uhr5Y3uJh_kMaYzyqQhhPA&usqp=CAU"),
          ),
          Positioned(
              bottom: -4,
              right: -8,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: GestureDetector(
                    child: const Icon(
                      Icons.edit,
                      size: 26,
                    ),
                    onTap: () {
                      _selectPhotoFrom();
                    },
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Future _selectPhotoFrom() async {
    await showBottomSheet(
      context: context,
      builder: (context) => BottomSheet(
        onClosing: () {},
        builder: (context) => Container(
          color: Colors.black12,
          height: 150,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_enhance_outlined,
                    color: Colors.black),
                title: const TextWithStyle(text: "Camera", color: Colors.black),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_photo_alternate_outlined,
                    color: Colors.black),
                title:
                    const TextWithStyle(text: "Gallery", color: Colors.black),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
