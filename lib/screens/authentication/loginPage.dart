import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
 import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techcurve/screens/Homepage/Homepage.dart';
import 'package:techcurve/screens/authentication/Widget/background.dart';
import 'package:techcurve/screens/authentication/Widget/social_icon.dart';
import 'package:techcurve/screens/authentication/signup.dart';

 import 'PasswordResetPage.dart';
import 'Widget/bezierContainer.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

// Async function that calls getSharedPreferences
final TextEditingController _emailController = TextEditingController();
final TextEditingController _phoneController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final TextEditingController _otpController = TextEditingController();

class LoginPage extends StatefulWidget {


  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  final databaseReference = Firestore.instance;
  ProgressDialog pr;


  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }


  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        margin: EdgeInsets.only(top: 20,bottom: 20),
         alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text('Register',
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
            fontSize: 40,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: 'Curve',
              style: TextStyle(color: Color(0xff0f4c81), fontSize: 40),
            ),
          ]),
    );
  }


  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(
        message: 'Signing User...', borderRadius: 10.0, backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(), elevation: 10.0, insetAnimCurve: Curves.easeInOut,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600)
    );

    final height=MediaQuery.of(context).size.height;
     return Scaffold(
        body: SafeArea(
          child: Background(
            child: SingleChildScrollView(
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
                        SizedBox(height: height * .2),
                        _title(),
                        SizedBox(height: 20),

                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Gmail id",
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15,
                                    fontFamily: "Roboto"),
                              ),

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
                        ) ,
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Password",
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15,
                                    fontFamily: "Roboto"),
                              ),

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
                                  obscureText: true,
                                  // controller: mail,
                                  controller: _passwordController,

                                  style: TextStyle(fontWeight: FontWeight.w600,fontFamily: "Roboto",fontSize: 18,color: Colors.white),
                                  decoration: InputDecoration(border: InputBorder.none,hintText: "a!v@23S"),
                                  //readOnly: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          _signInWithEmailAndPassword();
                         // Navigator.of(context).push(MaterialPageRoute(builder: (context) => Homepage(),));

                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 13),
                          alignment: Alignment.center,

                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
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
                          child: Text('Login',style: TextStyle(fontSize: 20, color: Colors.white,fontFamily: "Roboto",fontWeight: FontWeight.bold),
                          ),
                         ),
                        ) ,
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => PassReset(),));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.centerRight,
                            child: Text('Forgot Password ?',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500)),
                          ),
                        ),
                        _divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SocalIcon(
                              iconSrc: "assets/images/facebook.svg",
                              press: () {},
                            ),
                            SocalIcon(
                              iconSrc: "assets/images/twitter.svg",
                              press: () {},
                            ),
                            SocalIcon(
                              iconSrc: "assets/images/google-plus.svg",
                              press: () {},
                            ),
                          ],
                        ),
                      //  SizedBox(height: 5),
                        _createAccountLabel(),
                        SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),
               ],
            ),
      ),),
          ),
        ));
  }


  void _signInWithEmailAndPassword() async {
    DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
    String date = dateFormat.format(DateTime.now());
    try {
      await pr.show();
      pr =  ProgressDialog(context,type: ProgressDialogType.Download, isDismissible: false, showLogs: false);
      // ignore: deprecated_member_use
      final  user = (await _auth.signInWithEmailAndPassword(email: _emailController.text.trim(),
        password: _passwordController.text.trim(),)).user;
      if (user.isEmailVerified) {
        Fluttertoast.showToast(msg: "Login successfully",gravity: ToastGravity.BOTTOM,toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.teal,textColor: Colors.white);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('uid', user.uid);

        await pr.hide();


        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Homepage(uid: user.uid,)),);
      }
      else if(!user.isEmailVerified){
        await pr.hide();
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context){
              return AlertDialog(
                title: Text("OOPS!",style: TextStyle(color: Colors.white,fontSize: 20),),
                content: Text("Looks like you didn't confirm your mail yet",style: TextStyle(color: Colors.white,fontSize: 17),),
                actions: <Widget>[
                  FlatButton( onPressed: (){
                    Navigator.pop(context);
                  },
                    child: Text("Dismiss",style: TextStyle(color: Colors.white,fontSize: 17),),),
                  FlatButton(onPressed: () async {
                    Navigator.pop(context);
                    await user.sendEmailVerification();
                    Fluttertoast.showToast(msg: "Verification email send succesfully", gravity: ToastGravity.BOTTOM, toastLength: Toast.LENGTH_SHORT);
                    },child: Text("Confirm Now",style: TextStyle(color: Colors.white,fontSize: 17),),),
                ],
                elevation: 24.0,
                backgroundColor: Colors.blue,
              );
            }
        );
      }
      else {
        await pr.hide();
        // Fluttertoast.showToast(msg: "Some error occurd",gravity: ToastGravity.BOTTOM,toastLength: Toast.LENGTH_SHORT,
        //     backgroundColor: Colors.teal,textColor: Colors.white);
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context){
              return AlertDialog(
                title: Text("Error!",style: TextStyle(color: Colors.white,fontSize: 20),),
                content: Text("You credentials are incorrect. Please try again!",style: TextStyle(color: Colors.white,fontSize: 17),),
                actions: <Widget>[
                  FlatButton( onPressed: (){
                    Navigator.pop(context);
                  },
                    child: Text("Dismiss",style: TextStyle(color: Colors.white,fontSize: 17),),),

                ],
                elevation: 24.0,
                backgroundColor: Color(0xff0f4c81)   ,

              );
            }
        );

      }
    } catch (e) {
      await pr.hide();
      // Fluttertoast.showToast(msg: e.toString(),gravity: ToastGravity.BOTTOM,toastLength: Toast.LENGTH_LONG,
      //     backgroundColor: Colors.teal,textColor: Colors.white);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text("Error!",style: TextStyle(color: Colors.white,fontSize: 20),),
              content: Text("You credentials are incorrect. Please try again!",style: TextStyle(color: Colors.white,fontSize: 17),),
              actions: <Widget>[
                FlatButton( onPressed: (){
                  Navigator.pop(context);
                },
                  child: Text("Dismiss",style: TextStyle(color: Colors.white,fontSize: 17),),),

              ],
              elevation: 24.0,
              backgroundColor: Color(0xff0f4c81)   ,

            );
          }
      );
    }

  }
}
