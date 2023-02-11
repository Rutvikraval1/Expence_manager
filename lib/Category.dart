import 'dart:convert';

import 'package:expence_manager/Config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Category extends StatefulWidget
{
  @override
  CategoryState createState() =>CategoryState();

}
class CategoryState extends State<Category>
{
  Future<List> data;
  Future<List> getdata() async
  {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userid = pref.getString("userid");

    var response = await http.post(config.GET_CATEGORY,body: {"userid":userid});
    if(response.statusCode==200)
      {
        var jsondata = jsonDecode(response.body);
        return jsondata;
      }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = getdata();
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("Category"),
     ),
     floatingActionButton: new FloatingActionButton(
       child: Icon(Icons.add),
         onPressed: () {
         Navigator.of(context).pushNamed("addcategory");
     }),
     body: FutureBuilder(
       future: data,
       builder: (context, snapshot) {
        if(snapshot.hasData)
          {
              if(snapshot.data.length<=0)
                {
                    return Center(
                      child: Text("No Data Found"),
                    );
                }
              else
                {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                    itemBuilder: (context, position) {
                    return ListTile(
                      title: Text(snapshot.data[position]["category_name"].toString().toUpperCase()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        IconButton(icon: Icon(Icons.edit), onPressed: () async {
                          var id = snapshot.data[position]["category_id"].toString();
                          Navigator.of(context).pushNamed("updatecategory",arguments: {"id":id});

                        },),
                        IconButton(icon: Icon(Icons.delete), onPressed: () async {
                          var id = snapshot.data[position]["category_id"].toString();
                          var response = await http.post(config.DELETE_CATEGORY_DATA,body: {"id":id});
                          if(response.statusCode==200)
                          {
                            if(response.body.toString()=="yes")
                            {
                              print("record deleted");
                              setState(() {
                                data= getdata();
                              });

                            }
                          }
                        },),
                      ],),

                    );


                      // leading: Icon(Icons.update),
                      // onTap: () {
                      //     showDialog(
                      //         context: context,
                      //       builder: (BuildContext context)
                      //         {
                      //           AlertDialog dialog = new AlertDialog(
                      //             title: Text("Warning"),
                      //             content: Text("Are You Sure Deleted?"),
                      //             actions: [
                      //               FlatButton(
                      //                   onPressed: () {
                      //                     Navigator.of(context).pop();
                      //                     var id = snapshot.data[position]["category_id"].toString();
                      //                     Navigator.of(context).pushNamed("updatecategory",arguments: {"id":id});
                      //                   },
                      //                   child: Text("Update")
                      //               ),
                      //               FlatButton(
                      //                   onPressed: () async {
                      //                     var id = snapshot.data[position]["category_id"].toString();
                      //                     var response = await http.post(config.DELETE_CATEGORY_DATA,body: {"id":id});
                      //                     if(response.statusCode==200)
                      //                     {
                      //                       if(response.body.toString()=="yes")
                      //                       {
                      //                         print("record deleted");
                      //                         setState(() {
                      //                           data= getdata();
                      //                         });
                      //                       }
                      //                     }
                      //                     Navigator.of(context).pop();
                      //
                      //
                      //                   },
                      //                   child: Text("Delete")
                      //               ),
                      //               FlatButton(
                      //                   onPressed: () {
                      //                     Navigator.of(context).pop();
                      //                   },
                      //                   child: Text("Cancel")
                      //               ),
                      //             ],
                      //           );
                      //           return dialog;
                      //         }
                      //     );
                      // },

                    },
                  );
                }
          }
        else
          {
              return Center(
                child: CircularProgressIndicator(),
              );
          }
       },
     ),
   );
  }

}