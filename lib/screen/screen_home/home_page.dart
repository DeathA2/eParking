
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:testapp/screen/screen_home/CalendarScreen.dart';
import 'package:testapp/screen/screen_home/ProfileScreen.dart';
import 'package:testapp/screen/screen_home/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double scr_h = 0;
  double scr_w = 0;
  Color primary = const Color(0xffeef444c);
  int currentIndex = 0;
  List<IconData> navigationIcons = [
    FontAwesomeIcons.calendarAlt,
    // FontAwesomeIcons.check,
    FontAwesomeIcons.userAlt,
  ];

  @override
  void initState() {
    if (Firebase.apps.length == "") {
      Firebase.initializeApp();
    }
    super.initState();

    // _getProfilePic();
    // _getvihiclePic();
  }
  // void _getProfilePic() async{
  //   DocumentSnapshot doc = await FirebaseFirestore.instance.collection("username").doc(User.usercode).get();
  // setState(() {
  //   User.profilePiclink=doc['profilePic'];
  // });
  // }


  @override
  Widget build(BuildContext context) {
    scr_h=MediaQuery.of(context).size.height;
    scr_w=MediaQuery.of(context).size.width;
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          CalendarScreen(),
          // TodayScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        margin: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: 24,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(40)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(2,2),
              )
            ]
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for(int i=0; i<navigationIcons.length; i++)...<Expanded>{
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = i;
                      });
                    },
                    child: Container(
                      height: scr_h,
                      width: scr_w,
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              navigationIcons[i],
                              color: i == currentIndex ? primary :Colors.black54,
                              size: i == currentIndex ? 30 : 26,
                            ),
                            i == currentIndex ? Container(
                              margin: EdgeInsets.only(top: 6),
                              height: 3,
                              width: 24,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(40)),
                                color: primary,
                              ),
                            ): const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              }
            ],
          ),
        ),
      ),
    );
  }
}
