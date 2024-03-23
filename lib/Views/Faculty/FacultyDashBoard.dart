import 'package:flutter/material.dart';

import '../../Resources/CustomSize.dart';

class FacultyDashBoard extends StatelessWidget {
  const FacultyDashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title:const Text("Faculty"),
      ),
      body: Padding(
        padding:EdgeInsets.only(top: CustomSize().customWidth(context)/5,left: CustomSize().customWidth(context)/15,right: CustomSize().customWidth(context)/15),
        child: Container(
          width: CustomSize().customWidth(context)/1.2,
          height:CustomSize().customHeight(context)/1.5,
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
              CircleAvatar(
                radius: CustomSize().customHeight(context) / 13,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      CustomSize().customHeight(context) / 13),
                  child: Image(
                    image:const AssetImage("Assets/pro.jpeg"),
                    width: CustomSize().customHeight(context) / 6,
                    height: CustomSize().customHeight(context) / 6,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(
                  child: ListView.builder(
                    itemCount: 2,
                itemBuilder: (context, index) {
                      return const Card(
                        child: ListTile(
                    title: Text("Adnan"),
                    subtitle: Text("2020-arid-1213"),
                  ),
                );
              },))
            ],
          ),
        ),
      ),
    );
  }
}
