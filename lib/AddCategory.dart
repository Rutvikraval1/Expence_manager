import 'package:expence_manager/Config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddCategory extends StatefulWidget
{
  @override
  AddCategoryState createState() =>AddCategoryState();
}
class AddCategoryState extends State<AddCategory>
{
  TextEditingController _category = TextEditingController();
  var formkey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("Add Category"),
     ),
     body: Column(
       children: [
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Form(
             key: formkey,
             child:  TextFormField(
               controller: _category,
               keyboardType: TextInputType.name,
               autovalidateMode: AutovalidateMode.onUserInteraction,
               decoration: new InputDecoration(
                   border: new OutlineInputBorder(
                     borderRadius: BorderRadius.circular(10.0),
                   ),
                   hintText: "Enter Category",
                   labelText: "Category"
               ),
               validator: (value){
                  if(value.isEmpty)
                    {
                      return "Please enter category";
                    }
                  return null;
               },
             ),
           )

         ),
         RaisedButton(
           child: Text("Add",style: TextStyle(color: Colors.white),),
           color: Colors.black54,
           onPressed: () async {
             if(formkey.currentState.validate())
               {
                 print("form is valid");
                 var cat_name = _category.text.toString();
                 SharedPreferences pref = await SharedPreferences.getInstance();
                 var userid = pref.getString("userid");
                 var response = await http.post(config.ADD_CATEGORY,body: {"category_name":cat_name,"userid":userid});
                 if(response.statusCode==200)
                 {
                   var op = response.body.toString();
                   print(op);
                 }
                 Navigator.of(context).pushNamed("category");
               }

           },
         )
       ],
     ),

   );
  }

}