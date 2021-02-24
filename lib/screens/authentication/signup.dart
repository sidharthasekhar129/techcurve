import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:intl/intl.dart';
 import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techcurve/screens/Homepage/Homepage.dart';
import 'package:techcurve/screens/authentication/Widget/background.dart';
import 'Widget/bezierContainer.dart';
import 'loginPage.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
 final TextEditingController _phoneController = TextEditingController();
final TextEditingController _name1Controller = TextEditingController();
final TextEditingController _name2Controller = TextEditingController();
final TextEditingController _addresscontroler = TextEditingController();

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  ProgressDialog pr;
  var image;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  String _currentAddress;

  Position _currentPosition;
  StorageReference storageReference = FirebaseStorage.instance.ref();

  final databaseReference = Firestore.instance;

  Future getImage(ImgSource source,BuildContext context) async {
    var imagex = await ImagePickerGC.pickImage(context: context, source: source,
      cameraIcon: Icon(Icons.camera, color: Colors.red,), //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
    );
    setState(() {
      image=imagex;
    });

  }

  @override
  void initState() {
    _getCurrentLocation();
    _getAddressFromLatLng();

  }
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField1(String title,) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15,
                  fontFamily: "Roboto") ),

          Container(
            height: 50,
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black26,

            ),
            margin: EdgeInsets.all(6),
            padding: EdgeInsets.only(left: 6),

            child:  TextField(
              controller: _emailController,
              style: TextStyle(fontWeight: FontWeight.w600,fontFamily: "Roboto",fontSize: 18,color: Colors.white),
              decoration: InputDecoration(border: InputBorder.none,hintText: "abc@gmail.com"),
              //readOnly: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _entryField2(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15,
                  fontFamily: "Roboto") ),
          Container(
            height: 50,
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black26,
            ),
            margin: EdgeInsets.all(6),
            padding: EdgeInsets.only(left: 6),
            child:  TextField(
              controller: _passwordController,
              style: TextStyle(fontWeight: FontWeight.w600,fontFamily: "Roboto",fontSize: 18,color: Colors.white),
              decoration: InputDecoration(border: InputBorder.none,hintText: "a!v@23S"),
              //readOnly: true,
            ),
          ),
        ],
      ),
    );
  }
  Widget _entryField3(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15,
                  fontFamily: "Roboto") ),

          Container(

            height: 50,
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black26,

            ),
            margin: EdgeInsets.all(6),
            padding: EdgeInsets.only(left: 6),

            child:  TextField(
              controller: _name1Controller,


              style: TextStyle(fontWeight: FontWeight.w600,fontFamily: "Roboto",fontSize: 18,color: Colors.white),
              decoration: InputDecoration(border: InputBorder.none,hintText: "Alek kernrl"),
              //readOnly: true,
            ),
          ),
        ],
      ),
    );
  }
  Widget _entryField4(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15,
                  fontFamily: "Roboto") ),

          Container(

            height: 50,
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black26,

            ),
            margin: EdgeInsets.all(6),
            padding: EdgeInsets.only(left: 6),

            child:  TextField(
              controller: _name2Controller,


              style: TextStyle(fontWeight: FontWeight.w600,fontFamily: "Roboto",fontSize: 18,color: Colors.white),
              decoration: InputDecoration(border: InputBorder.none,hintText: "Alek kernrl"),
              //readOnly: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _entryField5(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15,
                  fontFamily: "Roboto") ),

          Container(

            height: 50,
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black26,

            ),
            margin: EdgeInsets.all(6),
            padding: EdgeInsets.only(left: 6),

            child:  TextField(
              controller: _phoneController,

              style: TextStyle(fontWeight: FontWeight.w600,fontFamily: "Roboto",fontSize: 18,color: Colors.white),
              decoration: InputDecoration(border: InputBorder.none,hintText: "10 digits"),
              //readOnly: true,
            ),
          ),
        ],
      ),
    );
  }
  Widget _entryField6(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15,
                  fontFamily: "Roboto") ),

          Container(

            height: 50,
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black26,

            ),
            margin: EdgeInsets.all(6),
            padding: EdgeInsets.only(left: 6),

            child:  TextField(
              controller: _addresscontroler,

              style: TextStyle(fontWeight: FontWeight.w600,fontFamily: "Roboto",fontSize: 18,color: Colors.white),
              decoration: InputDecoration(border: InputBorder.none,hintText: "Address"),
              //readOnly: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField1("Username"),
        _entryField2("Password"),
        _entryField5("Phone",),

        _entryField3("First Name",),
        _entryField4("Last Name",),
        _entryField6("Address",),
      ],
    );
  }


  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: Color(0xff0f4c81),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Tech',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: 'Curve',
              style: TextStyle(color: Color(0xff0f4c81), fontSize: 30),
            ),

          ]),
    );
  }


  @override
  Widget build(BuildContext context) {
    AssetImage assetImage2 = AssetImage("assets/images/adduser.png");
    Image imagex = Image(
      image: assetImage2,height: 100,width: 100,
    );
    pr = new ProgressDialog(context);
    pr.style(
        message: 'Signing User...', borderRadius: 10.0, backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(), elevation: 10.0, insetAnimCurve: Curves.easeInOut,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600)
    );

    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Background(
          child: Container(
            height: height,
            child: Stack(
              children: <Widget>[

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: height * .15),
                        _title(),
                        SizedBox(
                          height: 50,
                        ),
                       Container(
                          //margin: EdgeInsets.only(top: 80),
                          height: 100,
                          width: 100,
                          child: GestureDetector(
                            onTap: (){
                              getImage(ImgSource.Both,context);
                            },
                            child:  Container(
                              height: 100,
                              width: 100,

                              child: image!=null? Image.file(image) :imagex,
                            )
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                       _emailPasswordWidget() ,
                        SizedBox(
                          height: 20,
                        ),
                      GestureDetector(
                        onTap: (){
                        _register(image);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.grey.shade200,
                                    offset: Offset(2, 4),
                                    blurRadius: 5,
                                    spreadRadius: 2)
                              ],
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [Color(0xff0f4c81), Color(0xff0f4c81)])),
                          child: Text(
                            'Register Now',
                            style: TextStyle(fontSize: 20, color: Colors.white,fontFamily: "Roboto"),
                          ),
                        ),
                      ) ,
                        SizedBox(height: 30),
                        _loginAccountLabel(),
                      ],
                    ),
                  ),
                ),
                Positioned(top: 10, left: 0, child: _backButton()),
              ],
            ),
          ),
        ),
      ),
    );
  }




  void _register(var images) async {
    await pr.show();
    pr =  ProgressDialog(context,type: ProgressDialogType.Download, isDismissible: false, showLogs: false);
    var gmail= _emailController.text;
    var pass= _passwordController.text;
    var name1= _name1Controller.text;
    var name2= _name2Controller.text;
    var address= _addresscontroler.text;
    var phone= _phoneController.text;
    if( gmail!="" && pass!="" && name1!="" && name2!="" && images!=null && address!="" && phone!="" &&  phone.length==10 && pass.length>=6){
      try {
        final  user = (await _auth.createUserWithEmailAndPassword(email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        )).user;

        if (user!=null) {



          Fluttertoast.showToast(msg:"Registered successfully",gravity: ToastGravity.BOTTOM,toastLength: Toast.LENGTH_SHORT,);


          databaseReference.collection(user.uid).document("PersonalInfo").setData({
            'email': gmail,
            'password': pass,
            "phone":phone,
            "name1": name1,
            "name2": name2,
            "address":address,
            "lat":_currentPosition.latitude,
            "lon":_currentPosition.longitude,
            "profilePic":""
          });
          databaseReference.collection(user.uid).document("Posts").collection("Postx").document("zzzzz").setData({
            'length': 0,

          });
          try {
            //CreateRefernce to path.
            StorageReference ref = storageReference.child("userProfilePic/");
            Random random = new Random();
            //StorageUpload task is used to put the data you want in storage
            //Make sure to get the image first before calling this method otherwise _image will be null.
            await pr.show();
            StorageUploadTask storageUploadTask = ref.child(user.uid).putFile(images);

            if (storageUploadTask.isSuccessful || storageUploadTask.isComplete) {
              final String url = await ref.getDownloadURL();
              //  print("The download URL is " + url);
            } else if (storageUploadTask.isInProgress) {
              storageUploadTask.events.listen((event) {
                double percentage = 100 * (event.snapshot.bytesTransferred.toDouble()
                    / event.snapshot.totalByteCount.toDouble());

                //  print("THe percentage " + percentage.toString());
                pr = ProgressDialog(context, type: ProgressDialogType.Download,
                    isDismissible: false,
                    showLogs: true
                );
              });

              StorageTaskSnapshot storageTaskSnapshot = await storageUploadTask
                  .onComplete;

              var downloadUrl1 = await storageTaskSnapshot.ref.getDownloadURL();
              Firestore.instance.collection(user.uid)
                  .document("PersonalInfo")
                  .updateData({
                "profilePic": downloadUrl1,

              });
              //Here you can get the download URL when the task has been completed.
              // print("Download URL " + downloadUrl1.toString());
              await pr.hide();
            } else {
              await pr.hide();

              //Catch any cases here that might come up like canceled, interrupted
            }
          } catch (e) {
            print(e.toString());
          }
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('uid', user.uid);

          await pr.hide();
          Navigator.of(context).pop();
          Navigator.of(context).pop();

          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Homepage(uid: user.uid,),),);

        }
        else {
          await pr.hide();
          Fluttertoast.showToast(msg:"Some error occurd",gravity: ToastGravity.BOTTOM,toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.white,textColor: Colors.teal);
        }

      }
      catch(e) {
        await pr.hide();
        Fluttertoast.showToast(msg: e.toString(),gravity: ToastGravity.BOTTOM,toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.white,textColor: Colors.teal);
      }
    }
    else{
      await pr.hide();
      Fluttertoast.showToast(msg:"Enter valid data",gravity: ToastGravity.BOTTOM,toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.white,textColor: Colors.teal);
    }



  }
  _getCurrentLocation() {

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      print(_currentPosition.longitude.toString()+"gfgf"+_currentPosition.latitude.toString());
      // _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }
  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {

        _currentAddress =
        "${place.locality}, ${place.postalCode}, ${place.country}";
        _addresscontroler.text=_currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }
}
