import 'dart:convert';

import 'package:financial_aid/Components/PolicyInfoContainer.dart';
import 'package:financial_aid/Services/Admin/AdminApiHandler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../../Models/PolicyModel.dart';
import '../../../../Resources/CustomSize.dart';
import '../../../../Utilis/Routes/RouteName.dart';

class Policy extends StatefulWidget {
  bool show;
  bool isAdd;
  String type;
  Policy({super.key,required this.show , required this.isAdd,required this.type});

  @override
  State<Policy> createState() => _PolicyState();
}


Future<List<PolicyModel>> getPolicies() async {
  List<PolicyModel> list = [];
  Response res = await AdminApiHandler().getPolicies();
  if (res.statusCode == 200) {
    dynamic obj = jsonDecode(res.body);
    for (var i in obj) {
      PolicyModel p = PolicyModel(
          session: i['p']['session'].toString(),
          description: i['c']['description'].toString(),
          policyFor: i['p']['policyfor'].toString(),
          strength: int.parse(i['c']['strength'].toString()),
          policy: i['p']['policy1'].toString(),
          val1: i['c']['val1'].toString(),
          val2: i['c']['val2'].toString());
      list.add(p);
    }
  }
  return list;
}

class _PolicyState extends State<Policy> {
  final TextEditingController _search = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
//    getPolicies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        actions: [
          widget.isAdd?GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RouteName.addPolicy);
              },
              child: const Icon(Icons.add)):
          SizedBox(
            width: CustomSize().customWidth(context) / 20,
          )
        ],
        title: const Text("Policy"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: CustomSize().customWidth(context) / 20,
                right: CustomSize().customWidth(context) / 20,
                top: CustomSize().customWidth(context) / 30),
            child: TextFormField(
              onChanged: (val) {},
              controller: _search,
              decoration: InputDecoration(
                hintText: "search",
                labelText: "search",
                suffixIcon: Icon(Icons.search,
                    size: CustomSize().customWidth(context) / 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      CustomSize().customHeight(context) / 60),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getPolicies(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  var data = snapshot.data ?? [];
                  var filteredList = data.where((item) => item.policyFor.toLowerCase()==widget.type.toLowerCase().toString()).toList();
                  return ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      return PolicyInfoContainer(
                        show: widget.show,
                        val1: filteredList[index].val1,
                        session: filteredList[index].session ?? "",
                        description: filteredList[index].description,
                        policy: filteredList[index].policy,
                        policyFor: filteredList[index].policyFor,
                        val2: filteredList[index].strength.toString(),
                      );
                    },
                  );
                }else{
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: CircularProgressIndicator(),
                      )
                    ],
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
