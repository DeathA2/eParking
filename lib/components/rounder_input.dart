import 'package:flutter/material.dart';
import 'package:testapp/components/text_field_container.dart';
import 'package:testapp/constants.dart';

class RounderInputField extends StatelessWidget {
  final String hintText;
  final IconData icons;
  final ValueChanged<String> onChanged;
  const RounderInputField({
    Key? key,
    required this.hintText,
    required this.icons,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          icon: Icon(
            icons,
            color: kPrimaryColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}