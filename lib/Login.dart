
import 'dart:convert';

import 'package:expence_manager/Config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget
{
  @override
  LoginState createState() =>LoginState();

}
class LoginState extends State<Login>
{
  TextEditingController _contact = new TextEditingController();
  TextEditingController _pwd = new TextEditingController();
  _readsharedpref() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    if(pref.containsKey("islogin"))
      {
        if(pref.getBool("islogin")==true)
          {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed("master");
          }
      }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _readsharedpref();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Login"),
      // ),
      body: Stack(
        children: [
          Container(
            child: Image.network("https://images.unsplash.com/photo-1561414926-0ae39e14fc4a?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=1000&q=80",height: MediaQuery.of(context).size.height,fit: BoxFit.fill,),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 400,
                height: 300,
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: Colors.black,
                  elevation: 80,
                  child: Form(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Sign In",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,letterSpacing: 1),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _contact,
                            keyboardType: TextInputType.number,
                            decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: "Enter Contact No",
                              labelText: "Contact No",
                              prefixIcon: Icon(Icons.person)
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _pwd,
                            obscureText: true,
                            keyboardType: TextInputType.name,
                            decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: "Enter Password",
                              labelText: "Password",
                              prefixIcon: Icon(Icons.lock)
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                            ),
                            child: Text("LOGIN",style: TextStyle(color: Colors.white),),
                            color: Color(0xff9E5338),
                            onPressed: () async{

                              var contact = _contact.text.toString();
                              var password = _pwd.text.toString();
                                      var response = await http.post(config.LOGIN,body: {"contact" :contact,"password" :password});
                                      if(response.statusCode==200)
                                      {
                                        var json = jsonDecode(response.body);
                                        if(json["status"].toString()=="yes")
                                          {
                                             var user_id = json["userdata"]["user_id"];
                                             var name = json["userdata"]["name"];
                                                SharedPreferences pref = await SharedPreferences.getInstance();
                                                pref.setBool("islogin", true);
                                                pref.setString("name", name);
                                                pref.setString("userid", user_id);
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pushNamed("master");

                                          }
                                        else
                                          {
                                              Fluttertoast.showToast(
                                                  msg: 'contact no or password not found',
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIos: 5,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.yellow
                                              );
                                          }
                                      }

                                // if(_username.text.toString()=="admin" && _pwd.text.toString()=="admin")
                                //   {
                                //     SharedPreferences pref = await SharedPreferences.getInstance();
                                //     pref.setBool("islogin", true);
                                //     pref.setString("username", _username.text.toString());
                                //     Navigator.of(context).pop();
                                //     Navigator.of(context).pushNamed("master");
                                //   }
                                // else
                                // {
                                //   Fluttertoast.showToast(
                                //       msg: 'username or password not found',
                                //       toastLength: Toast.LENGTH_SHORT,
                                //       gravity: ToastGravity.CENTER,
                                //       timeInSecForIos: 5,
                                //       backgroundColor: Colors.red,
                                //       textColor: Colors.yellow
                                //   );
                                // }
                            },
                          )
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RichText(
                              text: TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(

                                    text: "Sign Up",
                                    style: TextStyle(color: Colors.blue,),
                                    recognizer: new TapGestureRecognizer()..onTap = ()
                                    {
                                      Navigator.of(context).pushNamed('Register');
                                    },
                                    )
                                  ]
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      )
    );

  }

}