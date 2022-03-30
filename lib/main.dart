import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_safe_cab/dataHandler/appData.dart';
import 'package:user_safe_cab/user/HomeScreen.dart';

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
  runApp(MyApp());
}
 DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("users");
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Safe Cab',
        theme: ThemeData(

          primarySwatch: Colors.amber,
        ),
        home: HomeScreen(),
       debugShowCheckedModeBanner: false,
      ),
    );
  }
}

