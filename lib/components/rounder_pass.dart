// import 'package:flutter/material.dart';
// import 'package:testapp/components/text_field_container.dart';
// import 'package:testapp/constants.dart';
//
// bool getPassInvalid = false;
//
// class RounderPassword extends StatefulWidget {
//   bool passInvalid = true;
//   RounderPassword({Key? key,
//     required this.passInvalid}) : super(key: key);
//   void GetPassInvalid(){
//     getPassInvalid = passInvalid;
//   }
//   @override
//   _RounderPasswordState createState() => _RounderPasswordState();
// }
//
// class _RounderPasswordState extends State<RounderPassword> {
//   late ValueChanged<String> onChanged = (value){};
//   bool _shPass = getPassInvalid;
//
//   TextEditingController pass = new TextEditingController();
//   var _checkPass = "Wrong Password";
//   var _passInvalid = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFieldContainer(
//       child: TextField(
//         onChanged: onChanged,
//         decoration: InputDecoration(
//           icon: IconButton(
//             icon: Icon(),
//             color: kPrimaryColor,
//           ),
//           hintText: hintText,
//           border: InputBorder.none,
//         ),
//       ),
//     );
//   }
// }
//
//
//
