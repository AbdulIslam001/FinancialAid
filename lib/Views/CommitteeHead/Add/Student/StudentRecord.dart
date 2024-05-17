
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
  List<Student> studentList;
  StudentRecord({super.key,required this.studentList});

  @override
  State<StudentRecord> createState() => _StudentRecordState();
}

class _StudentRecordState extends State<StudentRecord> {
  final TextEditingController _search=TextEditingController();

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
            child: ListView.builder(
              itemCount: widget.studentList.length,
              itemBuilder: (context, index) {
                if(widget.studentList[index].name.toLowerCase().contains(_search.text.toLowerCase()) || widget.studentList[index].aridNo.toLowerCase().contains(_search.text.toLowerCase())){
                  return Padding(
                    padding: EdgeInsets.only(left:CustomSize().customWidth(context)/40,right: CustomSize().customWidth(context)/40,top: CustomSize().customWidth(context)/100,bottom: CustomSize().customWidth(context)/100),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return UpdatePassword(id: widget.studentList[index].studentId,aridNo: widget.studentList[index].aridNo, name: widget.studentList[index].name);
                        },));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(CustomSize().customWidth(context)/20),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: CustomSize().customHeight(context) / 30,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  CustomSize().customHeight(context) / 30),
                              child:EndPoint.imageUrl+widget.studentList[index].profileImage==EndPoint.imageUrl+"null"||EndPoint.imageUrl+widget.studentList[index].profileImage==EndPoint.imageUrl?(
                                  widget.studentList[index].gender=='M'?Image.asset("Assets/male.png"):Image.asset("Assets/female.png"))
                                  :Image(
                                image: NetworkImage(EndPoint.imageUrl + widget.studentList[index].profileImage),
                                width: CustomSize().customHeight(context) / 12,//CustomSize().customHeight(context)/15
                                height: CustomSize().customHeight(context) / 12,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          title: Text(widget.studentList[index].name),
                          subtitle: Text(widget.studentList[index].aridNo),

                        ),
                      ),
                    ),
                  );
                }
              },),
          )
        ],
      ),
    );
  }
}
