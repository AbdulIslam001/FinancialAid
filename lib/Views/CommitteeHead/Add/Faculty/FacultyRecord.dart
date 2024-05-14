
import 'dart:convert';

import 'package:financial_aid/Components/FacultyInfo.dart';
import 'package:financial_aid/Models/FacultyModel.dart';
import 'package:financial_aid/Services/Admin/AdminApiHandler.dart';
import 'package:financial_aid/Utilis/FlushBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../../Resources/CustomSize.dart';
import '../../../../Utilis/Routes/RouteName.dart';

class FacultyRecord extends StatelessWidget {
  bool isShow;
  String? studentId;
  String? name;
  FacultyRecord({required this.isShow,this.studentId,this.name,super.key});

  final TextEditingController _search = TextEditingController();

  Future<List<FacultyModel>> getFacultyMembers()async{
    List<FacultyModel> list=[];
    Response res=await AdminApiHandler().getAllFaculty();
    if(res.statusCode==200){
      dynamic obj=jsonDecode(res.body);
      FacultyModel f;
      for(var i in obj){
        f =FacultyModel(name: i["name"], profileImage: i["profilePic"],id: i["facultyId"],contact: i["contactNo"]);
        list.add(f);
      }
    }
    return list;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            Padding(
              padding: EdgeInsets.only(right: CustomSize().customWidth(context)/20),
              child:GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, RouteName.addFacultyMember);
                  },
                  child: const Icon(Icons.add_box_rounded)),
            )
          ],
          centerTitle: true,
          title:const Text("Faculty"),
          backgroundColor: Theme.of(context).primaryColor),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left:CustomSize().customWidth(context)/20,right: CustomSize().customWidth(context)/20,top: CustomSize().customWidth(context)/30),
            child: TextFormField(
              onChanged: (val){},
              controller: _search,
              decoration: InputDecoration(
                hintText: "search",
                labelText: "search",
                suffixIcon:Icon(Icons.search,size: CustomSize().customWidth(context)/10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(CustomSize().customHeight(context)/60),
                ),
              ),
            ),
          ),
          Expanded(
              child:FutureBuilder(
                future: getFacultyMembers(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: (){
                          if(isShow){
                            showDialog(context: context, builder: (context) {
                              return  AlertDialog(
                                title: const Column(
                                  children: [
                                    Text("Are you sure "),
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(onPressed: ()async{
                                    int code=await AdminApiHandler().assignGrader(int.parse(studentId!), int.parse(snapshot.data![index].id.toString()));
                                    if(code==200 && context.mounted){
                                      Navigator.pushNamed(context, RouteName.graders);
                                    }else if(context.mounted){
                                      Utilis.flushBarMessage("try again later", context);
                                    }
                                  }, child: const Text("yes")),
                                ],
                              );
                            },);
                          }else{

                          }
                        },
                        child: FacultyInfo(name: snapshot.data?[index].name??"", image: snapshot.data?[index].profileImage??""));
                  },);
                },
              )
          )
        ],
      ),
    );
  }
}
