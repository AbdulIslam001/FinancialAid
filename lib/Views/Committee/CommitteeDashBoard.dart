
import 'dart:convert';

import 'package:financial_aid/Components/InfoContainer.dart';
import 'package:financial_aid/Models/ApplicationModel.dart';
import 'package:financial_aid/Models/EvidenceDocument.dart';
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

class CommitteeDashBoard extends StatefulWidget {
  CommitteeDashBoard({super.key});

  @override
  State<CommitteeDashBoard> createState() => _CommitteeDashBoardState();
}

class _CommitteeDashBoardState extends State<CommitteeDashBoard> {
  final TextEditingController _search=TextEditingController();

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
    List<Application> applicationList=[];
    Response res=await CommitteeApiHandler().getAllApplications();
    if(res.statusCode==200){
      List<EvidenceDocument> evidenceList=[];
      dynamic response=jsonDecode(res.body);
      for(var obj in response){
        String ss='';
        String dc='';
        List<String> hg=[];
        for(int i =0 ; i<obj["EvidenceDocuments"].length;i++){
          if(obj["EvidenceDocuments"][i]["document_type"] !=null && obj["EvidenceDocuments"][i]["image"] !=null){
            if(obj["EvidenceDocuments"][i]["document_type"]=="salaryslip"){
              ss=obj["EvidenceDocuments"][i]["image"];
            }else if(obj["EvidenceDocuments"][i]["document_type"]=="deathcertificate"){
              dc=obj["EvidenceDocuments"][i]["image"];
            }else if(obj["EvidenceDocuments"][i]["document_type"]=="houseAgreement"){
              hg.add(obj["EvidenceDocuments"][i]["image"]);
            }
          }
          EvidenceDocument ed= EvidenceDocument(docs: obj["EvidenceDocuments"][i]["image"], type: obj["EvidenceDocuments"][i]["document_type"]);
          evidenceList.add(ed);
        }
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
          aridNo: obj["arid_no"].toString(),
          cgpa: obj["cgpa"].toString(),
          studentId: obj["student_id"].toString(),
          reason: obj["reason"].toString(),
          applicationID: obj["applicationID"].toString(),
          deathCertificate: dc,
          agreement: hg,
          salarySlip: ss,
          house: obj["house"].toString(),
          occupation: obj["jobtitle"].toString(),
          salary: obj["salary"].toString(),
          contactNo: obj["guardian_contact"].toString(),
          gContact: obj["guardian_contact"].toString(),
          gName: obj["guardian_name"].toString(),
          gRelation: obj["guardian_name"].toString(),
          applicationDate: obj["applicationDate"].toString(),
        );
        applicationList.add(a);
      }
    }
    return applicationList;
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
                    child:EndPoint.imageUrl+profileImage==EndPoint.imageUrl+"null"||EndPoint.imageUrl+profileImage==EndPoint.imageUrl?
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
              FutureBuilder(
                future: getCommitteeInfo(),
                builder: (context, snapshot) {
                return Center(child:Text(name,style: TextStyle(fontSize: CustomSize().customHeight(context)/40,fontStyle: FontStyle.italic),));
              },),
              SizedBox(
                height: CustomSize().customHeight(context)/20,
              ),
              DrawerCustomButtons(title: "switch to faculty", onTab: ()async{
                Response res=await CommitteeApiHandler().switchRole();
                if(res.statusCode==200){
                  dynamic obj=jsonDecode(res.body);
                  SharedPreferences sp=await SharedPreferences.getInstance();
                  sp.setInt('id', int.parse(obj["profileId"].toString()));
                  sp.setInt("role", int.parse(obj["role"].toString()));
                  if(context.mounted){
                    Navigator.pushReplacementNamed(context, RouteName.splashScreen);
                  }
                }
              }),
              SizedBox(
                height: CustomSize().customHeight(context)/50,
              ),
              DrawerCustomButtons(title: "Balance", onTab: ()async{
                Response res=await CommitteeApiHandler().getBalance();
                if(res.statusCode==200 && context.mounted){
                  showDialog(context: context, builder: (context) {
                    return AlertDialog(
                      title: Column(
                      children: [
                        Text("Remaining Balance",style: TextStyle(fontSize: CustomSize().customHeight(context)/40,fontStyle: FontStyle.italic),),
                        Text(res.body,style: TextStyle(fontSize: CustomSize().customHeight(context)/40,fontStyle: FontStyle.italic),)
                      ],
                    ),);
                  },);
                }
              }),
              SizedBox(
                height: CustomSize().customHeight(context)/2.1,
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
                child: FutureBuilder(
                  future: getAllApplication(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return Column(
                        children: [
                          Center(child: Text("Remaining Application",style: TextStyle(fontSize: CustomSize().customHeight(context)/30,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),)),
                          Center(child: Text(snapshot.data?.length.toString()??"",style: TextStyle(fontSize: CustomSize().customHeight(context)/30,fontStyle: FontStyle.italic),)),
                        ],
                      );
                    }else{
                      return const Column(
                        children: [
                          Center(
                              child: CircularProgressIndicator()
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ),
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
          Expanded(
              child: FutureBuilder(
                future: getAllApplication(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        if(snapshot.data![index].name.toLowerCase().contains(_search.text.toLowerCase()) || snapshot.data![index].aridNo.toLowerCase().contains(_search.text.toLowerCase())){}
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
                                  borderRadius: BorderRadius.circular(CustomSize().customHeight(context)/80),
                                ),
                                child: ListTile(
                                  title: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: CustomSize().customHeight(context)/8,
                                        width: CustomSize().customWidth(context)/1.12,
                                        decoration: BoxDecoration(
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
                                        child:
                                        snapshot.data![index].agreement[0].split('.')[1]=="pdf"?
                                        const Image(image: AssetImage("Assets/pdf2.png"),fit: BoxFit.fill,):
                                        snapshot.data![index].agreement[0].split('.')[1]=="docx"?
                                        const Image(image: AssetImage("Assets/docx1.png"))
                                            :
                                        EndPoint.houseAgreement+snapshot.data![index].agreement[0]
                                            !=EndPoint.houseAgreement ||
                                            EndPoint.houseAgreement+snapshot.data![index].agreement[0]
                                                !="${EndPoint.houseAgreement}/null"?
                                        Image(
                                            height: CustomSize().customHeight(context)/4.5,
                                            width: CustomSize().customWidth(context)/1.13,
                                            image: NetworkImage(EndPoint.houseAgreement+snapshot.data![index].agreement[0]),
                                            fit: BoxFit.fill):
                                        const Image(image: AssetImage("Assets/c1.png")),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left:CustomSize().customHeight(context)/80 ),
                                        child:Text(snapshot.data?[index].name??"",style: TextStyle(fontSize: CustomSize().customHeight(context)/50,fontStyle: FontStyle.italic),),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left:CustomSize().customHeight(context)/80),
                                        child:Text(snapshot.data?[index].aridNo??"",style: TextStyle(fontSize: CustomSize().customHeight(context)/50,fontStyle: FontStyle.italic),),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },);
                  }else{
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )),
        ],
      ),
    );
  }
}