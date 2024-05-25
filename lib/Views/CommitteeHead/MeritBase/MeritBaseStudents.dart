

import 'dart:convert';

import 'package:financial_aid/Components/CustomButton.dart';
import 'package:financial_aid/Services/Admin/AdminApiHandler.dart';
import 'package:financial_aid/viewModel/CustomButtonViewModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../../Models/Student.dart';
import '../../../Resources/AppUrl.dart';
import '../../../Resources/CustomColor.dart';
import '../../../Resources/CustomSize.dart';
import '../../../Utilis/Routes/RouteName.dart';

class MeritBaseStudent extends StatefulWidget {
//  List<Student>? list;
  bool isTrue;
  MeritBaseStudent({super.key,required this.isTrue});

  @override
  State<MeritBaseStudent> createState() => _MeritBaseStudentState();
}

class _MeritBaseStudentState extends State<MeritBaseStudent> {
  Future<List<Student>> getMeritBaseShortListed()async{
    List<Student> list=[];

    Response res=await AdminApiHandler().getMeritBaseShortListed();
    if(res.statusCode==200)
    {
      dynamic obj=jsonDecode(res.body);
      for(var i in obj){
        Student s= Student(aridNo: i['arid_no'].toString(),
            name: i['name'].toString(),
            semester: int.parse(i['semester'].toString()),
            cgpa: double.parse(i['cgpa'].toString()),
            section: i['section'].toString(),
            degree: i['degree'].toString(),
            fatherName: i['position'].toString(),
            gender: i['gender'].toString(),
            studentId: int.parse(i['student_id'].toString()),
            profileImage: i['profile_image'].toString());
        list.add(s);
      }
    }
    return list;
  }

  final TextEditingController _search=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading:GestureDetector(
            onTap: (){
              Navigator.pushReplacementNamed(context, RouteName.committeeHeadDashBoard);
            },
            child: const Icon(Icons.arrow_back)),
        title:const Text("MeritBase ShortListing"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: !widget.isTrue?Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Consumer<CustomButtonViewModel>(
              builder: (context, value, child) {
              return CustomButton(title: "Short List",loading: value.loading,onTap: ()async{
                value.setLoading(true);
                Response response=await AdminApiHandler().doMeritBaseShortListing();
                if(response.statusCode==200)
                {
                  /*List<Student>list=[];
                  dynamic obj=jsonDecode(response.body);
                  for(var i in obj){
                    Student s= Student(aridNo: i['arid_no'].toString(),
                        name: i['name'].toString(),
                        semester: int.parse(i['semester'].toString()),
                        cgpa: double.parse(i['cgpa'].toString()),
                        section: i['section'].toString(),
                        degree: i['degree'].toString(),
                        gender: i['gender'].toString(),
                        studentId: int.parse(i['student_id'].toString()),
                        profileImage: i['profile_image'].toString(),
                        fatherName: 'gender');
                    list.add(s);
                  }
                  if(context.mounted){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                      return MeritBaseStudent(isTrue: true,);//list: list,);
                    },));
                  }*/
                  widget.isTrue=true;
                  setState(() {});
                }
                value.setLoading(false);
              });
            },),
          )
        ],
      ):Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left:CustomSize().customWidth(context)/20,right: CustomSize().customWidth(context)/20,top: CustomSize().customWidth(context)/30),
            child: TextFormField(
              onChanged: (val){
                setState(() {});
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
          FutureBuilder(
            future: getMeritBaseShortListed(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                var data = snapshot.data ?? [];
                var filteredList = data.where((item) => item.name.toLowerCase().contains(_search.text.toLowerCase())).toList();
                return Expanded(
                    child: ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){},
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: CustomSize().customHeight(context) / 30,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      CustomSize().customHeight(context) / 30),
                                  child: EndPoint.imageUrl +
                                      filteredList[index].profileImage ==
                                      "${EndPoint.imageUrl}null" ||
                                      EndPoint.imageUrl +
                                          filteredList[index].profileImage ==
                                          EndPoint.imageUrl
                                      ? (filteredList[index].gender == 'M'
                                      ? Image.asset("Assets/male.png")
                                      : Image.asset("Assets/female.png"))
                                      : Image(
                                    image: NetworkImage(EndPoint.imageUrl +
                                        filteredList[index].profileImage),
                                    width: CustomSize().customHeight(context) /
                                        12, //CustomSize().customHeight(context)/15
                                    height:
                                    CustomSize().customHeight(context) / 12,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              title: Text(filteredList[index].name),
                              subtitle: Text(filteredList[index].aridNo),

                            ),
                          );
                        }
                    ),
                    /*FutureBuilder(
              future: getMeritBaseShortListed(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        if(snapshot.data![index].aridNo.toLowerCase().contains(_search.text.toLowerCase()) || snapshot.data![index].name.toLowerCase().contains(_search.text.toLowerCase()) ){
                          return GestureDetector(
                            onTap: (){},
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: CustomSize().customHeight(context) / 30,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      CustomSize().customHeight(context) / 30),
                                  child: EndPoint.imageUrl +
                                      snapshot
                                          .data![index].profileImage ==
                                      "${EndPoint.imageUrl}null" ||
                                      EndPoint.imageUrl +
                                          snapshot
                                              .data![index].profileImage ==
                                          EndPoint.imageUrl
                                      ? (snapshot.data![index].gender == 'M'
                                      ? Image.asset("Assets/male.png")
                                      : Image.asset("Assets/female.png"))
                                      : Image(
                                    image: NetworkImage(EndPoint.imageUrl +
                                        snapshot.data![index].profileImage),
                                    width: CustomSize().customHeight(context) /
                                        12, //CustomSize().customHeight(context)/15
                                    height:
                                    CustomSize().customHeight(context) / 12,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              title: Text(snapshot.data?[index].name??""),
                              subtitle: Text(snapshot.data?[index].aridNo??""),
                              */

                  );
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
          },),
        ],
      ),
    );
  }
}

/*trailing: SizedBox(
                            height: CustomSize().customHeight(context) / 20,
                            width: CustomSize().customWidth(context) / 6,
                            child: Center(
                              child: Row(
                                children: [
                                  GestureDetector(child: Icon(Icons.check,color: Colors.green,size: CustomSize().customWidth(context) / 15,)),
                                  SizedBox(
                                    width: CustomSize().customWidth(context) / 30,
                                  ),
                                  GestureDetector(child: Icon(Icons.close,color: Colors.red,size: CustomSize().customWidth(context) / 15,))
                                ],
                              )
                            ),
                          ),*/
/*
                            ),
                          );
                        }
                      }
                  );
                } else {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: CircularProgressIndicator()),
                    ],
                  );
                }
              },
            ),*/

/*trailing: SizedBox(
                            height: CustomSize().customHeight(context) / 20,
                            width: CustomSize().customWidth(context) / 6,
                            child: Center(
                              child: Row(
                                children: [
                                  GestureDetector(child: Icon(Icons.check,color: Colors.green,size: CustomSize().customWidth(context) / 15,)),
                                  SizedBox(
                                    width: CustomSize().customWidth(context) / 30,
                                  ),
                                  GestureDetector(child: Icon(Icons.close,color: Colors.red,size: CustomSize().customWidth(context) / 15,))
                                ],
                              )
                            ),
                          ),*/