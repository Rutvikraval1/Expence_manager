import 'dart:convert';

import 'package:expence_manager/Config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_skeleton/flutter_skeleton.dart';

class ShowTransaction extends StatefulWidget
{
  @override
  ShowTransactioState createState() =>ShowTransactioState();

}
class ShowTransactioState extends State<ShowTransaction>
{
  Future<List> data;


  Future<List> getdata() async
  {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var userid = pref.getString("userid");
      var response = await http.post(config.GET_TRANSACTION_DATA,body: {"userid":userid});
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
      title: Text("Transaction"),
    ),
    body: FutureBuilder(
      future: data,
      builder: (context, snapshot)
      {
        if(snapshot.hasData)
          {
              if(snapshot.data.length<=0)
                {
                  return Center(
                    child: Text("No data found"),
                  );
                }
                else
                  {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, position) {

                        return
                          ListTile(
                          title: Center(
                              child: Text(snapshot.data[position]["title"].toString())
                          ),
                          subtitle: Container(
                            // color: Colors.black38,

                            child: Column(
                                  children: [
                                    FadeInImage.assetNetwork(placeholder: "images/loading.gif",height: 100, image: config.BASE_URL+"img/"+snapshot.data[position]["billimage"].toString()),
                                    Text(snapshot.data[position]["description"].toString()),
                                    Text(snapshot.data[position]["trans_type"].toString()),
                                    Text(snapshot.data[position]["amount"].toString()),
                                    Text(snapshot.data[position]["trans_datetime"].toString()),
                                  ],
                              ),


                          ),
                        );

                        },);
                  }
          }
        else
        {
          return Center(
            child: CardListSkeleton(
              style: SkeletonStyle(
                theme: SkeletonTheme.Light,
                isShowAvatar: true,
                isCircleAvatar: true,
                barCount: 2,
              ),
            ),
          );
        }
      },
    ),
  );
  }

}