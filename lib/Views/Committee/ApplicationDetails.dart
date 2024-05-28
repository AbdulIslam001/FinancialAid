import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:financial_aid/Models/ApplicationModel.dart';
import 'package:financial_aid/Resources/CustomSize.dart';
import 'package:financial_aid/Services/Committee/CommitteeApiHandler.dart';
import 'package:financial_aid/Services/FileDownloader.dart';
import 'package:financial_aid/Utilis/FlushBar.dart';
import 'package:financial_aid/Utilis/Routes/RouteName.dart';
import 'package:financial_aid/Views/Student/StudentDashBoard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:open_file/open_file.dart';

import '../../Components/CustomButton.dart';
import '../../Resources/AppUrl.dart';

class ApplicationDetails extends StatefulWidget {
  Application application;
  ApplicationDetails({super.key, required this.application});

  @override
  State<ApplicationDetails> createState() => _ApplicationDetailsState();
}

class _ApplicationDetailsState extends State<ApplicationDetails> {
  final TextEditingController _reason = TextEditingController();
  final TextEditingController _why = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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


  @override
  Widget build(BuildContext context) {
    _reason.text = widget.application.reason;
    List<String> docsList = [];
    if (widget.application.salarySlip != null ||
        widget.application.salarySlip != '') {
      docsList.add(widget.application.salarySlip ?? "");
    }
    for(int i=0;i<widget.application.agreement.length;i++){
      if (widget.application.agreement != null ||
          widget.application.agreement != '') {
        docsList.add(widget.application.agreement[i]);
      }
    }
    if (widget.application.deathCertificate != null ||
        widget.application.deathCertificate != '') {
      docsList.add(widget.application.deathCertificate ?? "");
    }

    for (int i = 0; i < docsList.length; i++) {
      if (docsList[i].isEmpty) {
        docsList.removeAt(i);
      }
    }
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            title: const Text("Application detail"),
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(enableInfiniteScroll: false),
                items: docsList.map((e) {
                  return Container(
                    height: CustomSize().customHeight(context) / 3.5,
                    width: CustomSize().customWidth(context),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(
                              CustomSize().customHeight(context) / 30),
                          bottomRight: Radius.circular(
                              CustomSize().customHeight(context) / 30)),
                      //  border: Border.all()
                    ),
                    child: EndPoint.houseAgreement + e.toString() !=
                                EndPoint.houseAgreement ||
                            EndPoint.houseAgreement + e.toString() !=
                                EndPoint.houseAgreement + "null"
                        ? e.split('.')[1] == "pdf"
                            ?Row(
                              children: [
                                const Center(
                                  child: Image(
                                    image: AssetImage("Assets/pdf2.png"),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 108.0,left: 50),
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
                            )
                            : e.split('.')[1] == "docx"
                                ? Row(
                      children: [
                        const Center(
                          child: Image(
                            image: AssetImage("Assets/docx1.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 108.0,left: 50),
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
                    )
                                : InstaImageViewer(
                                    child: Image(
                                        height:
                                        CustomSize().customHeight(context) /
                                            3.5,
                                        width:
                                        CustomSize().customWidth(context),
                                        image: NetworkImage(e.startsWith("s")
                                            ? EndPoint.salarySlip + e.toString()
                                            : e.startsWith("d")
                                            ? EndPoint.deathCertificate +
                                            e.toString()
                                            : EndPoint.houseAgreement +
                                            e.toString()),
                                        fit: BoxFit.fill)
                                  )
                        : Image(
                            height: CustomSize().customHeight(context) / 3.5,
                            width: CustomSize().customWidth(context),
                            fit: BoxFit.cover,
                            image: const AssetImage("Assets/c1.png")),
                  );
                }).toList(),
              ),
/*              Stack(
                children: [
                  Positioned(
                    child: Container(
                      height: CustomSize().customHeight(context) / 3.5,
                      width: CustomSize().customWidth(context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(
                                CustomSize().customHeight(context) / 30),
                            bottomRight: Radius.circular(
                                CustomSize().customHeight(context) / 30)),
                        //  border: Border.all()
                      ),
                      child: EndPoint.houseAgreement + docsList[i] !=
                          EndPoint.houseAgreement ||
                          EndPoint.houseAgreement + docsList[i] !=
                              "${EndPoint.houseAgreement}/null"
                          ? InstaImageViewer(
                            child: Image(
                            height: CustomSize().customHeight(context) / 3.5,
                            width: CustomSize().customWidth(context),
                            image: NetworkImage(
                                EndPoint.houseAgreement + docsList[i] ?? ""),
                            fit: BoxFit.fill
                      ),
                          )
                          : Image(
                          height: CustomSize().customHeight(context) / 3.5,
                          width: CustomSize().customWidth(context),
                          fit: BoxFit.fill,
                          image: const AssetImage("Assets/c1.png")),
                    ),
                  ),
                  Positioned(
                      right: CustomSize().customWidth(context)/70,
                      top: CustomSize().customWidth(context)/4,
                      child:GestureDetector(
                          onTap: (){
                            if(i!>docsList.length){
                              i++;
                            }
                            setState((){});
                          },
                          child: Icon(Icons.navigate_next_outlined,size: CustomSize().customWidth(context)/7,))),
                  Positioned(
                      left: CustomSize().customWidth(context)/70,
                      top: CustomSize().customWidth(context)/4,
                      child:GestureDetector(
                          onTap: (){
                            if(i!=0){
                              i--;
                            }
                            setState((){});
                          },
                          child: Icon(Icons.navigate_before_outlined,size: CustomSize().customWidth(context)/7,))),
                ],
              ),*/
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Name",
                    style: TextStyle(
                        fontSize: CustomSize().customHeight(context) / 40,
                        fontStyle: FontStyle.italic),
                  ),
                  SizedBox(
                    width: CustomSize().customWidth(context) / 10,
                  ),
                  Text(
                    widget.application.name,
                    style: TextStyle(
                        fontSize: CustomSize().customHeight(context) / 40,
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
                        fontSize: CustomSize().customHeight(context) / 40,
                        fontStyle: FontStyle.italic),
                  ),
                  SizedBox(
                    width: CustomSize().customWidth(context) / 10,
                  ),
                  Text(
                    widget.application.aridNo,
                    style: TextStyle(
                        fontSize: CustomSize().customHeight(context) / 40,
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
                        fontSize: CustomSize().customHeight(context) / 40,
                        fontStyle: FontStyle.italic),
                  ),
                  SizedBox(
                    width: CustomSize().customWidth(context) / 10,
                  ),
                  Text(
                    widget.application.fatherName,
                    style: TextStyle(
                        fontSize: CustomSize().customHeight(context) / 40,
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
                        fontSize: CustomSize().customHeight(context) / 40,
                        fontStyle: FontStyle.italic),
                  ),
                  SizedBox(
                    width: CustomSize().customWidth(context) / 10,
                  ),
                  Text(
                    widget.application.status,
                    style: TextStyle(
                        fontSize: CustomSize().customHeight(context) / 40,
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
                        fontSize: CustomSize().customHeight(context) / 40,
                        fontStyle: FontStyle.italic),
                  ),
                  SizedBox(
                    width: CustomSize().customWidth(context) / 10,
                  ),
                  Text(
                    widget.application.amount,
                    style: TextStyle(
                        fontSize: CustomSize().customHeight(context) / 40,
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              SizedBox(
                width: CustomSize().customWidth(context) / 10,
              ),
              Padding(
                padding: EdgeInsets.all(CustomSize().customWidth(context) / 30),
                child: TextFormField(
                  controller: _reason,
                  readOnly: true,
                  maxLines: 5,
                  decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      label: Text('Reason For Scholarship')),
                ),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: CustomSize().customHeight(context) / 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                          title: "Reject",
                          loading: false,
                          onTap: () {
                            String status = "rejected";
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Column(
                                    children: [
                                      const Text("Rejected"),
                                      TextFormField(
                                        keyboardType: TextInputType.text,
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return "Enter Reason for Rejection";
                                          }
                                        },
                                        controller: _why,
                                        decoration: const InputDecoration(
                                          labelText: "Reason of Rejection",
                                          hintText: "Reason of Rejection",
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            CustomSize().customHeight(context) /
                                                20,
                                      ),
                                      Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomButton(
                                              title: "cancel",
                                              loading: false,
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            CustomButton(
                                              title: "confirm",
                                              loading: false,
                                              onTap: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  int code =
                                                      await CommitteeApiHandler()
                                                          .giveSuggestion(
                                                              _why.text,
                                                              status,
                                                              int.parse(widget
                                                                  .application
                                                                  .applicationID
                                                                  .toString()));
                                                  if (code == 200 &&
                                                      context.mounted) {
                                                    Navigator.pushReplacementNamed(
                                                        context,
                                                        RouteName
                                                            .committeeDashBoard);
                                                  } else if (context.mounted) {
                                                    Utilis.flushBarMessage(
                                                        "Error try again later",
                                                        context);
                                                  }
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          }),
                      SizedBox(
                        width: CustomSize().customWidth(context) / 10,
                      ),
                      CustomButton(
                          title: "Accept",
                          loading: false,
                          onTap: () {
                            String status = "Accept";
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Column(
                                    children: [
                                      const Text("Accept"),
                                      TextFormField(
                                        keyboardType: TextInputType.text,
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return "Enter Reason for scholarship";
                                          }
                                        },
                                        controller: _why,
                                        decoration: const InputDecoration(
                                          labelText: "Reason of Acceptance",
                                          hintText: "Reason of Acceptance",
                                        ),
                                      ),
                                      TextFormField(
                                        controller: _amount,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly,
                                        ],
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return "Suggest Amount";
                                          }
                                        },
                                        decoration: const InputDecoration(
                                          labelText: "Scholarship Amount",
                                          hintText: "Amount",
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            CustomSize().customHeight(context) /
                                                20,
                                      ),
                                      Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomButton(
                                              title: "cancel",
                                              loading: false,
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            CustomButton(
                                              title: "confirm",
                                              loading: false,
                                              onTap: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  int code =
                                                      await CommitteeApiHandler()
                                                          .giveSuggestion(
                                                              _why.text,
                                                              status,
                                                              int.parse(widget
                                                                  .application
                                                                  .applicationID
                                                                  .toString()));
                                                  if (code == 200 &&
                                                      context.mounted) {
                                                    Navigator.pushReplacementNamed(
                                                        context,
                                                        RouteName
                                                            .committeeDashBoard);
                                                  } else if (context.mounted) {
                                                    Utilis.flushBarMessage(
                                                        "Error try again later",
                                                        context);
                                                  }
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          }),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
