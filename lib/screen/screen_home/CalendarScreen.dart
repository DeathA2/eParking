import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testapp/screen/screen_home/user.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

double scr_h = 0;
double scr_w = 0;
var _checkin = '--/--';
var _checkout = "--/--";
Color primary = const Color(0xffeef444c);
String _day = DateFormat('yy-MM-dd').format(DateTime.now()).toString();

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Check();
    if (Firebase.apps.length == "") {
      Firebase.initializeApp();
    }
    User.vihiclePiclink = " ";
    User.canEdit = true;
    User.plateImageCount = 0;
    User.plate= "Your Plate License";
    User.plates = ["Your Plate License"];
    _getvihiclePic();
    _getPlate();
    // User.plate = User.plates[0];
  }

  void _getPlate() async{
    final getUser = await FirebaseDatabase.instance.ref().child('resident/' + User.usercode).get();
    for (int i = 0; i < getUser.children.length; i++)
      {
        if (getUser.children.elementAt(i).key != "owner")
          setState(() {
            User.plates.add("${getUser.children.elementAt(i).key}");
          });
      }
  }

  void _getvihiclePic() async{
    // DocumentSnapshot doc = await FirebaseFirestore.instance.collection("username").doc(User.usercode).get();
    final getUser = await FirebaseDatabase.instance.ref().child('resident/' + User.usercode).get();
    try{
      ListResult url = (await FirebaseStorage.instance.ref("/picture/${User.plate}").listAll());
      if (url.items.isNotEmpty){
        String image = await FirebaseStorage.instance.ref("/picture/${User.plate}/${url.items.last.name}").getDownloadURL();
        setState(() {
          User.vihiclePiclink= image;
          User.plateImageCount = url.items.length -1;
        });
      }
      else{
        setState(() {
          User.vihiclePiclink= ' ';
        });
      }
    }
    catch(e){
      print("nodata");
    }
    // for (var i = 0 ; i < getUser.children.length; i++){
    //   try{
    //     ListResult url = (await FirebaseStorage.instance.ref("/picture/${getUser.children.elementAt(i).key}").listAll());
    //     if (url.items.isNotEmpty){
    //       String image = await FirebaseStorage.instance.ref("/picture/${getUser.children.elementAt(i).key}/${url.items.last.name}").getDownloadURL();
    //       setState(() {
    //         User.vihiclePiclink= image;
    //         User.plateImageCount = url.items.length -1;
    //         User.signal = false;
    //       });
    //
    //     }
    //   }
    //   catch(e){
    //     print("nodata");
    //   }
    // }
  }

  void _getAlbumPicture() async{
    final getUser = await FirebaseDatabase.instance.ref().child('resident/' + User.usercode).get();
    for (var i = 0 ; i < getUser.children.length; i++){
        ListResult url = (await FirebaseStorage.instance.ref("/picture/${getUser.children.elementAt(i).key}").listAll());
        if (url.items.isNotEmpty){
          if (User.plateImageCount == 0)
            {
              setState(() {
                User.plateImageCount = url.items.length;
              });
            }
          User.plateImageCount--;
          String image = await FirebaseStorage.instance.ref("/picture/${getUser.children.elementAt(i).key}/${url.items.elementAt(User.plateImageCount).name}").getDownloadURL();

          setState(() {
            User.vihiclePiclink= image;
          });
        }
    }
  }
  void Check() async {
    try{
      var setPlate = await FirebaseDatabase.instance
          .ref()
          .child('resident/' + User.usercode + "/${User.plate}");
      var _history = await setPlate.child("history").get();
      var _condition = await setPlate.child("condition").get();
      var setDay = await setPlate.child("history").child(_day).get();
      String? __checkin = '--/--';
      String? __checkout = '--/--';
      if (_day != DateFormat('yy-MM-dd').format(DateTime.now()).toString()) {
        for (int i = 0; i < _history.children.length; i++) {
          if (_day == _history.children.elementAt(i).key) {
            if (setDay.children.length != 1) {
              __checkin = (setDay.children.last.value == "IN")
                  ? setDay.children.last.key
                  : setDay.children.elementAt(setDay.children.length - 2).key;
              __checkout = (setDay.children.last.value == "OUT")
                  ? setDay.children.last.key
                  : setDay.children.elementAt(setDay.children.length - 2).key;
            } else {
              if (setDay.children.last.value == "IN") {
                __checkin = setDay.children.last.key;
                __checkout = '--/--';
              } else {
                __checkout = setDay.children.last.key;
                __checkin = '--/--';
              }
            }
            break;
          } else {
            __checkin = '--/--';
            __checkout = '--/--';
          }
        }
      } else {
        if (_condition.value == "Parking") {
          __checkin = (setDay.exists)
              ? setDay.children.last.key
              : ('${_history.children.elementAt(_history.children.length - 1).children.last.key}\n${_history.children.elementAt(_history.children.length - 1).key}');

          __checkout = 'Parking';
        } else {
          __checkin = "No Parking";
          __checkout = (setDay.exists)
              ? setDay.children.last.key
              : ('${_history.children.elementAt(_history.children.length - 1).children.last.key}\n${_history.children.elementAt(_history.children.length - 1).key}');
        }
      }
      setState(() {
        _checkin = __checkin.toString();
        _checkout = __checkout.toString();
      });
    }
    catch(e){
      setState(() {
        _checkin = '--/--';
        _checkout = '--/--';
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    // if (User.plate.isEmpty)
    //   User.plate = User.plates[0];
    scr_h = MediaQuery.of(context).size.height;
    scr_w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 32),
            child: Text(
              "Parking History",
              style: TextStyle(
                fontFamily: "NexaBold",
                fontSize: scr_w / 18,
              ),
            ),
          ),
          Stack(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 32),
                child: Text(
                  _day,
                  style: TextStyle(
                    fontFamily: "NexaBold",
                    fontSize: scr_w / 18,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 70),
                child: DropdownButton(
                  dropdownColor: Colors.white,
                  alignment: AlignmentDirectional.center,
                  style: TextStyle(
                    fontSize: scr_w / 20,
                    fontFamily: "NexaBold",
                    color: Colors.black
                  ),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: User.plates.map((String items){
                    return DropdownMenuItem(child: Text(items), value: items,);
                }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      User.plate = value!;
                    });
                    _getvihiclePic();
                    Check();
                  },
                  value: User.plate,

                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.only(top: 32),
                child: GestureDetector(
                  onTap: () async {
                    final day = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: primary,
                                  secondary: primary,
                                  onSecondary: Colors.white,
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    primary: primary,
                                  ),
                                ),
                                textTheme: const TextTheme(
                                  headline4: TextStyle(
                                    fontFamily: "NexaBold",
                                  ),
                                  overline: TextStyle(
                                    fontFamily: "NexaBold",
                                  ),
                                  button: TextStyle(
                                    fontFamily: "NexaBold",
                                  ),
                                )),
                            child: child!,
                          );
                        });
                    if (day != null) {
                      setState(() {
                        _day = DateFormat('yy-MM-dd').format(day);
                        Check();
                      });
                    }
                  },
                  child: Text(
                    "Pick a Day",
                    style: TextStyle(
                      fontFamily: "NexaBold",
                      fontSize: scr_w / 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, left: 6, right: 6),
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 5,
                  offset: Offset(2, 2),
                )
              ],
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(color: Colors.black45, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Check in",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Nexaregular",
                          fontSize: scr_w / 20,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        _checkin,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "NexaBold",
                          fontSize: scr_w / 18,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Check out",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Nexaregular",
                          fontSize: scr_w / 20,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        _checkout,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "NexaBold",
                          fontSize: scr_w / 18,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 30),
              height: 320,
              width: 320,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: Center(
                child: User.vihiclePiclink == " "
                    ? const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 80,
                      )
                    : ClipRRect(

                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            Image.network(User.vihiclePiclink),
                            MaterialButton(
                                height: 240,
                                minWidth: 320,
                                onPressed: _getAlbumPicture,
                                child: Text("")
                            )
                          ],
                        ),
                      ),
              )),
        ]),
      ),
    );
  }
}
