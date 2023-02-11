import 'dart:convert';
import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:expence_manager/Config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Master extends StatefulWidget {

  // final ValueChanged<DateTime> onSelectedDate;
  // final DateTime initialDate;
  // const Master({
  //   @required this.onSelectedDate,
  //   @required this.initialDate,
  //   Key key,
  // }) : super(key: key);
  @override
  MasterState createState() => MasterState();
}


class MasterState extends State<Master> {
  int radiogrp;

  File _image;

  final picker = ImagePicker();


  selectFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  _imgFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  _handelradiochange(int a) {
    setState(() {
      radiogrp = a;
    });
  }
  final _titles = FocusNode();
  void dispose() {
    _title.dispose();
    super.dispose();
  }


  String _setDate;
  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != selectedDate)
      setState(() {
        selectedDate = pickedDate;
        trans_datetime.text = DateFormat.yMd().format(selectedDate);
      });
  }

  TextEditingController _title = TextEditingController();
  TextEditingController _desc = TextEditingController();
  TextEditingController _amount = TextEditingController();
  final TextEditingController trans_datetime = TextEditingController();

  var formkey = new GlobalKey<FormState>();
  String uname="";
  _getShredpref() async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      if(pref.containsKey("name"))
        {
            setState(() {
              uname = pref.getString("name");
            });
        }
  }
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getShredpref();
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Manager"),
      ),
      drawer: Drawer(
          child: ListView(
            children: [
              Container(
                  width: 80,
                  height: 80,
                  color: Colors.black38,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "Hello, "+uname,
                              style: TextStyle(
                                fontSize: 25.0,
                                fontStyle: FontStyle.italic,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              Container(
                width: 100,

                // color: Colors.grey,
                child: Column(
                  children: [
                    ListTile(
                        title: Text(
                          "Category",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        leading: Icon(Icons.category),
                        trailing: Icon(Icons.arrow_right),
                        onTap: () {
                          Navigator.of(context).pushNamed("category");
                        }
                        ),
                    ListTile(
                        title: Text(
                          "Trasaction",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        leading: Icon(Icons.toys_rounded),
                        trailing: Icon(Icons.arrow_right),
                        onTap: () {
                          Navigator.of(context).pushNamed("showtransaction");
                        }
                    ),
                    ListTile(
                        title: Text(
                          "Logout",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        leading: Icon(Icons.logout),

                        onTap: () async {
                          SharedPreferences pref = await SharedPreferences.getInstance();
                          pref.remove("islogin");
                          pref.remove("name");
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed("Login");
                        }
                    ),
                  ],
                ),
              ),
            ],
          )),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Padding(
              padding: const EdgeInsets.all(11.0),
              child: Container(
                // color: Colors.yellow,
                decoration: new BoxDecoration(
                    border: new Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Radio(
                            value: 0,
                            groupValue: radiogrp,
                            onChanged: _handelradiochange,
                            // activeColor: Colors.black
                          ),
                          Text("Income"),
                          Radio(
                            value: 1,
                            groupValue: radiogrp,
                            onChanged: _handelradiochange,
                            // activeColor: Colors.black
                          ),
                          Text("Expense"),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [

                            Column(
                              children: [
                                FlatButton(
                                    onPressed: () {
                                      selectFromCamera();
                                     // Center(child: new Image.file(cameraFile));
                                },
                                  child: Row(
                                    children: [
                                      Icon(Icons.camera_alt),
                                      Text("Camera"),
                                    ],
                                  ),
                                ),
                                // Container(
                                //     width: MediaQuery.of(context).size.width * 0.30,
                                //     height: MediaQuery.of(context).size.height * 0.2,
                                //     // margin: EdgeInsets.only(top: 3),
                                //     decoration: BoxDecoration(
                                //         color: Colors.grey,
                                //         shape: BoxShape.circle,
                                //         image: DecorationImage(
                                //             image: cameraFile == null
                                //                 ? FileImage(cameraFile)
                                //            : FileImage(_image),
                                //             fit: BoxFit.cover))),
                              ],
                            ),
                            Column(
                              children: [
                                FlatButton(
                                  onPressed: () {
                                    _imgFromGallery();
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.image),
                                      Text("Gallery"),
                                    ],
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                //   child: Container(
                                //       width: MediaQuery.of(context).size.width * 0.30,
                                //       height: MediaQuery.of(context).size.height * 0.2,
                                //       // margin: EdgeInsets.only(top: 20),
                                //       decoration: BoxDecoration(
                                //           color: Colors.grey,
                                //           shape: BoxShape.circle,
                                //           image: DecorationImage(
                                //               image: _image == null
                                //                   ? AssetImage('images/ic_business.png')
                                //                   : FileImage(_image),
                                //               fit: BoxFit.cover))),
                                // ),
                              ],
                            ),


                          ],
                        ),
                      ),
                      _image == null
                          ? Text('No image selected.')
                          : Image.file(_image,height: 300,width: 200),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                            onFieldSubmitted: (_){
                              FocusScope.of(context)
                                  .requestFocus(_titles);
                            },
                            controller: _title,
                            decoration: new InputDecoration(
                                labelText: "Title",
                                hintText: "Enter Title",
                                border: new OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5)))),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                            controller: _desc,
                            focusNode:_titles,
                            decoration: new InputDecoration(
                                labelText: "Description",
                                hintText: "Enter Description",
                                border: new OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5)))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                            controller: _amount,
                            keyboardType: TextInputType.number,
                            decoration: new InputDecoration(
                                labelText: "Amount",
                                hintText: "Enter Amount",
                                border: new OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5)))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: trans_datetime,
                          onSaved: (value) => (String val){
                            _setDate = val;
                          },
                          readOnly: true,
                          // keyboardType: TextInputType.nu/mber,
                          decoration: new InputDecoration(
                            suffixIcon: Icon(
                                Icons.calendar_today_outlined),
                            labelText: "Date",
                            // hintText: "Enter Amount",
                            border: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onTap: () async {
                            _selectDate(context);
                          },

                        ),

                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            decoration: new BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.circular(5)
                            ),
                            height: 50,

                            child: InkWell(
                              child : Center(
                                  child: Text("Submit",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white
                                    ),
                                  )
                              ),
                              onTap: () async {
                                var t="";
                                if(radiogrp==0)
                                {
                                  t="income";
                                }
                                else
                                {
                                  t="expense";
                                }
                                var t_type = t;
                                var title = await _title.text.toString();
                                var desc = await _desc.text.toString();
                                var amt = await _amount.text.toString();
                                var t_datetime = await trans_datetime.text.toString();


                                List<int> imageBytes = _image.readAsBytesSync();
                                String imageB64 = base64Encode(imageBytes);
                                SharedPreferences pref = await SharedPreferences.getInstance();
                                var userid = pref.getString("userid");

                                var response = await http.post(config.ADD_TRANSACTION,body: {"billimage":imageB64,"trans_type":t_type,"title":title,"desc":desc,"amount":amt,"trans_datetime":t_datetime,"userid":userid});
                                if(response.statusCode==200)
                                  {
                                      var op = response.body.toString();
                                      print("response"+op);
                                      // print("date time"+transdatetime);
                                      Navigator.of(context).pushNamed('showtransaction');
                                  }
                              },
                            )
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}