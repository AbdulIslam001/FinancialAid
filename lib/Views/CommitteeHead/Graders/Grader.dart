import 'dart:convert';

import 'package:financial_aid/Components/CustomButton.dart';
import 'package:financial_aid/Models/ApplicationModel.dart';
import 'package:financial_aid/Models/FacultyModel.dart';
import 'package:financial_aid/Models/Student.dart';
import 'package:financial_aid/Services/Admin/AdminApiHandler.dart';
import 'package:financial_aid/Utilis/FlushBar.dart';
import 'package:financial_aid/Utilis/Routes/RouteName.dart';
import 'package:financial_aid/Views/CommitteeHead/Add/Faculty/FacultyRecord.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../Components/FacultyInfo.dart';
import '../../../Resources/AppUrl.dart';
import '../../../Resources/CustomColor.dart';
import '../../../Resources/CustomSize.dart';

class Graders extends StatefulWidget {
  const Graders({super.key});

  @override
  State<Graders> createState() => _GradersState();
}

class _GradersState extends State<Graders> {
  Future<List<FacultyModel>> getFacultyMembers() async {
    List<FacultyModel> fList = [];
    Response res = await AdminApiHandler().getAllFaculty();
    if (res.statusCode == 200) {
      dynamic obj = jsonDecode(res.body);
      FacultyModel f;
      for (var i in obj) {
        f = FacultyModel(
            name: i["name"],
            profileImage: i["profilePic"],
            id: i["facultyId"],
            contact: i["contactNo"]);
        fList.add(f);
      }
    }
    return fList;
  }

  List<Student> _list = [];
  Future<List<Student>> unAssignedGraders() async {
    List<Student> list = [];
    Response res = await AdminApiHandler().getUnAssignedStudent();
    if (res.statusCode == 200) {
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
            profileImage: i["profile_image"].toString());
        list.add(s);
        _list.add(s);
      }
    }
    return list;
  }

  @override
  final TextEditingController _search = TextEditingController();
  final TextEditingController _search1 = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Graders"),
        centerTitle: true,
        leading:GestureDetector(
            onTap: (){
              Navigator.pushReplacementNamed(context, RouteName.committeeHeadDashBoard);
            },
            child:const Icon(Icons.arrow_back_ios_new)),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: CustomSize().customWidth(context) / 20,
                right: CustomSize().customWidth(context) / 20,
                top: CustomSize().customWidth(context) / 30),
            child: TextFormField(
              onChanged: (val) {
                setState(() {});
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
              future: unAssignedGraders(),
              builder: (context, snapshot) {
//                List<Student> filteredList = [];
                if (snapshot.hasData) {
                  var data = snapshot.data ?? [];
                  var filteredList = data.where((item) => item.name.toLowerCase().contains(_search.text.toLowerCase())).toList();
                  return ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
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
                        trailing: GestureDetector(
                          onTap: () async{
                            List<FacultyModel> list=[];
                            Response res=await AdminApiHandler().getAllFaculty();
                            if(res.statusCode==200 && context.mounted){
                              dynamic obj=jsonDecode(res.body);
                              FacultyModel f;
                              for(var i in obj){
                                f =FacultyModel(name: i["name"], profileImage: i["profilePic"],id: i["facultyId"],contact: i["contactNo"]);
                                list.add(f);
                              }
                              showDialog(
                                context: context, builder: (context) {
                                return SingleChildScrollView(
                                  child: AlertDialog(
                                    title: Column(
                                      children: [
                                        Row(
                                          children: [
                                            GestureDetector(
                                                onTap:(){
                                                  Navigator.pop(context);
                                                },
                                                child:const Icon(Icons.arrow_back_ios_new))
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left:CustomSize().customWidth(context)/20,right: CustomSize().customWidth(context)/20,top: CustomSize().customWidth(context)/30),
                                          child: TextFormField(
                                            onChanged: (val){
                                            },
                                            controller: _search1,
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
                                        SizedBox(
                                          height: CustomSize().customHeight(context)/2.5,
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child:  ListView.builder(
                                                  itemCount: list.length,
                                                  itemBuilder: (context, index1) {
                                                    if(snapshot.data![index].name.toLowerCase().contains(_search.text.toLowerCase())){
                                                      return GestureDetector(
                                                          onTap: ()async{
                                                            int code=await AdminApiHandler().assignGrader(snapshot.data![index].studentId, list[index1].id);
                                                            if(context.mounted){
                                                              if(code==200 ){
                                                                Navigator.pop(context);
                                                              }else{
                                                                Utilis.flushBarMessage("error try again", context);
                                                              }
                                                            }
                                                          },
                                                          child: FacultyInfo(name: list[index1].name, image: list[index1].profileImage));
                                                    }
                                                  },),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },);
                            }
/*                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return FacultyRecord(name: snapshot.data![index].name,isShow: true,studentId:snapshot.data![index].studentId.toString(),);
                            },));*/
                          },
                          child: Container(
                            height: CustomSize().customHeight(context) / 20,
                            width: CustomSize().customWidth(context) / 6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  CustomSize().customHeight(context) / 90),
                              color: CustomColor().customButtonColor(),
                            ),
                            child: Center(
                              child: Text("Assign",
                                  style: TextStyle(
                                    color: CustomColor().customWhiteColor(),
                                    fontSize:
                                        CustomSize().customHeight(context) / 50,
                                  )),
                            ),
                          ),
                        ),
                      );
                    },
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
            ),
          )
        ],
      ),
    );
  }
}

/*


Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(CustomSize().customWidth(context)/40),
                              border: Border.all()
                          ),
                          height: CustomSize().customHeight(context)/8,
                          width: CustomSize().customWidth(context)/1.3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(CustomSize().customWidth(context)/20),
                                child: Column(
                                  children: [
                                    Text(snapshot.data![index].name.split(" ").length>2?"${snapshot.data![index].name.split(" ")[0]} ${snapshot.data![index].name.split(" ")[1]}":snapshot.data![index].name),
                                    Text(snapshot.data![index].aridNo),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: CustomSize().customWidth(context)/20),
                                child: GestureDetector(
                                  onTap: (){},
                                  child: Container(
                                    height: CustomSize().customHeight(context)/ 20,
                                    width: CustomSize().customWidth(context)/6,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(CustomSize().customHeight(context)/90),
                                      color: CustomColor().customButtonColor(),
                                    ),
                                    child: Center(
                                      child:Text("Assign",style: TextStyle(color: CustomColor().customWhiteColor(),fontSize: CustomSize().customHeight(context)/50,)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )

 */
