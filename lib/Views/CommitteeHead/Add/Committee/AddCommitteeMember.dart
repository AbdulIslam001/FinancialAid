


import 'dart:convert';

import 'package:financial_aid/Components/CommitteeInfo.dart';
import 'package:financial_aid/Components/CustomButton.dart';
import 'package:financial_aid/Components/FacultyInfo.dart';
import 'package:financial_aid/Models/FacultyModel.dart';
import 'package:financial_aid/Services/Admin/AdminApiHandler.dart';
import 'package:financial_aid/Utilis/FlushBar.dart';
import 'package:financial_aid/viewModel/CommitteeViewModel/AddCommitteeViewModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../../../Resources/CustomSize.dart';
import '../../../../Utilis/Routes/RouteName.dart';

class AddCommitteeMember extends StatelessWidget {
  AddCommitteeMember({super.key});

  final TextEditingController _search = TextEditingController();

  Future<List<FacultyModel>> getFacultyMembers()async{
    List<FacultyModel> list=[];
    Response res=await AdminApiHandler().getAllFaculty();
    if(res.statusCode==200){
      dynamic obj=jsonDecode(res.body);
      FacultyModel f;
      for(var i in obj){
        f =FacultyModel(name: i["name"], profileImage: i["profilePic"],id: i["facultyId"] ,contact: i["contactNo"]);
        list.add(f);
      }
    }
    return list;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title:const Text("Add Committee Member"),
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
                  if(snapshot.hasData){
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Consumer<AddCommitteeViewModel>(
                              builder: (context, value, child){
                                return CommitteeInfo(
                                    isTrue: false,
                                    name: snapshot.data?[index].name??"",
                                    image: snapshot.data?[index].profileImage??"",
                                    onTap: ()async{
//                                      value.setIsTrue(true);
                                      int code= await AdminApiHandler().addCommitteeMember(snapshot.data![index].id);
                                      if(context.mounted){
                                        if(code==200){
                                          Utilis.flushBarMessage("Added", context);
                                        }else if(code==302){
                                          Utilis.flushBarMessage("already a member", context);
                                        }else{
                                          Utilis.flushBarMessage("try again later", context);
                                        }
                                      }
  //                                    value.setIsTrue(false);
                                    });
                              },),
                          ],
                        );
                      },);
                  }else{
                    return const Center(
                      child:CircularProgressIndicator(),
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
