

import 'dart:convert';

import 'package:financial_aid/Services/Admin/AdminApiHandler.dart';
import 'package:financial_aid/Utilis/Routes/RouteName.dart';
import 'package:financial_aid/Views/CommitteeHead/NeedBase/NeedBaseApplicationDetail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

import '../../../Models/ApplicationModel.dart';
import '../../../Models/EvidenceDocument.dart';
import '../../../Resources/AppUrl.dart';
import '../../../Resources/CustomSize.dart';
import '../../../Services/Committee/CommitteeApiHandler.dart';
import '../../Committee/ApplicationDetails.dart';

class NeedBaseApplications extends StatefulWidget {
  NeedBaseApplications({super.key});

  @override
  State<NeedBaseApplications> createState() => _NeedBaseApplicationsState();
}

class _NeedBaseApplicationsState extends State<NeedBaseApplications> {
  final TextEditingController _search=TextEditingController();

  Future<List<Application>> getAllApplication()async{
    List<Application> applicationList=[];
    Response res=await AdminApiHandler().getApplications();
    if(res.statusCode==200){
//      List<EvidenceDocument> evidenceList=[];
      dynamic response=jsonDecode(res.body);
      for(var obj in response){
        String ss='';
        String dc='';
        List<String> hg=[];
        for(int i =0 ; i<obj["EvidenceDocuments"].length;i++){
          if(obj["EvidenceDocuments"][i]["document_type"] !=null && obj["EvidenceDocuments"][i]["image"] !=null){
            if(obj["EvidenceDocuments"][i]["document_type"]=="salaryslip"){
              ss=obj["EvidenceDocuments"][i]["image"].toString();
            }else if(obj["EvidenceDocuments"][i]["document_type"]=="deathcertificate"){
              dc=obj["EvidenceDocuments"][i]["image"].toString();
            }else if(obj["EvidenceDocuments"][i]["document_type"]=="houseAgreement"){
              hg.add(obj["EvidenceDocuments"][i]["image"].toString());
            }
          }
/*          EvidenceDocument ed= EvidenceDocument(docs: obj["re"]["EvidenceDocuments"][i]["image"], type: obj["re"]["EvidenceDocuments"][i]["document_type"]);
          evidenceList.add(ed);*/
        }
        List<String>? isApplication=[];
        List<String>? committeeMemberName=[];
        List<String> suggestionList=[];
        List<String> suggestedAmount=[];
        for(int j=0;j<obj["Suggestions"].length;j++){
          suggestionList.add(obj["Suggestions"][j]["comment"].toString());
          committeeMemberName.add(obj["Suggestions"][j]["CommitteeMemberName"].toString());
          isApplication.add(obj["Suggestions"][j]["status"].toString());
          suggestedAmount.add(obj["Suggestions"][j]["amount"].toString());
        }
        Application a = Application(
         // applicationStatus: obj[""].toString(),
          isApplication: isApplication,
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
          suggestion: suggestionList,
          committeeMemberName: committeeMemberName,
          suggestedAmount: suggestedAmount,
        );
        applicationList.add(a);
      }
    }
    return applicationList;
  }

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
        title:const Text("Needbase Application"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
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
                    return Column(
                      children: [
                        Center(child: Text("Remaining Application",style: TextStyle(fontSize: CustomSize().customHeight(context)/30,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),)),
                        Center(child: Text(snapshot.data?.length.toString()??"",style: TextStyle(fontSize: CustomSize().customHeight(context)/30,fontStyle: FontStyle.italic),)),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
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
              child: FutureBuilder(
                future: getAllApplication(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    var data = snapshot.data ?? [];
                    var filteredList = data.where((item) => item.name.toLowerCase().contains(_search.text.toLowerCase())).toList();
                    return ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(CustomSize().customHeight(context)/80),
                          child: Center(
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return NeedBaseApplicationDetails(application: filteredList[index],isTrue: false,trackRecord: true,);
                                },));
                              },
                              child:ListTile(
                                title: Container(
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
                                  child: Column(
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
                                        child: filteredList[index].agreement[0].split('.')[1]=="pdf"?
                                        const Image(image: AssetImage("Assets/pdf2.png"),fit: BoxFit.fill,):
                                        filteredList[index].agreement[0].split('.')[1]=="docx"?
                                        const Image(image: AssetImage("Assets/docx1.png"))
                                            : EndPoint.houseAgreement+filteredList[index].agreement[0]
                                            !=EndPoint.houseAgreement ||
                                            EndPoint.houseAgreement+filteredList[index].agreement[0]
                                                !="${EndPoint.houseAgreement}/null"?
                                        Image(
                                            height: CustomSize().customHeight(context)/4.5,
                                            width: CustomSize().customWidth(context)/1.13,
                                            image: NetworkImage(EndPoint.houseAgreement+filteredList[index].agreement[0]),
                                            fit: BoxFit.fill):
                                        const Image(image: AssetImage("Assets/c1.png")),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left:CustomSize().customHeight(context)/80),
                                        child:Text(filteredList[index].name??"",style: TextStyle(fontSize: CustomSize().customHeight(context)/50,fontStyle: FontStyle.italic),),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left:CustomSize().customHeight(context)/80),
                                        child:Text(filteredList[index].aridNo??"",style: TextStyle(fontSize: CustomSize().customHeight(context)/50,fontStyle: FontStyle.italic),),
                                      ),
                                    ],
                                  ),
                                ),
                              ) ,
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
