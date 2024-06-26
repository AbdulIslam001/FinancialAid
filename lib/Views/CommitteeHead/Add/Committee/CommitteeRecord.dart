import 'dart:convert';

import 'package:financial_aid/Components/FacultyInfo.dart';
import 'package:financial_aid/Models/FacultyModel.dart';
import 'package:financial_aid/Services/Admin/AdminApiHandler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../../Components/CustomButton.dart';
import '../../../../Resources/CustomSize.dart';
import '../../../../Utilis/FlushBar.dart';
import '../../../../Utilis/Routes/RouteName.dart';

class CommitteeRecord extends StatefulWidget {
  CommitteeRecord({super.key});

  @override
  State<CommitteeRecord> createState() => _CommitteeRecordState();
}

class _CommitteeRecordState extends State<CommitteeRecord> {
  final TextEditingController _search = TextEditingController();

  bool isTrue=false;
  Future<List<FacultyModel>> getFacultyMembers() async {
    List<FacultyModel> list = [];
    Response res = await AdminApiHandler().getCommitteeMembers();
    if (res.statusCode == 200) {
      dynamic obj = jsonDecode(res.body);
      FacultyModel f;
      for (var i in obj) {
        f = FacultyModel(
            name: i["name"],
            profileImage: i["profilePic"],
            id: i["committeeId"],
            contact: i["contactNo"]);
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
              padding: EdgeInsets.only(
                  right: CustomSize().customWidth(context) / 20),
              child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.addCommitteeMember);
                  },
                  child: const Icon(Icons.add_box_rounded)),
            )
          ],
          centerTitle: true,
          title: const Text("Committee"),
          backgroundColor: Theme.of(context).primaryColor),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: CustomSize().customWidth(context) / 20,
                right: CustomSize().customWidth(context) / 20,
                top: CustomSize().customWidth(context) / 30),
            child: TextFormField(
              onChanged: (val) {
                setState(() {

                });
              },
              controller: _search,
              decoration: InputDecoration(
                hintText: "search",
                labelText: "search",
                suffixIcon: Icon(Icons.search,
                    size: CustomSize().customWidth(context) / 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      CustomSize().customHeight(context) / 60),
                ),
              ),
            ),
          ),
          Expanded(
              child: FutureBuilder(
            future: getFacultyMembers(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data ?? [];
                var filteredList = data.where((item) => item.name.toLowerCase().contains(_search.text.toLowerCase())).toList();
                return ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onLongPress: ()async{
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: Column(
                              children: [
                                Text("Are you sure"),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CustomButton(title: "cancel", loading: false,onTap: (){
                                      Navigator.pop(context);
                                    },),
                                    CustomButton(title: "Remove",
                                      loading: isTrue,onTap: ()async {
                                        if(!isTrue){
                                          isTrue=true;
                                          setState(() {});
                                          int code=await AdminApiHandler().removeCommitteeMember(filteredList[index].id);
                                          if(context.mounted){
                                            if(code==200){
                                              Utilis.flushBarMessage("Removed", context);
                                              Navigator.pushReplacementNamed(context, RouteName.committeeRecord);
                                            }else{
                                              Utilis.flushBarMessage("error try again later", context);
                                            }
                                            isTrue=false;
                                          }
                                        }
                                      },),
                                  ],
                                )
                              ],
                            ),
                          );
                        },);
                      },
                      child: FacultyInfo(
                        isShow: false,
                          name: filteredList[index].name ?? "",
                          image: filteredList[index].profileImage ?? ""),
                    );
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ))
        ],
      ),
    );
  }
}
