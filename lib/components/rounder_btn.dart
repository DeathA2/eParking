import 'package:flutter/material.dart';
import 'package:testapp/constants.dart';

class RounderBtn extends StatelessWidget {
  final String text;
  final void Function() press;
  final Color color, textColor;

  const RounderBtn({
    Key? key,
    required this.text,
    required this.press,
    this.color = kPrimaryColor,
    this.textColor = Colors.white,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width*0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: MaterialButton(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          color: color,
          onPressed: press,
          child: Text(text, style: TextStyle(color: textColor),),
        ),
      ),
    );
  }
}