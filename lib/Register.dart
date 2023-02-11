

import 'package:expence_manager/Config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget{
  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register>
{
  TextEditingController _name = new TextEditingController();
  TextEditingController _contact = new TextEditingController();
  TextEditingController _pwd = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

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
                height: 500,
                // decoration: BoxDecoration(
                //   gradient: LinearGradient(
                //     colors: [Colors.lightGreen, Colors.orange],
                //     begin: FractionalOffset.topLeft,
                //     end: FractionalOffset.bottomRight,
                //   ),
                // ),
                child:  Form(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Sign UP",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,letterSpacing: 1,color: Colors.white),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _name,
                            style: TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            keyboardType: TextInputType.text,
                            decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.white, width: 2.0),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: "Enter User Name",hintStyle: TextStyle(color: Colors.white),
                                labelText: "User Name",labelStyle: TextStyle(color: Colors.white,fontSize: 18),
                                prefixIcon: Icon(Icons.person,color: Colors.white,)
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _contact,
                            style: TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            keyboardType: TextInputType.number,
                            decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: "Enter Contact No",hintStyle: TextStyle(color: Colors.white),
                                labelText: "Contact No",labelStyle: TextStyle(color: Colors.white,fontSize: 18),
                                prefixIcon: Icon(Icons.call,color: Colors.white,)
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _pwd,
                            style: TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: "Enter Password",hintStyle: TextStyle(color: Colors.white),
                                labelText: "Password",labelStyle: TextStyle(color: Colors.white,fontSize: 18),
                                prefixIcon: Icon(Icons.lock,color: Colors.white,)
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _email,
                            style: TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            keyboardType: TextInputType.text,
                            decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: "Enter E-mail",hintStyle: TextStyle(color: Colors.white),
                                labelText: "E-Mail",labelStyle: TextStyle(color: Colors.white,fontSize: 18),
                                prefixIcon: Icon(Icons.mail,color: Colors.white,)
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              child: Text("REGISTER",style: TextStyle(color: Colors.white),),
                              color: Color(0xff7E8478),
                              elevation: 1000,
                              shape: new RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              onPressed: () async{
                                  var name = _name.text.toString();
                                  var contact = _contact.text.toString();
                                  var pwd = _pwd.text.toString();
                                  var email = _email.text.toString();
                                  var response = await http.post(config.REGISTER_DATA,body: {"name" :name,"contact" :contact,"password" :pwd,"email" :email});
                                  if(response.statusCode==200)
                                    {
                                        var op = response.body.toString();
                                        print("response :" +op);
                                    }
                                  else
                                    {
                                      print("API call problem");
                                    }
                              },
                            )
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RichText(
                              text: TextSpan(
                                  text: "Already have an account? ",
                                  style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),
                                  children: [
                                    TextSpan(

                                      text: "Sign In",
                                      style: TextStyle(color: Colors.yellow,),
                                      recognizer: new TapGestureRecognizer()..onTap = ()
                                      {
                                        Navigator.of(context).pushNamed('Login');
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
        ],
      )
    );
  }

}