import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techcurve/screens/authentication/loginPage.dart';

class LogoutPage extends StatefulWidget {
  @override

  _LogoutPageState createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Center(
            child: Container(

              width: 250,
              height: 45.0,
              margin: EdgeInsets.only(left: 15.0,top: 20.0,right: 15,bottom: 20),
              child: RaisedButton(
                onPressed: () {

                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          title: Text("Logout!",style: TextStyle(color: Colors.white,fontSize: 20),),
                          content: Text("Are you sure?",style: TextStyle(color: Colors.white,fontSize: 17),),
                          actions: <Widget>[
                            FlatButton( onPressed: (){
                              Navigator.pop(context);
                            },
                              child: Text("No",style: TextStyle(color: Colors.white,fontSize: 17),),),
                            FlatButton(onPressed: () async {
                              Navigator.pop(context);
                              Navigator.of(context).pop();
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.remove('uid');
                              FirebaseAuth.instance.signOut();
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => LoginPage()),
                              );

                            },child: Text("Yes",style: TextStyle(color: Colors.white,fontSize: 17),),),
                          ],
                          elevation: 24.0,
                          backgroundColor: Color(0xff0f4c81)   ,

                        );
                      }
                  );
                },
                child: Text("LOG OUT"),
                color: Color(0xff0f4c81)   ,
                textColor: Color(0xFFffffff),

              ),

            ),
          ),
        ),
      ),
    );
  }
}

