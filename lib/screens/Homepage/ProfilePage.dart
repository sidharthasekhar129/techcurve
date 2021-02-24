import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_ink_well/image_ink_well.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:progress_dialog/progress_dialog.dart';

TextEditingController name1=new TextEditingController();
TextEditingController name2=new TextEditingController();

TextEditingController gmail=new TextEditingController();

TextEditingController phone=new TextEditingController();
TextEditingController address=new TextEditingController();

TextEditingController password=new TextEditingController();
class ProfilePage extends StatefulWidget {

  final uid;

  ProfilePage({Key key, this.uid}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {
   bool readonlyphone=true;
  bool readonlyname1=true;
   bool readonlyaddress=true;
   bool readonlyname2=true;

   ProgressDialog pr;

   final databaseReference = Firestore.instance;

   StorageReference storageReference = FirebaseStorage.instance.ref();

   Future getImage(ImgSource source,BuildContext context) async {
     var image = await ImagePickerGC.pickImage(context: context, source: source,
       cameraIcon: Icon(Icons.camera, color: Colors.red,
       ), //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
     );
     try {
       //CreateRefernce to path.
       StorageReference ref = storageReference.child("userProfilePic/");

       //StorageUpload task is used to put the data you want in storage
       //Make sure to get the image first before calling this method otherwise _image will be null.
       await pr.show();
       StorageUploadTask storageUploadTask = ref.child(widget.uid).putFile(image);

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
               showLogs: true);
         });

         StorageTaskSnapshot storageTaskSnapshot = await storageUploadTask
             .onComplete;

         var downloadUrl1 = await storageTaskSnapshot.ref.getDownloadURL();
         Firestore.instance.collection(widget.uid)
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
   }

   @override
  Widget build(BuildContext context) {

    pr = new ProgressDialog(context);
    pr.style(
        message: 'Uploading Image...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600)
    );
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Column(
              children: <Widget>[

                Container(
                  //margin: EdgeInsets.only(top: 80),
                  height: 150,
                  width: 120,
                  margin: EdgeInsets.only(top: 20,left: 15,bottom: 20,right: 10),
                  child: GestureDetector(
                    onTap: (){
                      //getImage(ImgSource.Both,context);
                    },
                    child: GestureDetector(
                      onTap: (){
                          getImage(ImgSource.Both,context);                    },
                      child: StreamBuilder(
                          stream: Firestore.instance.collection(widget.uid).document("PersonalInfo").snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return new Text("Loading");
                            }
                            var userDocument = snapshot.data;
                            return CircleImageInkWell(
                              size: 100,
                              image: NetworkImage(userDocument["profilePic"]),
                            );

                          }
                      ),
                    ),
                  ),
                ),


                Container(
                  padding: EdgeInsets.only(left: 6,top: 8),
                  alignment: Alignment.topLeft,
                  child: Text("Gmail:",style: TextStyle(fontSize: 20,fontFamily: "Raleway",fontWeight: FontWeight.w700,color: Colors.black),),
                ),
                StreamBuilder(
                    stream: Firestore.instance.collection(widget.uid).document('PersonalInfo').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return new Text("Loading");
                      }
                      var userDocument = snapshot.data;
                      gmail.text=userDocument["email"];
                      // picture1[index] = userDocument["pic1"];
                      return     Row(
                          children:[ Container(
                            width: MediaQuery.of(context).size.width-70,
                            alignment: Alignment.topLeft,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black26,

                            ),
                            margin: EdgeInsets.all(6),
                            padding: EdgeInsets.only(left: 6),

                            child:  TextField(
                              controller: gmail,
                              style: TextStyle(fontWeight: FontWeight.w600,fontFamily: "Raleway",fontSize: 18,color: Colors.white),
                              decoration: InputDecoration(border: InputBorder.none),
                              readOnly: true,
                            ),
                          ),
                            GestureDetector(
                              onTap: (){

                                //SelectDate(context);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                child: Icon(Icons.edit_off, color: Color(0xff0f4c81)
                                ),
                              ),
                            )
                          ]
                      );
                    }
                ),
                Container(
                  padding: EdgeInsets.only(left: 6,top: 8),
                  alignment: Alignment.topLeft,
                  child: Text("Password:",style: TextStyle(fontSize: 20,fontFamily: "Raleway",fontWeight: FontWeight.w700,color: Colors.black),),
                ),
                StreamBuilder(
                    stream: Firestore.instance.collection(widget.uid).document('PersonalInfo').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return new Text("Loading");
                      }
                      var userDocument = snapshot.data;
                      password.text=userDocument["password"];
                      // picture1[index] = userDocument["pic1"];
                      return     Row(
                          children: [Container(
                            width: MediaQuery.of(context).size.width-70,
                            alignment: Alignment.topLeft,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black26,

                            ),
                            margin: EdgeInsets.all(6),
                            padding: EdgeInsets.only(left: 6),

                            child:  TextField(
                              controller: password,
                              obscureText: true,
                              style: TextStyle(fontWeight: FontWeight.w600,fontFamily: "Raleway",fontSize: 18,color: Colors.white),
                              decoration: InputDecoration(border: InputBorder.none),
                              readOnly: true,
                            ),
                          ),
                            GestureDetector(
                              onTap: (){

                                //SelectDate(context);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                child: Icon(Icons.edit_off, color: Color(0xff0f4c81)
                                ),
                              ),
                            )
                          ]
                      );
                    }
                ),
                Container(
                  padding: EdgeInsets.only(left: 6,top: 8),
                  alignment: Alignment.topLeft,
                  child: Text("First Name:",style: TextStyle(fontSize: 20,fontFamily: "Raleway",fontWeight: FontWeight.w700,color: Colors.black),),
                ),

                StreamBuilder(
                    stream: Firestore.instance.collection(widget.uid).document('PersonalInfo').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return new Text("Loading");
                      }
                      var userDocument = snapshot.data;
                      name1.text=userDocument["name1"];
                      // picture1[index] = userDocument["pic1"];
                      return  Row(
                          children:[ Container(
                            width: MediaQuery.of(context).size.width-70,

                            alignment: Alignment.topLeft,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black26,

                            ),
                            margin: EdgeInsets.all(6),
                            padding: EdgeInsets.only(left: 6),

                            child:  TextField(
                              controller: name1,

                              style: TextStyle(fontWeight: FontWeight.w600,fontFamily: "Raleway",fontSize: 18,color: Colors.white),
                              decoration: InputDecoration(border: InputBorder.none,),
                              readOnly: readonlyname1,
                            ),
                          ),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  readonlyname1=false;

                                });
                                //SelectDate(context);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                child: Icon(Icons.edit, color: Color(0xff0f4c81)
                                ),
                              ),
                            )
                          ]
                      );
                    }
                ),
                Container(
                  padding: EdgeInsets.only(left: 6,top: 8),
                  alignment: Alignment.topLeft,
                  child: Text("Last Name:",style: TextStyle(fontSize: 20,fontFamily: "Raleway",fontWeight: FontWeight.w700,color: Colors.black),),
                ),

                StreamBuilder(
                    stream: Firestore.instance.collection(widget.uid).document('PersonalInfo').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return new Text("Loading");
                      }
                      var userDocument = snapshot.data;
                      name2.text=userDocument["name2"];
                      // picture1[index] = userDocument["pic1"];
                      return  Row(
                          children:[ Container(
                            width: MediaQuery.of(context).size.width-70,

                            alignment: Alignment.topLeft,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black26,

                            ),
                            margin: EdgeInsets.all(6),
                            padding: EdgeInsets.only(left: 6),

                            child:  TextField(
                              controller: name2,

                              style: TextStyle(fontWeight: FontWeight.w600,fontFamily: "Raleway",fontSize: 18,color: Colors.white),
                              decoration: InputDecoration(border: InputBorder.none,),
                              readOnly: readonlyname2,
                            ),
                          ),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  readonlyname2=false;

                                });
                                //SelectDate(context);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                child: Icon(Icons.edit, color: Color(0xff0f4c81)
                                ),
                              ),
                            )
                          ]
                      );
                    }
                ),
                Container(
                  padding: EdgeInsets.only(left: 6,top: 8),
                  alignment: Alignment.topLeft,
                  child: Text("Phone:",style: TextStyle(fontSize: 20,fontFamily: "Roboto",fontWeight: FontWeight.w700,color: Colors.black),),
                ),
                StreamBuilder(
                    stream: Firestore.instance.collection(widget.uid).document('PersonalInfo').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return new Text("Loading");
                      }
                      var userDocument = snapshot.data;
                      phone.text=userDocument["phone"];
                      // picture1[index] = userDocument["pic1"];
                      return  Row(
                          children:[
                            Container(
                              width: MediaQuery.of(context).size.width-70,

                              alignment: Alignment.topLeft,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black26,

                              ),
                              margin: EdgeInsets.all(6),
                              padding: EdgeInsets.only(left: 6),

                              child:  TextField(
                                controller: phone,

                                style: TextStyle(fontWeight: FontWeight.w600,fontFamily: "Raleway",fontSize: 18,color: Colors.white),
                                decoration: InputDecoration(border: InputBorder.none,),
                                readOnly: readonlyphone,
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  readonlyphone=false;

                                });
                                //SelectDate(context);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                child: Icon(Icons.edit, color: Color(0xff0f4c81)
                                ),
                              ),
                            )
                          ]
                      );
                    }
                ),

                Container(
                  padding: EdgeInsets.only(left: 6,top: 8),
                  alignment: Alignment.topLeft,
                  child: Text("Address:",style: TextStyle(fontSize: 20,fontFamily: "Raleway",fontWeight: FontWeight.w700,color: Colors.black),),
                ),

                StreamBuilder(
                    stream: Firestore.instance.collection(widget.uid).document('PersonalInfo').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return new Text("Loading");
                      }
                      var userDocument = snapshot.data;
                      address.text=userDocument["address"];
                      // picture1[index] = userDocument["pic1"];
                      return  Row(
                          children:[
                            Container(
                            width: MediaQuery.of(context).size.width-70,

                            alignment: Alignment.topLeft,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black26,

                            ),
                            margin: EdgeInsets.all(6),
                            padding: EdgeInsets.only(left: 6),

                            child:  TextField(
                              controller: address,

                              style: TextStyle(fontWeight: FontWeight.w600,fontFamily: "Raleway",fontSize: 18,color: Colors.white),
                              decoration: InputDecoration(border: InputBorder.none,),
                              readOnly: readonlyaddress,
                            ),
                          ),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  readonlyaddress=false;

                                });
                                //SelectDate(context);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                child: Icon(Icons.edit, color: Color(0xff0f4c81)
                                ),
                              ),
                            )
                          ]
                      );
                    }
                ),





                Container(
                  width: 300.0,
                  height: 50.0,
                  margin: EdgeInsets.only(top: 30.0, bottom: 15),
                  child: RaisedButton(
                    color: Color(0xff0f4c81),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(15),
                        side: BorderSide(color: Color(0xFFceced8))),
                    onPressed: () {

                      databaseReference.collection(widget.uid).document('PersonalInfo').updateData({
                        "name1":name1.text,
                        "name2":name2.text,

                        "phone":phone.text,
                        "address":address.text,



                      });

                      Fluttertoast.showToast(msg: "Updated successfully",gravity: ToastGravity.BOTTOM,toastLength: Toast.LENGTH_SHORT,
                          backgroundColor: Colors.teal,textColor: Colors.white);

                    },
                    child: Text('Update', style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
