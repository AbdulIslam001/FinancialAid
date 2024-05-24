import 'dart:convert';

import 'package:financial_aid/Models/BudgetModel.dart';
import 'package:financial_aid/Services/Admin/AdminApiHandler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

import '../../../Components/BudgetInfoContainer.dart';
import '../../../Components/CustomButton.dart';
import '../../../Resources/CustomSize.dart';
import '../../../Utilis/FlushBar.dart';
import '../../../Utilis/Routes/RouteName.dart';

class Budget extends StatelessWidget {
  Budget({super.key});

  Future<List<BudgetModel>> getAllBudget() async {
    List<BudgetModel> list = [];
    Response res = await AdminApiHandler().getAllBudget();
    if (res.statusCode == 200) {

      dynamic obj = jsonDecode(res.body);
      BudgetModel b;
      for (var i in obj) {
        b = BudgetModel(
            id: i["budgetId"],
            amount: i["budgetAmount"].toString(),
            remainingAmount: i["remainingAmount"].toString(),
            session: i["budget_session"].toString(),
            status: i["status"].toString()
        );
        list.add(b);
      }
    }
    return list;
  }
  final TextEditingController _search=TextEditingController();
  final TextEditingController _amount= TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            Padding(
              padding: EdgeInsets.only(right: CustomSize().customWidth(context)/20),
              child:GestureDetector(
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
                                    CustomButton(title: "Add", loading: false,onTap: ()async {
                                      int res=await AdminApiHandler().addBudget(int.parse(_amount.text));
                                      if(context.mounted){
                                        if(res==200){
                                          Navigator.pop(context);
                                          Utilis.flushBarMessage("Budget Added", context);
                                        }else{
                                          Utilis.flushBarMessage("try again later", context);
                                        }
                                        Navigator.pushReplacementNamed(context, RouteName.budget);
                                      }
                                    },),
                                  ],
                                )
                              ],
                            )
                        );
                      },
                    );
                  },
                  child: const Icon(Icons.add_box_rounded)),
            )
          ],
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text("Budget"),
          centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left:CustomSize().customWidth(context)/20,right: CustomSize().customWidth(context)/20,top: CustomSize().customWidth(context)/30),
            child: TextFormField(
              onChanged: (val){},
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
              future: getAllBudget(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                        return BudgetInfoContainer(
                          amount: snapshot.data![index].amount,
                          remainingAmount: snapshot.data![index].remainingAmount,
                          session: snapshot.data![index].session,
                        );
                    },
                  );
                }else{
                  return const Column(
                    children: [
                      Center(
                        child: CircularProgressIndicator(),
                      )
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
