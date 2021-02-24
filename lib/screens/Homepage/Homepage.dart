import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:techcurve/screens/Homepage/CreatePostPage.dart';
 import 'package:techcurve/screens/Homepage/LogoutPage.dart';
import 'package:techcurve/screens/Homepage/ProfilePage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


TextEditingController search = new TextEditingController();

class Homepage extends StatefulWidget {
  final uid;
  Homepage({Key key,this.uid});
  @override

  _HomepageState createState() => _HomepageState();

}

class _HomepageState extends State<Homepage> {
  PageController _pageController;
  int currentpage=0;
  int curentindex=0;
  ProgressDialog prx;
  DateTime currentBackPressTime;

  Set<Marker> _marker ={};
  BitmapDescriptor mapMarker;


  Widget getPage(int index) {
    if (index == 1) {
      return ProfilePage(uid: widget.uid,);
    }
    if (index == 2) {
      return CreatePostPage(uid: widget.uid,);
    }
    else
      return LogoutPage();
    // A fallback, in this case just PageOne
  }


  @override
  Widget build(BuildContext context) {



    prx = new ProgressDialog(context);
    prx.style(
        message: 'Adding to Bookmark..', borderRadius: 10.0, backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(), elevation: 10.0, insetAnimCurve: Curves.easeInOut,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600)
    );
    return Scaffold(
       appBar: AppBar(
        title: Text("TechCurve"),backgroundColor: Color(0xff0f4c81),


      ),
        body: curentindex==0 ? WillPopScope(
          onWillPop: onWillPop,
          child: SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child:  StreamBuilder(
                    stream: Firestore.instance.collection(widget.uid).document("PersonalInfo").snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return new Text("Loading");
                      }
                      DocumentSnapshot productsa = snapshot.data;


                      //var userDocument = snapshot.data;
                      // picture1[index] = userDocument["pic1"];
                      return   GoogleMap(
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        zoomControlsEnabled: true,
                        zoomGesturesEnabled: true,
                        onMapCreated: (GoogleMapController controller){
                          controller.setMapStyle(Utils.mapStyle);
                          setState(() {
                            _marker.add(
                              Marker(
                                  markerId: MarkerId("id-1"),
                                  position:LatLng(productsa["lat"],productsa["lon"]),
                                  infoWindow: InfoWindow(
                                    title: productsa["name1"],
                                    snippet: productsa["phone"],
                                  )
                              ),

                            );
                          });
                        },
                        markers: _marker,

                        initialCameraPosition: CameraPosition(
                            target: LatLng(productsa["lat"],productsa["lon"]),
                            zoom: 15),
                      );
                    }
                ),
               )
          ),
        ): getPage(curentindex),

      bottomNavigationBar: BottomNavigationBar(
          currentIndex: curentindex,
          selectedItemColor: Color(0xff0f4c81),

          // selectedIconTheme: ThemeData.from(colorScheme:),
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,

          onTap: (index){
            setState(() {
            curentindex=index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon:Icon(Icons.location_on),
              title: Text("Location",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: "Roboto",),),

            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person,),
              title: Text("Profile",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: "Roboto",),),

            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              title: Text("Create",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: "Roboto",),),

            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.power_settings_new),
              title: Text("Logout",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: "Roboto",),),

            )
          ]
      ),
    );

  }
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();

    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "press back again to exit");
      return Future.value(false);
    }
    return Future.value(true);
  }
}
class Utils {
  static String mapStyle = ''' [
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ebe3cd"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#523735"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f1e6"
      }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#c9b2a6"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#dcd2be"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#ae9e90"
      }
    ]
  },
  {
    "featureType": "landscape.natural",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dfd2ae"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dfd2ae"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#93817c"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#a5b076"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#447530"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f1e6"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#fdfcf8"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f8c967"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#e9bc62"
      }
    ]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e98d58"
      }
    ]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#db8555"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#806b63"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dfd2ae"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#8f7d77"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#ebe3cd"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dfd2ae"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#b9d3c2"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#92998d"
      }
    ]
  }
] ''';
}


