
import 'dart:convert';

import 'package:financial_aid/Components/FacultyInfo.dart';
import 'package:financial_aid/Models/FacultyModel.dart';
import 'package:financial_aid/Services/Admin/AdminApiHandler.dart';
import 'package:financial_aid/Utilis/FlushBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../../Components/CustomButton.dart';
import '../../../../Models/GraderModel.dart';
import '../../../../Resources/AppUrl.dart';
import '../../../../Resources/CustomSize.dart';
import '../../../../Services/Faculty/FacultyAPiHandler.dart';
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
                    var data = snapshot.data ?? [];
                    var filteredList = data.where((item) => item.name.toLowerCase().contains(_search.text.toLowerCase())).toList();
                    return ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap:()async{
                              List<GraderModel> list = [];
                              Response res = await FacultyApiHandler().graderInformation(filteredList[index].id);
                              if(context.mounted){
                                if (res.statusCode == 200) {
                                  dynamic obj = jsonDecode(res.body);
                                  for (var i in obj) {
                                    GraderModel g = GraderModel(
                                        aridNo: i['arid_no'].toString(),
                                        name: i['name'].toString(),
                                        studentId: i['studentId'].toString(),
                                        facultyId: i['facultyId'].toString(),
                                        gender: i['gender'].toString(),
                                        profileImage: i['profile_image'].toString());
                                    list.add(g);
                                  }
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        scrollable: true,
                                        title: Column(
                                          children: [
                                            SizedBox(
                                              width: double.maxFinite,
                                              height: CustomSize().customHeight(context)/2.5,
                                              child: Column(
                                                children: [
                                                  StatefulBuilder(builder: (context, setState) {
                                                    return Expanded(
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount: list.length,
                                                          itemBuilder: (context, index1) {
                                                            return GestureDetector(
                                                              onLongPress: (){
                                                                showDialog(
                                                                  barrierDismissible: false,
                                                                  context: context, builder: (context) {
                                                                  return StatefulBuilder(builder: (context, setState) {
                                                                    return AlertDialog(
                                                                      title: SizedBox(
                                                                        width: double.maxFinite,
                                                                        height: CustomSize().customHeight(context)/3.5,
                                                                        child: Column(
                                                                          children: [
                                                                            Text("want to remove ${list[index1].name} grader of ${filteredList[index].name}"),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                              children: [
                                                                                CustomButton(title: "cancel", loading: false,onTap: (){
                                                                                  Navigator.pop(context);
                                                                                }),
                                                                                CustomButton(title: "yes", loading: false,onTap: ()async{
                                                                                  int status=await AdminApiHandler().removeGrader(int.parse(list[index1].studentId));
                                                                                  if(context.mounted){
                                                                                    if(status==200){
                                                                                      Navigator.pop(context);
                                                                                      Navigator.pop(context);

                                                                                    }else{
                                                                                      Utilis.flushBarMessage("error try again later", context);
                                                                                    }
                                                                                  }
                                                                                },
                                                                                ),
                                                                              ],
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );

                                                                  },);
                                                                },);
                                                              },
                                                              child: Card(
                                                                child: ListTile(
                                                                  leading: CircleAvatar(
                                                                    backgroundColor: Colors.transparent,
                                                                    radius: CustomSize().customHeight(context) / 30,
                                                                    child: ClipRRect(
                                                                      borderRadius: BorderRadius.circular(
                                                                          CustomSize().customHeight(context) / 30),
                                                                      child: EndPoint.imageUrl +
                                                                          list![index1]
                                                                              .profileImage ==
                                                                          EndPoint.imageUrl + "null" ||
                                                                          EndPoint.imageUrl +
                                                                              list![index1]
                                                                                  .profileImage ==
                                                                              EndPoint.imageUrl
                                                                          ? (list[index1].gender == 'M'
                                                                          ? Image.asset("Assets/male.png")
                                                                          : Image.asset("Assets/female.png"))
                                                                          : Image(
                                                                        image: NetworkImage(
                                                                            EndPoint.imageUrl +
                                                                                list![index1]
                                                                                    .profileImage),
                                                                        width: CustomSize()
                                                                            .customHeight(context) /
                                                                            12, //CustomSize().customHeight(context)/15
                                                                        height: CustomSize()
                                                                            .customHeight(context) /
                                                                            12,
                                                                        fit: BoxFit.fill,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  title: Text(list[index1].name),
                                                                  subtitle: Text(list[index1].aridNo),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ));
                                                  },),
                                                ],
                                              ),
                                            ),
                                            /*Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  CustomButton(title: "cancel", loading: false,onTap:(){
                                                    Navigator.pop(context);
                                                  },),
                                                  CustomButton(title: "yes", loading: false,onTap:(){},),
                                                ],
                                              )*/
                                          ],
                                        ),
                                      );
                                    },);
                                }else{
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        scrollable: true,
                                        title: Column(
                                          children: [
                                            Text(filteredList[index].name,style: TextStyle(
                                              fontSize: CustomSize().customWidth(context)/20,
                                            )),
                                            Text("Nothing to show",style: TextStyle(
                                              fontSize: CustomSize().customWidth(context)/20,
                                            )),
                                            SizedBox(
                                              height: CustomSize().customWidth(context)/20,
                                            ),
                                            CustomButton(title: "cancel", loading: false,onTap:(){
                                              Navigator.pop(context);
                                            },),
                                          ],
                                        ),
                                      );
                                    },);
                                }
                              }
                            },
                            child: FacultyInfo(
                                isShow: false,
                                name: filteredList[index].name, image: filteredList[index].profileImage));
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
