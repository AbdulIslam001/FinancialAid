

import 'package:financial_aid/Models/ApplicationModel.dart';
import 'package:flutter/material.dart';

class Graders extends StatelessWidget {
  const Graders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title:const Text("Graders"),
        centerTitle: true,
      )
    );
  }
}
