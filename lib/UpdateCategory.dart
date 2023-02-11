import 'dart:convert';

import 'package:expence_manager/Config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateCategory extends StatefulWidget
{
  @override
  UpdateCategoryState createState() => UpdateCategoryState();
}
class UpdateCategoryState extends State<UpdateCategory>
{
  TextEditingController _category = TextEditingController();
  String id="";

  get_data(id) async{
    var response=await http.post(config.GET_SINGLE_DATA,body: {"id":id});
    if(response.statusCode==200)
    {
      var json = jsonDecode(response.body);
      _category.text=json[0]["category_name"].toString();

    }
  }

  @override
  Widget build(BuildContext context) {


    final Map args=ModalRoute.of(context).settings.arguments;
    if(args!=null)
    {
      setState(() {
        id=args["id"].toString();
        get_data(id);
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Category"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _category,
              keyboardType: TextInputType.name,
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: "Enter Category",
                  labelText: "Category"
              ),
            ),
          ),
          RaisedButton(
            child: Text("Update",style: TextStyle(color: Colors.white)),
            color: Colors.black54,
            onPressed: () async {
              var cat_name = _category.text.toString();
              var response = await http.post(config.UPDATE_CATEGORY,body: {"category_name":cat_name,"id":id});
              if(response.statusCode==200)
              {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed("category");
              }

            },
          )
        ],
      ),

    );
  }

}
