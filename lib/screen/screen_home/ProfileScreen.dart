
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testapp/screen/screen_home/user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double screenHeight = 0;
  double screenWidth  = 0;
  Color primary = const Color(0xffeef444c);
  TextEditingController nameController = TextEditingController();
  TextEditingController vtypeController = TextEditingController();
  TextEditingController snController = TextEditingController();
  TextEditingController licenController = TextEditingController();
   void pickUploadProfilePic() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 90,
    );
    Reference ref = FirebaseStorage.instance
    .ref().child("${User.usercode.toLowerCase()}_profilePic.jpg");
    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) async{
      setState((){
        User.profilePiclink = value;
      });
       await FirebaseFirestore.instance.collection("username").doc(User.usercode).update({
      'profilePic':value,
      });
    });
   }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Firebase.apps.length == "") {
      Firebase.initializeApp();
    }
  }
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
            children: [
              GestureDetector(
                onTap: (){
                  pickUploadProfilePic();
                },
          child:Container(
                margin: EdgeInsets.only(top:80, bottom: 24),
                height: 120,
                width: 120,
                alignment:  Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: primary
            ) ,
            child: Center(
              child: User.profilePiclink == " " ? const Icon(
                Icons.person,
                color: Colors.white,
                size: 80,
              ):ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(User.profilePiclink),
              ),
              )
        ),),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "User ${User.usercode}",
                  style: TextStyle(
                    fontFamily: "NexaBold",
                    fontSize: 18,

                  ),
                ),
    ),
              const SizedBox(height: 24),
              textField("Full Name", "Full Name", nameController),
              textField("Apartment number", "Apartment number", snController),
              textField("Vehicle type", "Vehicle type", vtypeController),
              textField("License plate", "Ex: 18L104770", licenController),             
              GestureDetector(
                onTap: () async {
                     String fullName=nameController.text;
                     String sn=snController.text;
                     String vtype = vtypeController.text;
                     String licen = licenController.text;

                  if(User.canEdit){
                     if(fullName.isEmpty){
                       showSnackBar("Please enter your name!");
                     }else if(sn.isEmpty){
                       showSnackBar("Please enter your Apartment number");
                     }else if(vtype.isEmpty){
                       showSnackBar("Please enter your Vehicle type");
                     }else if(vtype.isEmpty){
                       showSnackBar("Please enter your License plate");}
                  else{
                       showSnackBar("Your information was saved");
                       var setDate = await FirebaseDatabase.instance.ref().child('information/' + User.usercode);
                      setDate.update({
                        'Name':fullName,
                        'Apartment Num':sn,
                        'Vehicle type':vtype,
                        'License plate':licen
                      });}
                  }
                } ,
                child: Container(
                  height: kToolbarHeight,
                  width: screenWidth,
                  margin: EdgeInsets.only(bottom: 12),

                  padding: const EdgeInsets.only(left: 11),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                      color: primary
                    ),
                      child: const Center(
                      child: Text(
                        "SAVE",
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "NexaBold",
                          fontSize: 16,
                        ),
                      ),
                    )
    ),
              ),
        ]), //Center
      ), //SingleChildScrollView
    );//Scaffold
  }
  Widget textField(String title, String hint, TextEditingController controller){
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft ,
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: "NexaBold",
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 12),
          child: TextFormField(
            controller: controller,
          cursorColor: Colors.black54,
          maxLines: 1,
          decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
          color: Colors.black54,
          fontFamily: "NexaBold"
          ),
          enabledBorder : const OutlineInputBorder(
          borderSide: BorderSide(
          color: Colors.black54,
          ),
          ),
          focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
          color: Colors.black54,
        ),
      ),
    ),
    ),
    ),
    ],
    );
    }
    void showSnackBar(String text){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
          text,
        ),)
      );
    }
}