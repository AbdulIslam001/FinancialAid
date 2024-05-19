import 'dart:convert';

import 'package:financial_aid/Services/Faculty/FacultyAPiHandler.dart';
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

  late final _ratingController;

  late double _rating;

  double _userRating = 3.0;

  int _ratingBarMode = 1;

  double _initialRating = 2.0;

  bool _isRTLMode = false;

  bool _isVertical = false;

  IconData? _selectedIcon;

  @override
  void initState() {
    super.initState();
    _ratingController = TextEditingController(text: '3.0');
    _rating = _initialRating;
  }

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
                                  EndPoint.imageUrl + profileImage
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
              DrawerCustomButtons(
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
                  }),
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
                              EndPoint.imageUrl + profileImage
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
                                      TextFormField(),
                                      Text(snapshot.data![index].name.toString()),
                                      RatingBarIndicator(
                                        rating: _userRating,
                                        itemBuilder: (context, index) => Icon(
                                          _selectedIcon ?? Icons.star,
                                          color: Colors.amber,
                                        ),
                                        itemCount: 5,
                                        itemSize: 50.0,
                                        unratedColor: Colors.amber.withAlpha(50),
                                        direction: _isVertical ? Axis.vertical : Axis.horizontal,
                                      ),
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
