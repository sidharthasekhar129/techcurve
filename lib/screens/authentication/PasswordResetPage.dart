
 import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Widget/bezierContainer.dart';

 TextEditingController mail=new TextEditingController();
 class PassReset extends StatefulWidget {
  @override
  _PassResetState createState() => _PassResetState();
}

class _PassResetState extends State<PassReset> {
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: <Widget>[
                  Positioned(
                      top: -MediaQuery.of(context).size.height * .15,
                      right: -MediaQuery.of(context).size.width * .4,
                      child: BezierContainer()),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: MediaQuery.of(context).size.height * .3),
                          Container(
                            padding: EdgeInsets.only(left: 6,top: 8),
                            alignment: Alignment.topLeft,
                            child: Text("Registered Gmail:",style: TextStyle(fontSize: 20,color: Colors.black,
                                fontWeight: FontWeight.w600,fontFamily: "Roboto"),),
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
                              controller: mail,
                              style: TextStyle(fontWeight: FontWeight.w600,fontFamily: "Roboto",fontSize: 18,color: Colors.white),
                              decoration: InputDecoration(border: InputBorder.none,hintText: "abc@gmail.com",hintStyle: TextStyle(color: Colors.black45)),
                              //readOnly: true,
                            ),
                          ),
                          Text("Note: Password reset link will be send to your given GMail ",
                            textAlign: TextAlign.center,style: TextStyle(fontSize: 15,fontFamily: "Roboto",fontWeight: FontWeight.w600,color: Colors.black),),
                          GestureDetector(
                          onTap: () {
                            try{
                              if(mail.text!=""){
                                FirebaseAuth.instance.sendPasswordResetEmail(email: mail.text.trim());
                                Fluttertoast.showToast(msg: "Gmail sent successfully",gravity: ToastGravity.BOTTOM,toastLength: Toast.LENGTH_SHORT,
                                    backgroundColor: Colors.teal,textColor: Colors.white);

                              }
                            }catch(e)
                            {
                              Fluttertoast.showToast(msg:e.toString(),gravity: ToastGravity.BOTTOM,toastLength: Toast.LENGTH_SHORT,
                                  backgroundColor: Colors.teal,textColor: Colors.white);

                            }

                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
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
                              child: Text(
                                'send',
                                style: TextStyle(fontSize: 20, color: Colors.white,fontFamily: "Roboto",fontWeight: FontWeight.bold),
                              ),
                            ),
                       ),

                        ],
                      ),

                    ),
                  ),


                  Positioned(top: 10, left: 0, child: _backButton()),
                ],
              ),
            ),
          ),
        ));
  }
}


