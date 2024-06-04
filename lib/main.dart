import 'package:financial_aid/Utilis/Routes/RouteName.dart';
import 'package:financial_aid/Utilis/Routes/RouteNavigation.dart';
import 'package:financial_aid/viewModel/CommitteeHeadViewModel/ApplicationView.dart';
import 'package:financial_aid/viewModel/CommitteeHeadViewModel/DegreeSelectionViewModel.dart';
import 'package:financial_aid/viewModel/CommitteeViewModel/AddCommitteeViewModel.dart';
import 'package:financial_aid/viewModel/CustomButtonViewModel.dart';
import 'package:financial_aid/viewModel/LoginViewModel.dart';
import 'package:financial_aid/viewModel/NeedBaseTotalAmount.dart';
import 'package:financial_aid/viewModel/StudentViewModel/FilePickerViewModel.dart';
import 'package:financial_aid/viewModel/StudentViewModel/StudentInfoViewModel.dart';
import 'package:financial_aid/viewModel/ViewSuggestionViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>LoginViewModel()),
        ChangeNotifierProvider(create: (_)=>DegreeViewModel()),
        ChangeNotifierProvider(create: (_)=>StudentInfoViewModel()),
        ChangeNotifierProvider(create: (_)=>AddCommitteeViewModel()),
        ChangeNotifierProvider(create: (_)=>FilePickerViewModel()),
        ChangeNotifierProvider(create: (_)=>ApplicationViewModel()),
        ChangeNotifierProvider(create: (_)=>CustomButtonViewModel()),
        ChangeNotifierProvider(create: (_)=>ViewSuggestionViewModel()),
        ChangeNotifierProvider(create: (_)=>NeedBaseTotalAmount()),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.blueGrey.shade100,
          primarySwatch: Colors.deepPurple,
          primaryColor: Colors.blueGrey.withOpacity(0.4),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        initialRoute: RouteName.splashScreen,
        onGenerateRoute: RoutesNavigation.generateRoute,
      ),
    );
  }
}

