




import 'dart:convert';

import 'package:financial_aid/Services/Admin/AdminApiHandler.dart';
import 'package:financial_aid/Utilis/Routes/RouteName.dart';
import 'package:financial_aid/Views/CommitteeHead/NeedBase/NeedBaseApplicationDetail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../Models/ApplicationModel.dart';
import '../../../Models/EvidenceDocument.dart';
import '../../../Resources/AppUrl.dart';
import '../../../Resources/CustomSize.dart';
import '../../../Services/Committee/CommitteeApiHandler.dart';

class RejectApplication extends StatefulWidget {
  RejectApplication({super.key});

  @override
  State<RejectApplication> createState() => _RejectApplicationState();
}

class _RejectApplicationState extends State<RejectApplication> {
  final TextEditingController _search=TextEditingController();

  Future<List<Application>> getAllApplication()async{
    List<Application> applicationList=[];
    Response res=await AdminApiHandler().rejectedApplication();
    if(res.statusCode==200){
      String ss='';
      String dc='';
      String hg='';
      dynamic response=jsonDecode(res.body);
      for(var obj in response){
        for(int i =0 ; i<obj["re"]["EvidenceDocuments"].length;i++){
          if(obj["re"]["EvidenceDocuments"][i]["document_type"] !=null && obj["re"]["EvidenceDocuments"][i]["image"] !=null){
            if(obj["re"]["EvidenceDocuments"][i]["document_type"]=="salaryslip"){
              ss=obj["re"]["EvidenceDocuments"][i]["image"];
            }else if(obj["re"]["EvidenceDocuments"][i]["document_type"]=="deathcertificate"){
              dc=obj["re"]["EvidenceDocuments"][i]["image"];
            }else if(obj["re"]["EvidenceDocuments"][i]["document_type"]=="houseAgreement"){
              hg=obj["re"]["EvidenceDocuments"][i]["image"];
            }
          }
/*          EvidenceDocument ed= EvidenceDocument(docs: obj["re"]["EvidenceDocuments"][i]["image"], type: obj["re"]["EvidenceDocuments"][i]["document_type"]);
          evidenceList.add(ed);*/
        }
        List<String> suggestionList=[];
        for(int j=0;j<obj["re"]["suggestion"].length;j++){
          suggestionList.add(obj["re"]["suggestion"][j]["comment"].toString());
        }
        Application a = Application(
            profileImage: obj["re"]["profile_image"].toString(),
            name: obj["re"]["name"].toString(),
            status: obj["re"]["father_status"].toString(),
            semester: obj["re"]["semester"].toString(),
            degree: obj["re"]["degree"].toString(),
            fatherName: obj["re"]["father_name"].toString(),
            section: obj["re"]["section"].toString(),
            amount: obj["re"]["requiredAmount"].toString(),
            gender: obj["re"]["gender"].toString(),
            aridNo: obj["re"]["arid_no"].toString(),
            cgpa: obj["re"]["cgpa"].toString(),
            studentId: obj["re"]["student_id"].toString(),
            reason: obj["re"]["reason"].toString(),
            applicationID: obj["re"]["applicationID"].toString(),
            deathCertificate: dc,
            agreement: hg,
            salarySlip: ss,
            house: obj["re"]["house"].toString(),
            occupation: obj["re"]["jobtitle"].toString(),
            salary: obj["re"]["salary"].toString(),
            contactNo: obj["re"]["guardian_contact"].toString(),
            gContact: obj["re"]["guardian_contact"].toString(),
            gName: obj["re"]["guardian_name"].toString(),
            gRelation: obj["re"]["guardian_name"].toString(),
            applicationDate: obj["re"]["applicationDate"].toString(),
            suggestion: suggestionList
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
        title:const Text("Rejected Application"),
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
                        Center(child: Text("Total Rejected",style: TextStyle(fontSize: CustomSize().customHeight(context)/30,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),)),
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
                      itemCount: snapshot.data?.where((item) {
                        return item.applicationStatus?.toString()=='Rejected';
                      }).length??0,
                      itemBuilder: (context, index) {
                        if(snapshot.data![index].aridNo.toLowerCase().contains(_search.text.toLowerCase()) || snapshot.data![index].name.toLowerCase().contains(_search.text.toLowerCase())){
                          if(snapshot.data![index].applicationStatus?.toString()=='Rejected'){
                            return Padding(
                              padding: EdgeInsets.all(CustomSize().customHeight(context)/80),
                              child: Center(
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return NeedBaseApplicationDetails(application: snapshot.data![index],isTrue: true,);
                                    },));
                                  },
                                  child: ListTile(
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
                                            child:
                                            snapshot.data![index].agreement.split('.')[1]=="pdf"?
                                            const Image(image: AssetImage("Assets/pdf2.png"),fit: BoxFit.fill,):
                                            snapshot.data![index].agreement.split('.')[1]=="docx"?
                                            const Image(image: AssetImage("Assets/docx1.png"))
                                                :
                                            EndPoint.houseAgreement+snapshot.data![index].agreement
                                                !=EndPoint.houseAgreement ||
                                                EndPoint.houseAgreement+snapshot.data![index].agreement
                                                    !="${EndPoint.houseAgreement}/null"?
                                            Image(
                                                height: CustomSize().customHeight(context)/4.5,
                                                width: CustomSize().customWidth(context)/1.13,
                                                image: NetworkImage(EndPoint.houseAgreement+snapshot.data![index].agreement??""),
                                                fit: BoxFit.fill):
                                            const Image(image: AssetImage("Assets/c1.png")),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left:CustomSize().customHeight(context)/80),
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
                          }
                        }
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
