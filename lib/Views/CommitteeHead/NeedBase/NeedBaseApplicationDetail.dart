import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:financial_aid/Components/ApplicationView.dart';
import 'package:financial_aid/Components/CustomButton.dart';
import 'package:financial_aid/Models/ApplicationModel.dart';
import 'package:financial_aid/Resources/CustomSize.dart';
import 'package:financial_aid/Services/Admin/AdminApiHandler.dart';
import 'package:financial_aid/Services/FileDownloader.dart';
import 'package:financial_aid/Utilis/FlushBar.dart';
import 'package:financial_aid/Utilis/Routes/RouteName.dart';
import 'package:financial_aid/Views/Committee/ApplicationDetails.dart';
import 'package:financial_aid/viewModel/CommitteeHeadViewModel/ApplicationHistory.dart';
import 'package:financial_aid/viewModel/CommitteeHeadViewModel/ApplicationView.dart';
import 'package:financial_aid/viewModel/ViewSuggestionViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:open_file/open_file.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as Path;
import '../../../Resources/AppUrl.dart';

class NeedBaseApplicationDetails extends StatefulWidget {
  Application application;
  bool isTrue;
  bool trackRecord;
  String? status;
  NeedBaseApplicationDetails({super.key,this.status ,required this.application,required this.isTrue,required this.trackRecord});

  @override
  State<NeedBaseApplicationDetails> createState() =>
      _NeedBaseApplicationDetailsState();
}

final TextEditingController _reason = TextEditingController();

TextEditingController _amount= TextEditingController();

class _NeedBaseApplicationDetailsState
    extends State<NeedBaseApplicationDetails> {

  ////////////////
  bool dowloading = false;
  bool fileExists = false;
  double progress = 0;
  String fileName = "";
  late String filePath;
  late CancelToken cancelToken;
  var getPathFile = DirectoryPath();

  startDownload(String url) async {
    cancelToken = CancelToken();
    var storePath = await getPathFile.getPath();
    filePath = '$storePath/$fileName';
    setState(() {
      dowloading = true;
      progress = 0;
    });
    try {
      await Dio().download(url, filePath,
          onReceiveProgress: (count, total) {
            setState(() {
              progress = (count / total);
            });
          }, cancelToken: cancelToken);
      setState(() {
        dowloading = false;
        fileExists = true;
      });
    } catch (e) {
      print(e);
      setState(() {
        dowloading = false;
      });
    }
  }

  cancelDownload() {
    cancelToken.cancel();
    setState(() {
      dowloading = false;
    });
  }

  checkFileExit() async {
    var storePath = await getPathFile.getPath();
    filePath = '$storePath/$fileName';
    bool fileExistCheck = await File(filePath).exists();
    setState(() {
      fileExists = fileExistCheck;
    });
  }

  openfile() {
    OpenFile.open(filePath);
    print("fff $filePath");
  }





  ///////////////////////
  List<bool> _isShow=[];
  bool isVisible=false;
  bool isTrue=false;

  @override
  Widget build(BuildContext context) {
    for(int l=0;l<widget.application.suggestion!.length;l++){
      _isShow.add(false);
    }
    int accepted =0;
    int rejected=0;
    for(int a=0;a<widget.application.isApplication!.length;a++){
      if(widget.application.isApplication![a]=='Accepted'){
        accepted++;
      }else if(widget.application.isApplication![a]=='Rejected'){
        rejected++;
      }
    }
    _reason.text = widget.application.reason;
    List<String> docsList = [];
    if (widget.application.salarySlip != null ||
        widget.application.salarySlip != '') {
      docsList.add(widget.application.salarySlip??"");
    }
    for(int i=0;i<widget.application.agreement.length ;i++){
      if (widget.application.agreement != null ||
          widget.application.agreement != '') {
        docsList.add(widget.application.agreement[i]);
      }
    }
    if (widget.application.deathCertificate != null ||
        widget.application.deathCertificate != '') {
      docsList.add(widget.application.deathCertificate??"");
    }

    for(int i=0;i<docsList.length;i++){
      if(docsList[i].isEmpty){
        docsList.removeAt(i);
      }
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.application.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(top: CustomSize().customHeight(context) / 200),
          child: Consumer<ApplicationViewModel>(
            builder: (context, value, child) {
              return Column(
                children: [
                  widget.trackRecord?Padding(
                    padding: EdgeInsets.only(left: CustomSize().customWidth(context)/10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: ()async{
                              List<Application> list=await ApplicationHistory().getAllApplication(int.parse(widget.application.studentId));
                              if(context.mounted){
                                if(list.isNotEmpty)
                                {
                                  int totalAccepted=0;
                                  int totalRejected=0;
                                  for(var item in list){
                                    if(item.session!=null && item.applicationStatus?.toLowerCase().toString()=='rejected'){
                                      totalRejected++;
                                    }else if(item.session!=null && item .applicationStatus?.toLowerCase().toString()=='accepted'){
                                      totalAccepted++;
                                    }
                                  }
                                  showDialog(context: context, builder: (context) {
                                    return AlertDialog(
                                      title: SizedBox(
                                        height: CustomSize().customHeight(context)/2,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(bottom: CustomSize().customHeight(context)/100),
                                              child: PieChart(
                                                legendOptions: const LegendOptions(
                                                    legendPosition: LegendPosition.left),
                                                dataMap: {
                                                  'Accepted':totalAccepted.toDouble(),
                                                  'Rejected':totalRejected.toDouble(),
                                                },
                                                chartRadius: CustomSize().customWidth(context) / 3,
                                                chartValuesOptions: const ChartValuesOptions(
                                                    showChartValuesInPercentage: true),
                                                centerText: "Accepted : $totalAccepted/Rejected : $totalRejected",
                                                animationDuration: const Duration(milliseconds: 1000),
                                                chartType: ChartType.ring,
                                                colorList: const [Colors.green, Colors.red],
                                              ),
                                            ),
                                            Expanded(
                                              child:  ListView.builder(
                                                itemCount: list.length,
                                                itemBuilder: (context, index1) {
                                                  return Card(
                                                    child: ListTile(
                                                      title: Text(list[index1].name),
                                                      subtitle: Text(list[index1].aridNo),
                                                      trailing: Column(
                                                        children: [
                                                          Text(list[index1].session??""),
                                                          Text(list[index1].applicationStatus??"",style:const TextStyle(color:Colors.red)),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },);
                                }
                                else{
                                  Utilis.flushBarMessage("No record Exist", context);
                                }
                              }
                        }, child:const Text("Track Record")),
                        widget.status.toString()=='Accepted'?const Text("Verified"):const Text("Not Verified"),
                      ],
                    ),
                  ):const SizedBox(),
                  Padding(
                    padding: EdgeInsets.only(bottom: CustomSize().customHeight(context)/100),
                    child: PieChart(
                      legendOptions: const LegendOptions(
                          legendPosition: LegendPosition.left),
                      dataMap: {
                        'Accepted':accepted.toDouble(),
                        'Rejected':rejected.toDouble(),
                      },
                      chartRadius: CustomSize().customWidth(context) / 3,
                      chartValuesOptions: const ChartValuesOptions(
                          showChartValuesInPercentage: true),
                      centerText: "Accepted : $accepted/Rejected : $rejected",
                      animationDuration: const Duration(milliseconds: 1000),
                      chartType: ChartType.ring,
                      colorList: const [Colors.green, Colors.red],
                    ),
                  ),
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
                          CarouselSlider(
                            options: CarouselOptions(
                              enableInfiniteScroll: false
                            ),
                            items: docsList.map((e){
                              return Container(
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
                                child:
                                EndPoint.houseAgreement + e.toString() !=
                                    EndPoint.houseAgreement ||
                                    EndPoint.houseAgreement + e.toString() !=
                                        EndPoint.houseAgreement + "null"
                                    ?
                                e.split('.')[1] == "pdf"
                                    ?Row(
                                  children: [
                                    const Center(
                                      child: Image(
                                        image: AssetImage("Assets/pdf2.png"),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Padding(
                                      padding:const EdgeInsets.only(top: 108.0,left: 40),
                                      child: GestureDetector(
                                          onTap: ()async{
                                              fileName = Path.basename(EndPoint.houseAgreement + e.toString());
                                            await checkFileExit();
                                            startDownload(EndPoint.houseAgreement + e.toString());
                                            openfile();
                                          },
                                          child:const Icon(Icons.download)),
                                    )
                                  ],
                                )
                                    : e.split('.')[1] == "docx"
                                    ? Row(
                                  children: [
                                    Center(
                                      child: Image(
                                        width: CustomSize().customWidth(context)/2,
                                        image:const AssetImage("Assets/docx1.png"),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: CustomSize().customWidth(context)/3,left: CustomSize().customWidth(context)/5.5),
                                      child: GestureDetector(
                                          onTap: ()async{
                                            fileName = Path.basename(EndPoint.houseAgreement + e.toString());
                                            await checkFileExit();
                                            startDownload(EndPoint.houseAgreement + e.toString());
                                            openfile();
                                          },
                                          child: const Icon(Icons.download)),
                                    )
                                  ],
                                ):
                                InstaImageViewer(
                                  child: Image(
                                      height: CustomSize()
                                          .customHeight(context) /
                                          3.5,
                                      width:
                                      CustomSize().customWidth(context),
                                      image: NetworkImage(
                                        e.startsWith("s")?EndPoint.salarySlip+ e.toString():
                                        e.startsWith("d")?EndPoint.deathCertificate+ e.toString():
                                        EndPoint.houseAgreement + e.toString()
                                      ),
                                      fit: BoxFit.fill),
                                )
                                    : Image(
                                    height: CustomSize()
                                        .customHeight(context) /
                                        3.5,
                                    width:
                                    CustomSize().customWidth(context),
                                    fit: BoxFit.fill,
                                    image: const AssetImage("Assets/c1.png")),
                              );
                            }).toList(),
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
                    height: CustomSize().customHeight(context) / 2,
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
                                  child: ListTile(
                                    title: Padding(
                                      padding: EdgeInsets.all(
                                          CustomSize().customWidth(context) /
                                              100),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(widget
                                                      .application.committeeMemberName![ind]
                                                      .toString(),
                                                  ),
                                                  Text(widget
                                                      .application.isApplication![ind].toString(),style: TextStyle(
                                                      color:widget
                                                          .application.isApplication![ind].toLowerCase().toString()=="accepted"?Colors.green:Colors.red
                                                  )),
                                                ],
                                              ),
                                              Text(widget
                                                  .application.suggestedAmount?[ind].toString()!=null.toString()?widget.application.suggestedAmount![ind].toString():"",style: TextStyle(
                                                  color:widget
                                                      .application.isApplication![ind].toLowerCase().toString()=="accepted"?Colors.green:Colors.red
                                              )),
                                              TextButton(onPressed: (){
                                                _isShow[ind]=!_isShow[ind];
                                                setState(() {

                                                });
                                              }, child:_isShow[ind]?const Text("hide"):const Text("View")),
                                            ],
                                          ),
                                          Visibility(
                                            visible: _isShow[ind],
                                            child :Text(widget
                                                .application.suggestion![ind]
                                                .toString()),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                /*Container(
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
                                    child:

                                ),*/
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
                              CustomButton(title: 'Accept',
                                  loading: false,
                                  onTap: (){
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
                                              keyboardType: TextInputType.number,
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter.digitsOnly,
                                              ],
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
                                              CustomButton(title: "Accept",
                                                loading: isTrue,onTap: ()async {
                                                if(!isTrue){
                                                  isTrue=true;
                                                  setState(() {});
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
                                                    isTrue=false;
                                                    setState(() {

                                                    });
                                                    Navigator.pushReplacementNamed(context, RouteName.needBaseScreen);
                                                  }
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


/*                          Stack(
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
                                      ? InstaImageViewer(
                                        child: Image(
                                            height: CustomSize()
                                                    .customHeight(context) /
                                                3.5,
                                            width:
                                                CustomSize().customWidth(context),
                                            image: NetworkImage(
                                                EndPoint.documentUrl + docsList[i] ??
                                                    ""),
                                            fit: BoxFit.fill),
                                      )
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
*/
/*                              Positioned(
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
                                      ))),*//*
                            ],
                          ),*/

