import 'package:financial_aid/Components/ApplicationView.dart';
import 'package:financial_aid/Components/CustomButton.dart';
import 'package:financial_aid/Models/ApplicationModel.dart';
import 'package:financial_aid/Resources/CustomSize.dart';
import 'package:financial_aid/Services/Admin/AdminApiHandler.dart';
import 'package:financial_aid/Utilis/FlushBar.dart';
import 'package:financial_aid/Utilis/Routes/RouteName.dart';
import 'package:financial_aid/Views/Committee/ApplicationDetails.dart';
import 'package:financial_aid/viewModel/CommitteeHeadViewModel/ApplicationView.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../../Resources/AppUrl.dart';

class NeedBaseApplicationDetails extends StatefulWidget {
  Application application;
  bool isTrue;
  NeedBaseApplicationDetails({super.key, required this.application,required this.isTrue});

  @override
  State<NeedBaseApplicationDetails> createState() =>
      _NeedBaseApplicationDetailsState();
}

final TextEditingController _reason = TextEditingController();

TextEditingController _amount= TextEditingController();

class _NeedBaseApplicationDetailsState
    extends State<NeedBaseApplicationDetails> {
  int i = 0;


  @override
  Widget build(BuildContext context) {
    _reason.text = widget.application.reason;
    List<String> docsList = [widget.application.agreement];
    if (widget.application.salarySlip != null ||
        widget.application.salarySlip != '') {
      docsList.add(widget.application.salarySlip ?? "");
    }
    if (widget.application.deathCertificate != null ||
        widget.application.deathCertificate != '') {
      docsList.add(widget.application.deathCertificate ?? "");
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(top: CustomSize().customHeight(context) / 13),
          child: Consumer<ApplicationViewModel>(
            builder: (context, value, child) {
              return Column(
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        value.setIsTrue(!value.isTrue);
                        value.setTitleText();
                      },
                      child: Container(
                        width: CustomSize().customWidth(context) / 2.5,
                        height: CustomSize().customHeight(context) / 12,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              CustomSize().customHeight(context) / 80),
                          color: Colors.blueGrey.withOpacity(0.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              spreadRadius:
                                  CustomSize().customHeight(context) / 1000,
                              blurRadius:
                                  CustomSize().customHeight(context) / 100,
                              offset: Offset(
                                  CustomSize().customHeight(context) / 1400,
                                  CustomSize().customHeight(context) / 1400),
                            ),
                          ],
                        ),
                        child: Center(child: Text(value.titleText)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: CustomSize().customHeight(context) / 50,
                  ),
                  Visibility(
                      visible: value.isTrue,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Positioned(
                                child: Container(
                                  height:
                                      CustomSize().customHeight(context) / 3.5,
                                  width: CustomSize().customWidth(context),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(
                                            CustomSize().customHeight(context) /
                                                30),
                                        bottomRight: Radius.circular(
                                            CustomSize().customHeight(context) /
                                                30)),
                                    //  border: Border.all()
                                  ),
                                  child: EndPoint.documentUrl + docsList[i] !=
                                              EndPoint.documentUrl ||
                                          EndPoint.documentUrl + docsList[i] !=
                                              EndPoint.documentUrl + "null"
                                      ? Image(
                                          height: CustomSize()
                                                  .customHeight(context) /
                                              3.5,
                                          width:
                                              CustomSize().customWidth(context),
                                          image: NetworkImage(
                                              EndPoint.documentUrl + docsList[i] ??
                                                  ""),
                                          fit: BoxFit.fill)
                                      : Image(
                                          height: CustomSize()
                                                  .customHeight(context) /
                                              3.5,
                                          width:
                                              CustomSize().customWidth(context),
                                          fit: BoxFit.fill,
                                          image: const AssetImage("Assets/c1.png")),
                                ),
                              ),
                              Positioned(
                                  right: CustomSize().customWidth(context) / 70,
                                  top: CustomSize().customWidth(context) / 4,
                                  child: GestureDetector(
                                      onTap: () {
                                        if (i! > docsList.length) {
                                          i++;
                                        }
                                        setState(() {});
                                      },
                                      child: Icon(
                                        Icons.navigate_next_outlined,
                                        size:
                                            CustomSize().customWidth(context) /
                                                7,
                                      ))),
                              Positioned(
                                  left: CustomSize().customWidth(context) / 70,
                                  top: CustomSize().customWidth(context) / 4,
                                  child: GestureDetector(
                                      onTap: () {
                                        if (i != 0) {
                                          i--;
                                        }
                                        setState(() {});
                                      },
                                      child: Icon(
                                        Icons.navigate_before_outlined,
                                        size:
                                            CustomSize().customWidth(context) /
                                                7,
                                      ))),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Name",
                                style: TextStyle(
                                    fontSize:
                                        CustomSize().customHeight(context) / 40,
                                    fontStyle: FontStyle.italic),
                              ),
                              SizedBox(
                                width: CustomSize().customWidth(context) / 10,
                              ),
                              Text(
                                widget.application.name,
                                style: TextStyle(
                                    fontSize:
                                        CustomSize().customHeight(context) / 40,
                                    fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Arid No",
                                style: TextStyle(
                                    fontSize:
                                        CustomSize().customHeight(context) / 40,
                                    fontStyle: FontStyle.italic),
                              ),
                              SizedBox(
                                width: CustomSize().customWidth(context) / 10,
                              ),
                              Text(
                                widget.application.aridNo,
                                style: TextStyle(
                                    fontSize:
                                        CustomSize().customHeight(context) / 40,
                                    fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Father Name",
                                style: TextStyle(
                                    fontSize:
                                        CustomSize().customHeight(context) / 40,
                                    fontStyle: FontStyle.italic),
                              ),
                              SizedBox(
                                width: CustomSize().customWidth(context) / 10,
                              ),
                              Text(
                                widget.application.fatherName,
                                style: TextStyle(
                                    fontSize:
                                        CustomSize().customHeight(context) / 40,
                                    fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Father status",
                                style: TextStyle(
                                    fontSize:
                                        CustomSize().customHeight(context) / 40,
                                    fontStyle: FontStyle.italic),
                              ),
                              SizedBox(
                                width: CustomSize().customWidth(context) / 10,
                              ),
                              Text(
                                widget.application.status,
                                style: TextStyle(
                                    fontSize:
                                        CustomSize().customHeight(context) / 40,
                                    fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Required Amount",
                                style: TextStyle(
                                    fontSize:
                                        CustomSize().customHeight(context) / 40,
                                    fontStyle: FontStyle.italic),
                              ),
                              SizedBox(
                                width: CustomSize().customWidth(context) / 10,
                              ),
                              Text(
                                widget.application.amount,
                                style: TextStyle(
                                    fontSize:
                                        CustomSize().customHeight(context) / 40,
                                    fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: CustomSize().customWidth(context) / 10,
                          ),
                          Padding(
                            padding: EdgeInsets.all(
                                CustomSize().customWidth(context) / 30),
                            child: TextFormField(
                              controller: _reason,
                              readOnly: true,
                              maxLines: 5,
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: CustomSize().customHeight(context) / 1.3,
                    width: CustomSize().customWidth(context) / 1.2,
                    child: Column(
                      children: [
                        const Text("Suggestion from committee Members",style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(
                          child: ListView.builder(
                            itemCount: widget.application.suggestion?.length,
                            itemBuilder: (context, ind) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    top:
                                        CustomSize().customWidth(context) / 100,
                                    bottom: CustomSize().customWidth(context) /
                                        50),
                                child: Container(
                                    height: CustomSize().customHeight(context) / 7,
                                    width: CustomSize().customWidth(context) / 1.2,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          CustomSize().customWidth(context) /
                                              100),
                                      color: Colors.blueGrey.withOpacity(0.2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white,
                                          spreadRadius: CustomSize()
                                                  .customHeight(context) /
                                              1000,
                                          blurRadius: CustomSize()
                                                  .customHeight(context) /
                                              100,
                                          offset: Offset(
                                              CustomSize()
                                                      .customHeight(context) /
                                                  1400,
                                              CustomSize()
                                                      .customHeight(context) /
                                                  1400),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          CustomSize().customWidth(context) /
                                              100),
                                      child: Text(widget
                                          .application.suggestion![ind]
                                          .toString()),
                                    )),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: CustomSize().customHeight(context) / 70,
                        ),
                        Visibility(
                          visible: !widget.isTrue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomButton(title: 'Reject', loading: false,onTap: (){
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                  return AlertDialog(
                                    title:Column(
                                      children: [
                                        const Text("Are you sure"),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            CustomButton(title: "cancel", loading: false,onTap: (){
                                              Navigator.pop(context);
                                            },),
                                            CustomButton(title: "Reject", loading: false,onTap: () async {
                                              int res=await AdminApiHandler().rejectApplication(int.parse(widget.application.applicationID));
                                              if(context.mounted){
                                                if(res==200){
                                                  Navigator.pop(context);
                                                  Utilis.flushBarMessage("Application Rejected", context);
                                                }else{
                                                  Utilis.flushBarMessage("try again later", context);
                                                }
                                                Navigator.pushReplacementNamed(context, RouteName.needBaseScreen);
                                              }
                                            }),
                                          ],
                                        )
                                      ],
                                    )
                                  );
                                },);
                              }),
                              CustomButton(title: 'Accept', loading: false,onTap: (){
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                  return AlertDialog(
                                      title:Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left:CustomSize().customWidth(context)/20,right: CustomSize().customWidth(context)/20,top: CustomSize().customWidth(context)/30),
                                            child: TextFormField(
                                              onChanged: (val){},
                                              controller: _amount,
                                              decoration: InputDecoration(
                                                hintText: "enter amount",
                                                labelText: "enter amount",
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(CustomSize().customHeight(context)/60),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              CustomButton(title: "cancel", loading: false,onTap: (){
                                                Navigator.pop(context);
                                              },),
                                              CustomButton(title: "Accept", loading: false,onTap: ()async {
                                                int res=await AdminApiHandler().acceptApplication(
                                                    int.parse(widget.application.applicationID),
                                                    int.parse(_amount.text)
                                                );
                                                    if(context.mounted){
                                                  if(res==200){
                                                    Navigator.pop(context);
                                                    Utilis.flushBarMessage("Application Accepted", context);
                                                  }else{
                                                    Utilis.flushBarMessage("try again later", context);
                                                  }
                                                  Navigator.pushReplacementNamed(context, RouteName.needBaseScreen);
                                                }
                                              },),
                                            ],
                                          )
                                        ],
                                      )
                                  );
                                },);
                              }),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
