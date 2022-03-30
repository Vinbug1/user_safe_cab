
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user_safe_cab/api/error-resp.dart';
import 'package:user_safe_cab/api/taxiApi.dart';
import 'package:user_safe_cab/main.dart';
import 'package:user_safe_cab/models/rider.dart';
import 'package:user_safe_cab/user/UserMap.dart';

class UserRegisterScreen extends StatefulWidget {
     UserRegisterScreen({Key key}) : super(key: key);
  @override
  _UserRegister createState() => _UserRegister();
}

class _UserRegister extends State<UserRegisterScreen> {

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _validate = false;

  Future<Rider> _futureRider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2d72d),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children:[
                Container(
                margin: EdgeInsets.only(top:10),
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 35.0
                ),
                child: Center(
                    child: Image.asset("assets/images/image1.jpg")
                ),
              ),
                TextField(
                  controller: firstNameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "FirstName",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none
                      ),
                      prefixIcon: Icon(Icons.person, color: Colors.black,)
                  ),
                ),

                SizedBox(height: 20),
                TextField(
                  controller: lastNameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "LastName",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none
                      ),
                      //prefixIcon: Icon(Icons.person, color: Colors.black,)
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: " Phone Number",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none
                    ),
                    prefixIcon: Icon(Icons.phone
                      , color: Colors.black,)
                  ),
                ),

                SizedBox(height: 20),
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
                    prefixIcon: Icon(Icons.email, color: Colors.black,)
                  ),

                ),

                SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "please enter your password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none
                    ),
                    prefixIcon: Icon(Icons.add_moderator
                      , color: Colors.black,)
                  ),

                ),
                SizedBox(height: 20.0),
                  RaisedButton(
                    color: Colors.black,
                        textColor: Colors.white,
                        onPressed: () {
                          if(firstNameController.text.length < 3 || firstNameController.text.isEmpty) {
                            displayToastMessage("firstName can not be less than 3 characters or empty",context);
                          }
                          else if(lastNameController.text.isEmpty){
                            displayToastMessage("lastName can not be  empty",context);
                          }
                          else if(phoneController.text.length < 11 || phoneController.text.isEmpty){
                            displayToastMessage("phone number must be atLest 11 digit and not empty ",context);
                          }
                          else if(!emailController.text.contains("@")|| emailController.text.isEmpty) {
                            displayToastMessage("email is not valid and can not be empty", context);
                          }
                          else if(passwordController.text.length < 6 || passwordController.text.isEmpty) {
                            displayToastMessage(" Password must be atLest 6 character", context);
                          }
                          else {
                            registerNewUser(context);
                          }
                        },
                        child: Container(
                          height: 50.0,
                          child: Center(
                            child: Text('SignUp',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ), shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                      ),
              ],
            ),
          ),
        ),
        ),
      )
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void registerNewUser(BuildContext context) async
  {
      final User firebaseUser = (
          await _firebaseAuth
              .createUserWithEmailAndPassword
            (
              email: emailController.text,
              password: passwordController.text
          ).catchError((errMsg){
            displayToastMessage("Error" + errMsg.toString(), context);
          })).user;
      if(firebaseUser != null)
      {

        Map userDataMap = {
          'firstName' : firstNameController.text.trim(),
          'lastName' : lastNameController.text.trim(),
          'phone' : phoneController.text.trim(),
          'email': emailController.text.trim(),
          'password' : passwordController.text,
        };
        usersRef.child(firebaseUser.uid).set(userDataMap);
        displayToastMessage("congratulations your account has been created ", context);
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserMap())
        );

      }
      else
        {
          displayToastMessage("New user account has been created", context);
       }
  }

// for external api back end
 /* void registerNewUser(BuildContext context ) async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      SnackBar(content: Text('Please fix the errors in red before submitting.'));
    } else {
      form.save();
      _futureRider = await createUser(
          firstNameController.text,
          lastNameController.text,
          emailController.text,
          phoneController.text,
          passwordController.text) as Future<Rider>;
      if (_futureRider != null) {
        _saveAndRedirectToHome();
      } else {
        SnackBar(content: Text((_futureRider.ApiError).error));
      }
    }
  }
  void _saveAndRedirectToHome() async {
    *//*SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("userId", (_apiResponse.Data as User).userId);*//*
    Navigator.pushNamedAndRemoveUntil(
        context, '/UserLogInScreen', ModalRoute.withName('/UserLogInScreen'));
        *//*arguments: (_futureUser.Data as User));*//*
  }*/
}

displayToastMessage(String message, BuildContext context){
  Fluttertoast.showToast(msg: message);
}

