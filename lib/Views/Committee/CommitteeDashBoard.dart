
import 'dart:convert';

import 'package:financial_aid/Components/InfoContainer.dart';
import 'package:financial_aid/Models/ApplicationModel.dart';
import 'package:financial_aid/Services/Committee/CommitteeApiHandler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Components/ApplicationView.dart';
import '../../Components/DrawerCustomButtons.dart';
import '../../Resources/AppUrl.dart';
import '../../Resources/CustomSize.dart';
import '../../Utilis/Routes/RouteName.dart';
import 'ApplicationDetails.dart';

class CommitteeDashBoard extends StatelessWidget {
  CommitteeDashBoard({super.key});
  final TextEditingController _search=TextEditingController();
/*  List<App> list=[
    App(name: "Abdul Islam", aridNumber: "2020-Arid-3677"),
    App(name: "Usman Akbar", aridNumber: "2020-Arid-3610"),
    App(name: "Amir Shahzad", aridNumber: "2020-Arid-3699"),
    App(name: "Muhammad Bashir", aridNumber: "2020-Arid-3671"),
    App(name: "Danial Hassan", aridNumber: "2020-Arid-3672"),
    App(name: "Saad Ali", aridNumber: "2020-Arid-3237"),
    App(name: "Raja Inam ullah", aridNumber: "2020-Arid-3777"),
  ];*/
  String name="";
  String profileImage="";
  Future<void> getCommitteeInfo()async{
    Response res= await CommitteeApiHandler().committeeMemberInfo();
    if(res.statusCode==200){
      dynamic obj=jsonDecode(res.body);
      name=obj["name"].toString();
      profileImage=obj["profilePic"].toString();
    }
  }

Future<List<Application>> getAllApplication()async{
    List<Application> list=[];
    Response res=await CommitteeApiHandler().getAllApplications();
    if(res.statusCode==200){
      dynamic response=jsonDecode(res.body);
      for(var obj in response){
        Application a = Application(
          profileImage: obj["profile_image"].toString(),
          name: obj["name"].toString(),
          status: obj["father_status"].toString(),
          semester: obj["semester"].toString(),
          degree: obj["degree"].toString(),
          fatherName: obj["father_name"].toString(),
          section: obj["section"].toString(),
          amount: obj["requiredAmount"].toString(),
          gender: obj["gender"].toString(),
          aridNo: obj["profile_image"].toString(),
          cgpa: obj["cgpa"].toString(),
          studentId: obj["student_id"].toString(),
          reason: obj["reason"].toString(),
          agreement: obj["EvidenceDocuments"]["document_type"]=="houseAgreement"?obj["EvidenceDocuments"]["image"]:"",
          house: obj["house"].toString(),
          occupation: obj["jobtitle"].toString(),
          deathCertificate: obj["EvidenceDocuments"]["document_type"]=="deathcertificate"?obj["EvidenceDocuments"]["image"]:"",
          salarySlip:obj["EvidenceDocuments"]["document_type"]=="salaryslip"?obj["EvidenceDocuments"]["image"]:"",
          salary: obj["salary"].toString(),
          contactNo: obj["guardian_contact"].toString(),
          gContact: obj["guardian_contact"].toString(),
          gName: obj["guardian_name"].toString(),
          gRelation: obj["house"].toString(),
          applicationDate: obj["applicationDate"].toString(),
        );
        list.add(a);
      }
    }
    return list;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text("Committee Member"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer:Drawer(
        width: CustomSize().customWidth(context) / 1.7,
        child: ListTile(
          title: Padding(
            padding:
            EdgeInsets.only(top: CustomSize().customWidth(context) / 10),
            child: GestureDetector(
              onTap: (){},
              child: FutureBuilder(
                future: getCommitteeInfo(),builder: (context, snapshot) {
                return CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: CustomSize().customHeight(context) / 13,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        CustomSize().customHeight(context) / 13),
                    child:EndPoint.imageUrl+profileImage=="http://192.168.100.11/FinancialAidAllocation/Content/profileImages/null"||EndPoint.imageUrl+profileImage=="http://192.168.100.11/FinancialAidAllocation/Content/profileImages/"?
                    Icon(Icons.person,size: CustomSize().customHeight(context)/10,):Image(
                      image: NetworkImage(EndPoint.imageUrl + profileImage),
                      width: CustomSize().customHeight(context) / 6,
                      height: CustomSize().customHeight(context) / 6,
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              },),
            ),
          ),
          subtitle: Column(
            children: [
              SizedBox(
                height: CustomSize().customHeight(context)/1.4,
              ),
              DrawerCustomButtons(title: "Logout", onTab: () async{
                SharedPreferences sp = await SharedPreferences.getInstance();
                sp.clear();
                if(context.mounted){
                  Navigator.pushReplacementNamed(context, RouteName.login);
                }
              }),
            ],
          ),
        ),
      ),
      body:Column(
        children: [
          Padding(
            padding: EdgeInsets.only( top: CustomSize().customHeight(context)/45),
            child: Center(
              child: Container(
                height: CustomSize().customHeight(context)/8,
                width: CustomSize().customWidth(context)/1.13,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(CustomSize().customHeight(context)/80),
                  color: Colors.blueGrey.withOpacity(0.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      spreadRadius: CustomSize().customHeight(context)/1000,
                      blurRadius: CustomSize().customHeight(context)/100,
                      offset: Offset(CustomSize().customHeight(context)/1400,
                          CustomSize().customHeight(context)/1400),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Center(child: Text("Remaining Application",style: TextStyle(fontSize: CustomSize().customHeight(context)/30,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),)),
                    Center(child: Text(10.toString(),style: TextStyle(fontSize: CustomSize().customHeight(context)/30,fontStyle: FontStyle.italic),)),
                  ],
                ),
              ),
            ),
          ),
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
              child: FutureBuilder(
                future: getAllApplication(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(CustomSize().customHeight(context)/80),
                        child: Center(
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return ApplicationDetails(application: snapshot.data![index],);
                              },));
                            },
                            child: Container(
                              height: CustomSize().customHeight(context)/4.5,
                              width: CustomSize().customWidth(context)/1.13,
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(CustomSize().customHeight(context)/80),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: CustomSize().customHeight(context)/8,
                                    width: CustomSize().customWidth(context)/1.12,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(CustomSize().customHeight(context)/80),
                                    ),
                                    child:const Image(image: AssetImage("Assets/c1.png"),fit: BoxFit.contain),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left:CustomSize().customHeight(context)/80,top:CustomSize().customHeight(context)/80 ),
                                    child:Text(snapshot.data?[index].name??"",style: TextStyle(fontSize: CustomSize().customHeight(context)/50,fontStyle: FontStyle.italic),),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left:CustomSize().customHeight(context)/80,top:CustomSize().customHeight(context)/80 ),
                                    child:Text(snapshot.data?[index].aridNo??"",style: TextStyle(fontSize: CustomSize().customHeight(context)/50,fontStyle: FontStyle.italic),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },);
                },
              )),
        ],
      ),
    );
  }
}
