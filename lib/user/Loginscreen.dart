import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:user_safe_cab/AllWidgets/progressDialog.dart';
import 'package:user_safe_cab/user/UserMap.dart';
import '../main.dart';
import 'RegisterScreen.dart';

class UserLoginScreen extends StatefulWidget {

  @override
  _UserLogin createState() => _UserLogin();
}
class  _UserLogin extends State<UserLoginScreen>{


  final TextEditingController emailController =  TextEditingController();
  final TextEditingController passwordController =  TextEditingController();

  @override
  Widget build(BuildContext context) {

   /* showDialog(
        context: context,
        barrierDismissible:false,
        builder: (BuildContext context)
        {
         return  ProgressDialog(message: "Authenticating , please wait...",);
        }

    );*/
    return Scaffold(
      backgroundColor:  Colors.amber,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top:15),
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    horizontal: 35.0,
                    vertical: 35.0
                ),
                child: Center(
                    child: Image.asset("assets/images/image1.jpg")
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10
              ),
                child: Center(
                  child: Text(
                    "Welcome User",
                    style: TextStyle(
                      fontSize:35.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily:"Brand Bold"
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(height: 30),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Email@here.come",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none
                        ),
                        prefixIcon: Icon(Icons.email,color: Colors.black,)
                    ),

                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none
                        ),
                        prefixIcon: Icon(Icons.add_moderator,color: Colors.black,)
                    ),

                  ),
                ],
               ),
              ),
              SizedBox(height:20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: RaisedButton(
                      color:Colors.black,
                      textColor: Colors.white,
                          child: Container(
                            height: 55.0,
                            child: Center(
                              child: Text(
                                'Login',
                                style: TextStyle(color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Brand Bold"
                                ),
                              ),
                            ),
                          ),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(8.0)
                      ),
                      onPressed: ()
                      {
                          if(!emailController.text.contains("@")) {
                          displayToastMessage("email is invalid ", context);
                          }
                          else if(passwordController.text.isEmpty) {
                          displayToastMessage(" Password is mandatory ", context);
                          }
                          else {
                          loginUser(context);
                          }
                      },
                      ),
                    ),

                  Text('Forget Password',
                    style: TextStyle(fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: FlatButton(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => UserRegisterScreen(),
                            ));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8.0)
                        ),
                        padding: EdgeInsets.all(20.0),
                        //color: Theme.of(context).primaryColor,
                        child: Text(
                          'Don\'t have an account? Sign up',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginUser(BuildContext context) async
  {
    final User firebaseUser = (
        await _firebaseAuth.signInWithEmailAndPassword
          (
            email: emailController.text,
            password: passwordController.text
        ).catchError((errMsg){
          displayToastMessage("Error" + errMsg.toString(), context);
        })).user;
    if(firebaseUser != null)
    {
      usersRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if(snap.value != null){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserMap())
          );
          displayToastMessage("You are loggedIn", context);
        }
        else{
         _firebaseAuth.signOut();
          displayToastMessage("This user has no existing record, please register using the button below", context);
        }
      });
    }
    else
    {
      displayToastMessage("Error occurred, can't signIn", context);
    }
  }


  // third party api login function
  /*sendForm() async {
    var url ="https://promoteur-api.herokuapp.com/api/messages";
    var jsonResponse;
    Map data = {

      "email":     emailController.text,
      "passWord":  passwordController.text
    };
    Map body = {"message": data};
    var response = await http.post(
      Uri.parse(url),body: jsonEncode(body),
      headers: {'Content-type': 'application/json'},
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      jsonResponse = jsonEncode(response.body);
      if (jsonResponse != null) {
        print(response.body + " jsonResponse is not null");
        setState(() {
          UserMap();
        });
      }
    } else {
      setState(() {
        print(response.body + "error jsonResponse = null");
      });

    }
  }*/
}


