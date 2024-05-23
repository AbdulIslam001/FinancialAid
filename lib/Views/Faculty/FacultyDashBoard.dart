import 'dart:convert';

import 'package:financial_aid/Components/CustomButton.dart';
import 'package:financial_aid/Services/Faculty/FacultyAPiHandler.dart';
import 'package:financial_aid/Utilis/FlushBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Components/DrawerCustomButtons.dart';
import '../../Models/GraderModel.dart';
import '../../Resources/AppUrl.dart';
import '../../Resources/CustomSize.dart';
import '../../Services/Committee/CommitteeApiHandler.dart';
import '../../Utilis/Routes/RouteName.dart';

class FacultyDashBoard extends StatefulWidget {
  FacultyDashBoard({super.key});

  @override
  State<FacultyDashBoard> createState() => _FacultyDashBoardState();
}

class _FacultyDashBoardState extends State<FacultyDashBoard> {
  String name = "";

  String profileImage = "";

  Future<void> getFacultyInfo() async {
    Response res = await FacultyApiHandler().getFacultyInfo();
    if (res.statusCode == 200) {
      dynamic obj = jsonDecode(res.body);
      name = obj["name"].toString();
      profileImage = obj["profilePic"].toString();
    }
  }

  final TextEditingController _reason=TextEditingController();

  Future<List<GraderModel>> getAllGraders() async {
    List<GraderModel> list = [];
    Response res = await FacultyApiHandler().getGraderInformation();
    if (res.statusCode == 200) {
      dynamic obj = jsonDecode(res.body);
      for (var i in obj) {
        GraderModel g = GraderModel(
            aridNo: i['arid_no'].toString(),
            name: i['name'].toString(),
            studentId: i['studentId'].toString(),
            facultyId: i['facultyId'].toString(),
            gender: i['gender'].toString(),
            profileImage: i['profile_image'].toString());
        list.add(g);
      }
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
  }

  double rating=0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text("Faculty"),
      ),
      drawer: Drawer(
        width: CustomSize().customWidth(context) / 1.7,
        child: ListTile(
          title: Padding(
            padding:
                EdgeInsets.only(top: CustomSize().customWidth(context) / 10),
            child: GestureDetector(
              onTap: () {},
              child: FutureBuilder(
                future: getFacultyInfo(),
                builder: (context, snapshot) {
                  return CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: CustomSize().customHeight(context) / 13,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          CustomSize().customHeight(context) / 13),
                      child: EndPoint.imageUrl + profileImage ==
                                  "${EndPoint.imageUrl + profileImage}null" ||
                              EndPoint.imageUrl + profileImage ==
                                  EndPoint.imageUrl
                          ? Icon(
                              Icons.person,
                              size: CustomSize().customHeight(context) / 10,
                            )
                          : Image(
                              image: NetworkImage(
                                  EndPoint.imageUrl + profileImage),
                              width: CustomSize().customHeight(context) / 6,
                              height: CustomSize().customHeight(context) / 6,
                              fit: BoxFit.fill,
                            ),
                    ),
                  );
                },
              ),
            ),
          ),
          subtitle: Column(
            children: [
              FutureBuilder(
                future: getFacultyInfo(),
                builder: (context, snapshot) {
                  return Center(
                      child: Text(
                    name,
                    style: TextStyle(
                        fontSize: CustomSize().customHeight(context) / 40,
                        fontStyle: FontStyle.italic),
                  ));
                },
              ),
              SizedBox(
                height: CustomSize().customHeight(context) / 20,
              ),
              DrawerCustomButtons(
                  title: "switch to Committee",
                  onTab: () async {
                    Response res = await CommitteeApiHandler().switchRole();
                    if (res.statusCode == 200) {
                      dynamic obj = jsonDecode(res.body);
                      SharedPreferences sp =
                          await SharedPreferences.getInstance();
                      sp.setInt('id', int.parse(obj["profileId"].toString()));
                      sp.setInt("role", int.parse(obj["role"].toString()));
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(
                            context, RouteName.splashScreen);
                      }
                    }
                  }),
              SizedBox(
                height: CustomSize().customHeight(context) / 50,
              ),
/*              DrawerCustomButtons(
                  title: "Balance",
                  onTab: () async {
                    Response res = await CommitteeApiHandler().getBalance();
                    if (res.statusCode == 200 && context.mounted) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Column(
                              children: [
                                Text(
                                  "Remaining Balance",
                                  style: TextStyle(
                                      fontSize:
                                          CustomSize().customHeight(context) /
                                              40,
                                      fontStyle: FontStyle.italic),
                                ),
                                Text(
                                  res.body,
                                  style: TextStyle(
                                      fontSize:
                                          CustomSize().customHeight(context) /
                                              40,
                                      fontStyle: FontStyle.italic),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    }
                  }),*/
              SizedBox(
                height: CustomSize().customHeight(context) / 2.1,
              ),
              DrawerCustomButtons(
                  title: "Logout",
                  onTab: () async {
                    SharedPreferences sp =
                        await SharedPreferences.getInstance();
                    sp.clear();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, RouteName.login);
                    }
                  }),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
            top: CustomSize().customWidth(context) / 5,
            left: CustomSize().customWidth(context) / 15,
            right: CustomSize().customWidth(context) / 15),
        child: Container(
          width: CustomSize().customWidth(context) / 1.2,
          height: CustomSize().customHeight(context) / 1.5,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(CustomSize().customHeight(context) / 80),
            color: Colors.blueGrey.withOpacity(0.2),
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                spreadRadius: CustomSize().customHeight(context) / 1000,
                blurRadius: CustomSize().customHeight(context) / 100,
                offset: Offset(CustomSize().customHeight(context) / 1400,
                    CustomSize().customHeight(context) / 1400),
              ),
            ],
          ),
          child: Column(
            children: [
              FutureBuilder(
                future: getFacultyInfo(),
                builder: (context, snapshot) {
                  return CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: CustomSize().customHeight(context) / 13,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          CustomSize().customHeight(context) / 13),
                      child: EndPoint.imageUrl + profileImage ==
                          "${EndPoint.imageUrl + profileImage}null" ||
                          EndPoint.imageUrl + profileImage ==
                              EndPoint.imageUrl
                          ? Icon(
                        Icons.person,
                        size: CustomSize().customHeight(context) / 10,
                      )
                          : Image(
                        image: NetworkImage(
                            EndPoint.imageUrl + profileImage),
                        width: CustomSize().customHeight(context) / 6,
                        height: CustomSize().customHeight(context) / 6,
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                },
              ),
              FutureBuilder(
                future: getAllGraders(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                        child: ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                  height:
                                      CustomSize().customHeight(context) / 1.5,
                                  width: CustomSize().customWidth(context),
                                  child: Center(child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left:CustomSize().customWidth(context)/20,
                                            right: CustomSize().customWidth(context)/20,
                                            top: CustomSize().customWidth(context)/20),
                                        child: TextFormField(
                                          onChanged: (val){},
                                          controller: _reason,
                                          decoration: InputDecoration(
                                            hintText: "Enter reason",
                                            labelText: "Enter reason",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(CustomSize().customHeight(context)/60),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: CustomSize().customHeight(context)/20,
                                      ),
                                      RatingBar.builder(
                                        initialRating: 0,
                                        allowHalfRating: true,
                                        minRating: 1,
                                        maxRating: 5,
                                        direction: Axis.horizontal,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.only(left: CustomSize().customWidth(context)/50),
                                        itemBuilder: (context, index) {
                                          switch (index){
                                            case 0:
                                              return const Icon(Icons.sentiment_very_dissatisfied,color: Colors.amber,);
                                            case 1:
                                              return const Icon(Icons.sentiment_dissatisfied,color: Colors.amber,);
                                            case 2:
                                              return const Icon(Icons.sentiment_neutral,color: Colors.amber,);
                                            case 3:
                                              return const Icon(Icons.sentiment_satisfied,color: Colors.amber,);
                                            case 4:
                                              return const Icon(Icons.sentiment_very_satisfied,color: Colors.amber,);
                                            default :
                                              return const Text("");
                                          }
                                          return const Icon(Icons.star,color: Colors.amber,);
                                      },
                                        onRatingUpdate: (value) {
                                          rating=value;
                                          print(rating);
                                      },),
                                      SizedBox(
                                        height: CustomSize().customHeight(context)/10,
                                      ),
                                      CustomButton(title: "Rate", loading: false,onTap: ()async{
                                        int status=await FacultyApiHandler().rateGraderPerformance(
                                            _reason.text.toString(),
                                            snapshot.data![index].studentId.toString(),
                                            snapshot.data![index].facultyId.toString(),
                                            rating.toString());
                                        if(context.mounted) {
                                          if (status == 200) {
                                            Navigator.pop(context);
                                          }else if(status==302){
                                            Utilis.flushBarMessage("Already Rated", context);
                                          }else{
                                            Utilis.flushBarMessage("error", context);
                                          }
                                        }
                                      },)
                                    ],
                                  )),
                                );
                              },
                            );
                          },
                          child: Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: CustomSize().customHeight(context) / 30,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      CustomSize().customHeight(context) / 30),
                                  child: EndPoint.imageUrl +
                                                  snapshot.data![index]
                                                      .profileImage ==
                                              EndPoint.imageUrl + "null" ||
                                          EndPoint.imageUrl +
                                                  snapshot.data![index]
                                                      .profileImage ==
                                              EndPoint.imageUrl
                                      ? (snapshot.data![index].gender == 'M'
                                          ? Image.asset("Assets/male.png")
                                          : Image.asset("Assets/female.png"))
                                      : Image(
                                          image: NetworkImage(
                                              EndPoint.imageUrl +
                                                  snapshot.data![index]
                                                      .profileImage),
                                          width: CustomSize()
                                                  .customHeight(context) /
                                              12, //CustomSize().customHeight(context)/15
                                          height: CustomSize()
                                                  .customHeight(context) /
                                              12,
                                          fit: BoxFit.fill,
                                        ),
                                ),
                              ),
                              title: Text(snapshot.data![index].name),
                              subtitle: Text(snapshot.data![index].aridNo),
                            ),
                          ),
                        );
                      },
                    ));
                  } else {
                    return const Column(
                      children: [
                        Center(child: CircularProgressIndicator()),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
