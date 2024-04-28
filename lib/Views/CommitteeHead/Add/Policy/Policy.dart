
import 'package:flutter/material.dart';

import '../../../../Resources/CustomSize.dart';
import '../../../../Utilis/Routes/RouteName.dart';

class Policy extends StatelessWidget {
  const Policy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions:[
          GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, RouteName.addPolicy);
              },
              child: const Icon(Icons.add)),
          SizedBox(
            width: CustomSize().customWidth(context)/20,
          )
        ],
        title:const Text("Policy"),
      ),
    );
  }
}
