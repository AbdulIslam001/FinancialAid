
import 'dart:convert';

import 'package:financial_aid/Components/FacultyInfo.dart';
import 'package:financial_aid/Models/FacultyModel.dart';
import 'package:financial_aid/Services/Admin/AdminApiHandler.dart';
import 'package:financial_aid/Utilis/FlushBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../../Components/CustomButton.dart';
import '../../../../Resources/CustomSize.dart';
import '../../../../Utilis/Routes/RouteName.dart';

class FacultyRecord extends StatefulWidget {
  bool isShow;
  String? studentId;
  String? name;
  FacultyRecord({required this.isShow,this.studentId,this.name,super.key});

  @override
  State<FacultyRecord> createState() => _FacultyRecordState();
}

class _FacultyRecordState extends State<FacultyRecord> {
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
              onChanged: (val){
                setState((){});
              },
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
                  if(snapshot.hasData){
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        if(snapshot.data![index].name.toLowerCase().contains(_search.text.toLowerCase())){
                          return GestureDetector(
                              onLongPress:(){
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Column(
                                        children: [
                                          Text("want to remove${snapshot.data![index].name}",style: TextStyle(
                                            fontSize: CustomSize().customWidth(context)/20,
                                          )),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              CustomButton(title: "cancel", loading: false,onTap:(){
                                                Navigator.pop(context);
                                              },),
                                              CustomButton(title: "yes", loading: false,onTap:(){},),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },);
                              },
                              child: FacultyInfo(name: snapshot.data?[index].name??"", image: snapshot.data?[index].profileImage??""));
                        }
                      },);
                  }else{
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: CircularProgressIndicator(),
                        )
                      ],
                    );
                  }
                },
              )
          )
        ],
      ),
    );
  }
}
