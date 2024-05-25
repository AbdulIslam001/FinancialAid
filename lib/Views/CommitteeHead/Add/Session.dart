
import 'package:financial_aid/Services/Admin/AdminApiHandler.dart';
import 'package:financial_aid/Utilis/FlushBar.dart';
import 'package:financial_aid/Utilis/Routes/RouteName.dart';
import 'package:financial_aid/viewModel/CustomButtonViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Components/CustomButton.dart';
import '../../../Resources/CustomSize.dart';

class AddSession extends StatefulWidget {
   AddSession({super.key});

  @override
  State<AddSession> createState() => _AddSessionState();
}

class _AddSessionState extends State<AddSession> {
  @override
  final TextEditingController _start = TextEditingController();
  final TextEditingController _end = TextEditingController();

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    return picked;
  }

List<String> sessionList=['Fall','Summer','Spring'];


  String selectedSession='Fall';

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
          title:const Text("Add New Session"),
          centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(
                CustomSize().customHeight(context) / 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Session",style: TextStyle(fontSize: CustomSize().customHeight(context)/50)),
                DropdownButton(
                  value: selectedSession,
                  onChanged: (val){
                    selectedSession=val.toString();
                    setState(() {});
                  },
                  items: sessionList.map((e) {
                    return DropdownMenuItem(
                        value: e.toString(),
                        child: Text(e.toString()));
                  }).toList(),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(
                    CustomSize().customHeight(context) / 100),
                child:const Text("Session period"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () async {
                      DateTime? date = await _selectDate(context);
                      _start.text = "${date?.day}/${date?.month}/${date?.year}";
                      setState(() {});
                    },
                    child: Row(
                      children: [
                        const Text("To:"),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                CustomSize().customHeight(context) / 95),
                            border: Border.all(),
                          ),
                          height: CustomSize().customHeight(context) / 20,
                          width: CustomSize().customWidth(context) / 2.7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(_start.text.toString()),
                              Icon(
                                Icons.calendar_month,
                                size: CustomSize().customHeight(context) / 25,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      DateTime? date = await _selectDate(context);
                      _end.text = "${date?.day}/${date?.month}/${date?.year}";
                      setState(() {});
                    },
                    child: Row(
                      children: [
                        const Text("From:"),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                CustomSize().customHeight(context) / 95),
                            border: Border.all(),
                          ),
                          height: CustomSize().customHeight(context) / 20,
                          width: CustomSize().customWidth(context) / 2.7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(_end.text.toString()),
                              Icon(
                                Icons.calendar_month,
                                size: CustomSize().customHeight(context) / 25,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(CustomSize().customHeight(context)/10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Consumer<CustomButtonViewModel>(
                  builder: (context, value, child) {
                  return CustomButton(
                      title: 'Add',
                      loading: value.loading,
                      onTap: ()async{
                        value.setLoading(true);
                        if(_start.text.isNotEmpty || _end.text.isNotEmpty){
                          int code=await AdminApiHandler().addSession(selectedSession, _start.text.toString(), _end.text.toString());
                          if(context.mounted){
                            print(code.toString());
                            if(code==200){
                              Navigator.pushReplacementNamed(context, RouteName.committeeHeadDashBoard);
                            }else{
                              Utilis.flushBarMessage("error try again later", context);
                            }
                          }
                        }
                        value.setLoading(false);
                      }
                  );
                },)
              ],
            ),
          )
        ],
      ),
    );
  }
}
