import 'package:flutter/material.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../screen/screen_login/components/body.dart';
import 'package:testapp/components/rounder_btn.dart';
import 'package:testapp/Signup/signup_screen.dart';
import 'package:testapp/screen/screen_login/login.dart';
import 'package:firebase_database/firebase_database.dart';
 TextEditingController _user = new TextEditingController();
TextEditingController _pass = new TextEditingController();
TextEditingController _name = new TextEditingController();
class SignUpForm extends StatelessWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            controller: _user,
            decoration: InputDecoration(
              hintText: "Your Usercode",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              controller: _pass,
              decoration: InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              controller: _name,
              decoration: InputDecoration(
                hintText: "Your Name",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          RounderBtn(
              text: "SIGNUP",
              press: ()
                async {
                var setDate = await FirebaseDatabase.instance.ref().child('information/');
                      setDate.update({
                        _user.text:'/',
                      });
                var setDate1 = await FirebaseDatabase.instance.ref().child('information/'+_user.text);
                      setDate1.update({
                        'Password':_pass.text,
                        'Name':_name.text,
                        'Apartment Num':'',
                        'Vehicle type':'',
                        'License plate':'',
                      });
                      void showSnackBar(String text){
                          ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(
                            text,
                          ),)
                        );
                      }
                      showSnackBar("Sign Up Success");
                await Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
              },
              color: kSubColor,
              textColor: Colors.black,
            ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}