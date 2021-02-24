import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techcurve/screens/Homepage/Homepage.dart';
import 'package:techcurve/screens/authentication/loginPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
//  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  var uid = prefs.getString('uid');
  print(uid);

  runApp(
      MaterialApp(
        home: uid == null ? LoginPage() : Homepage(uid: uid,),
        debugShowCheckedModeBanner: false,
      )
  );

}