
import 'dart:convert';

import 'package:financial_aid/Models/Student.dart';
import 'package:financial_aid/Resources/CustomSize.dart';
import 'package:financial_aid/Services/Admin/AdminApiHandler.dart';
import 'package:financial_aid/Utilis/Routes/RouteName.dart';
import 'package:financial_aid/Views/CommitteeHead/Add/Student/UpdatePassword.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../../../Resources/AppUrl.dart';


class StudentRecord extends StatefulWidget {
//  List<Student> studentList;
  StudentRecord({super.key});

  @override
  State<StudentRecord> createState() => _StudentRecordState();
}

class _StudentRecordState extends State<StudentRecord> {
  final TextEditingController _search=TextEditingController();

  Future<List<Student>> getAllStudent()async{
    Response res = await AdminApiHandler().getAllStudent();
    List<Student> studentList = [];
    if (res.statusCode == 200 && context.mounted) {
      dynamic obj = jsonDecode(res.body);
      for (var i in obj) {
        Student s = Student(
          aridNo: i["arid_no"].toString(),
          name: i["name"].toString(),
          semester: int.parse(i["semester"].toString()),
          cgpa: double.parse(i["cgpa"].toString()),
          section: i["section"].toString(),
          degree: i["degree"].toString(),
          fatherName: i["father_name"].toString(),
          gender: i["gender"].toString(),
          studentId: int.parse(i["student_id"].toString()),
          profileImage: i["profile_image"].toString(),
        );
        studentList.add(s);
      }
    }
    return studentList;
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
                  Navigator.pushNamed(context, RouteName.addStudent);
                },
                child: const Icon(Icons.add_box_rounded)),
          )
        ],
        title:const Text("Student Record"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(CustomSize().customWidth(context)/20),
            child: TextFormField(
              onChanged: (val){
                setState((){});
              },
              controller: _search,
              decoration: InputDecoration(
                suffixIcon:const Icon(Icons.search),
                labelText: "search",
                hintText: "search",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(CustomSize().customWidth(context)/20)
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: getAllStudent(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    var data = snapshot.data ?? [];
                    var filteredList = data.where((item) => item.name.toLowerCase().contains(_search.text.toLowerCase())).toList();
                    return ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(left:CustomSize().customWidth(context)/40,right: CustomSize().customWidth(context)/40,top: CustomSize().customWidth(context)/100,bottom: CustomSize().customWidth(context)/100),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return UpdatePassword(id: filteredList[index].studentId,aridNo: filteredList[index].aridNo, name: filteredList[index].name);
                              },));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color:filteredList[index].semester>8 || filteredList[index].cgpa<2.0?Colors.red:Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(CustomSize().customWidth(context)/20),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: CustomSize().customHeight(context) / 30,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        CustomSize().customHeight(context) / 30),
                                    child:EndPoint.imageUrl+filteredList[index].profileImage==
                                        EndPoint.imageUrl+"null"||EndPoint.imageUrl+filteredList[index].profileImage==EndPoint.imageUrl?(
                                        filteredList[index].gender=='M'?Image.asset("Assets/male.png"):Image.asset("Assets/female.png"))
                                        :Image(
                                      image: NetworkImage(EndPoint.imageUrl + filteredList[index].profileImage),
                                      width: CustomSize().customHeight(context) / 12,//CustomSize().customHeight(context)/15
                                      height: CustomSize().customHeight(context) / 12,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                title: Text(filteredList[index].name),
                                subtitle: Text(filteredList[index].aridNo),

                              ),
                            ),
                          ),
                        );
                      },);
                  }else{
                    return const Column(
                      children: [
                        Center(
                          child: CircularProgressIndicator(),
                        )
                      ],
                    );
                  }
                },
            ),
          )
        ],
      ),
    );
  }
}
