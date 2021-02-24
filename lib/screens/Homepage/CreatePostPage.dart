import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_ink_well/image_ink_well.dart';
import 'package:intl/intl.dart';

TextEditingController namex=new TextEditingController();
class CreatePostPage extends StatefulWidget {

  final uid;

  CreatePostPage({Key key, this.uid}) : super(key: key);
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}


class _CreatePostPageState extends State<CreatePostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                  Container(
                    padding: EdgeInsets.all(15),
                  margin: EdgeInsets.symmetric(vertical: 10),
                   child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Enter First Name :",
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
                          controller: namex,

                          style: TextStyle(fontWeight: FontWeight.w600,fontFamily: "Roboto",fontSize: 18,color: Colors.white),
                          decoration: InputDecoration(border: InputBorder.none,hintText: "James Kernel"),
                          //readOnly: true,
                        ),


                      ),
                    ],
                  ),
                ),

                Container(
                  alignment: Alignment.bottomRight,

                  margin: EdgeInsets.only(right: 10),
                  width: MediaQuery.of(context).size.width,
                  child: GestureDetector(
                    onTap: () async {

                      if(namex.text!=""){
                        DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
                        String date = dateFormat.format(DateTime.now());
                        final snapShot =  await  Firestore.instance.collection(widget.uid).document("Posts").collection("Postx").document("zzzzz").get();

                        Firestore.instance.collection(widget.uid).document("Posts").collection("Postx").document().setData({
                          "name": namex.text,
                          "date":date,
                        });
                        if (snapShot.exists){
                          var data=snapShot.data;
                          //it exists

                          Firestore.instance.collection(widget.uid).document("Posts").collection("Postx").document("zzzzz").setData({
                            'length': data["length"]+1,
                          });
                          Fluttertoast.showToast(msg:"Post Added Successfully",gravity: ToastGravity.BOTTOM,toastLength: Toast.LENGTH_SHORT,
                              backgroundColor: Colors.white,textColor: Colors.teal);
                        }
                      }
                      else{
                        Fluttertoast.showToast(msg:"Enter a name",gravity: ToastGravity.BOTTOM,toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.white,textColor: Colors.teal);
                      }


                     // _signInWithEmailAndPassword();
                     },
                    child: Container(
                      width: 100,
                       height: 40,
                       color: Colors.blueAccent,
                       alignment: Alignment.center,

                      child: Text('post',style: TextStyle(fontSize: 20, color: Colors.white,fontFamily: "Roboto",fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ) ,
                StreamBuilder(
                    stream: Firestore.instance.collection(widget.uid).document('Posts').collection("Postx").document("zzzzz").snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return new Text("Loading");
                      }
                      var userDocument = snapshot.data;
                       // picture1[index] = userDocument["pic1"];
                      return  Container(
                        alignment: Alignment.topLeft,
                        //height: 320,
                        margin: EdgeInsets.all(6),
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: int.parse(userDocument["length"].toString()),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(

                                margin: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1,color: Colors.black26)

                                ),
                                padding: EdgeInsets.all(10),
                                child:  StreamBuilder(
                                    stream: Firestore.instance.collection(widget.uid).document('Posts').collection("Postx").snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return new Text("Loading");
                                      }
                                      var userDocument = snapshot.data.documents[index];

                                      return Row(
                                        children: [
                                          StreamBuilder(
                                              stream: Firestore.instance.collection(widget.uid).document("PersonalInfo").snapshots(),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return new Text("Loading");
                                                }
                                                var userDocument = snapshot.data;
                                                return CircleImageInkWell(
                                                  size: 35,
                                                  image: NetworkImage(userDocument["profilePic"]),
                                                );

                                              }
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(left: 5),
                                                child: Text(userDocument["name"],
                                                  style: TextStyle(fontWeight: FontWeight.w600,fontFamily: "Raleway",fontSize: 18,color: Colors.black),),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 5),

                                                child: Text(userDocument["date"],
                                                  style: TextStyle(fontWeight: FontWeight.w600,fontFamily: "Raleway",fontSize: 15,color: Colors.black),),
                                              )
                                            ],
                                          )

                                        ],
                                      );
                                    }
                                ),


                              );

                            }),
                      );
                    }
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
