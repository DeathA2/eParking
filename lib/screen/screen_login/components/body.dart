import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:testapp/components/rounder_btn.dart';
import 'package:testapp/components/text_field_container.dart';
import 'package:testapp/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/screen/screen_home/home_page.dart';
import 'package:testapp/screen/screen_home/user.dart';
import 'package:testapp/screen/screen_login/components/background.dart';
import 'package:url_launcher/url_launcher.dart';

class login_body extends StatefulWidget {

  const login_body({
    Key? key,}
    ) : super(key: key);

  @override
  _login_bodyState createState() => _login_bodyState();
}

class _login_bodyState extends State<login_body> {

  bool _shPass = true;

  TextEditingController _user = new TextEditingController();
  TextEditingController _pass = new TextEditingController();
  var _userError = "Không tồn tại mã nhân viên";
  var _passError = "Wrong Password";
  var _userInvalid = false;
  var _passInvalid = false;

  final referenceDatase = FirebaseDatabase.instance;
  final String phone = "+84 338029736";

  @override
  Widget build(BuildContext context) {
    final ref = referenceDatase.ref();
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "LOG IN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height*0.35,
            ),
            TextFieldContainer(
              child: TextField(
                controller: _user,
                decoration: InputDecoration(
                  icon: const Icon(
                    Icons.person,
                    color: kPrimaryColor,
                  ),
                  hintText: "ID",
                  errorText: _userInvalid ? _userError : null,
                  border: InputBorder.none,
                ),
              ),
            ),
            TextFieldContainer(
              child: TextField(
                controller: _pass,
                obscureText: _shPass,
                decoration: InputDecoration(
                  icon: const Icon(
                    Icons.lock,
                    color: kPrimaryColor,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _shPass ? Icons.visibility : Icons.visibility_off,
                      color: kPrimaryColor,
                    ),
                    onPressed: () {
                      setState((){
                        _shPass = !_shPass;
                      });
                    },
                  ),
                  errorText: _passInvalid ? _passError : null,
                  hintText: "Password",
                  border: InputBorder.none,
                ),
              ),
            ),
            RounderBtn(
                text: "LOG IN", 
                press: onLogInClick,
            ),
            RounderBtn(text: "FORGET PASSWORD", press: () async {
              await FlutterPhoneDirectCaller.callNumber("0338029736");
            },
            color: kSubColor,
            textColor: Colors.black54,),
          ],
        ),
      ),
    );
  }

  Future<void> onLogInClick() async {
    if (Firebase.apps.length == "") {
      Firebase.initializeApp();
    }
    var ref = referenceDatase.ref();
    final snapshot = await ref.child("information/"+_user.text).get();
    final passWord = await ref.child("information/"+_user.text+"/Password").get();
    final az = await ref.child("information/"+_user.text+"/Name").get();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User.username= az.value as String;
    User.usercode= _user.text;
    setState(() {
      if (!snapshot.exists)
        _userInvalid = true;
      else {
        _userInvalid = false;
        if (_pass.text != passWord.value)
          _passInvalid = true;
        else
          _passInvalid = false;
      }
      if (!_passInvalid && !_userInvalid)
        Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
    });
    _pass.clear();
  }
}



