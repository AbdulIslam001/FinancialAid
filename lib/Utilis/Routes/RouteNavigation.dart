

import 'package:financial_aid/Views/CommitteeHead/AcceptedApplication.dart';
import 'package:financial_aid/Views/CommitteeHead/Add/Budget.dart';
import 'package:financial_aid/Views/CommitteeHead/Add/Committee/AddCommitteeMember.dart';
import 'package:financial_aid/Views/CommitteeHead/Add/Faculty/AddFacultyMember.dart';
import 'package:financial_aid/Views/CommitteeHead/Add/Faculty/FacultyRecord.dart';
import 'package:financial_aid/Views/CommitteeHead/Add/Policy/AddPolicy.dart';
import 'package:financial_aid/Views/CommitteeHead/Add/Policy/Policy.dart';
import 'package:financial_aid/Views/CommitteeHead/Add/Student/StudentRecord.dart';
import 'package:financial_aid/Views/CommitteeHead/CommitteeHeadDashBoard.dart';
import 'package:financial_aid/Views/CommitteeHead/Graders/Grader.dart';
import 'package:financial_aid/Views/CommitteeHead/MeritBase/MeritBaseStudents.dart';
import 'package:financial_aid/Views/CommitteeHead/NeedBase/NeedBaseApplication.dart';
import 'package:financial_aid/Views/CommitteeHead/NeedBase/NeedBaseApplicationDetail.dart';
import 'package:financial_aid/Views/CommitteeHead/RejectedApplication.dart';
import 'package:financial_aid/Views/Faculty/FacultyDashBoard.dart';
import 'package:financial_aid/Views/Student/Application/ApplicationForm.dart';
import 'package:financial_aid/Views/Student/Application/ApplicationForm_one.dart';
import 'package:financial_aid/Views/Student/StudentDashBoard.dart';
import 'package:flutter/material.dart';

import '../../Views/Committee/CommitteeDashBoard.dart';
import '../../Views/CommitteeHead/Add/Committee/CommitteeRecord.dart';
import '../../Views/CommitteeHead/Add/Student/AddStudent.dart';
import '../../Views/Login.dart';
import '../../SplashScreen.dart';
import 'RouteName.dart';

class RoutesNavigation {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splashScreen:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case RouteName.login:
        return MaterialPageRoute(builder: (context) => Login());
      case RouteName.committeeDashBoard:
        return MaterialPageRoute(builder: (context) => CommitteeDashBoard());
      case RouteName.committeeHeadDashBoard:
        return MaterialPageRoute(builder: (context) => CommitteeHeadDashBoard());
      case RouteName.studentDashBoard:
        return MaterialPageRoute(builder: (context) => StudentDashBoard());
      case RouteName.facultyDashBoard:
        return MaterialPageRoute(builder: (context) => FacultyDashBoard());
/*      case RouteName.applicationForm:
        return MaterialPageRoute(builder: (context) => ApplicationForm());
      case RouteName.applicationFormOne:
        return MaterialPageRoute(builder: (context) => ApplicationFormOne());*/
/*      case RouteName.studentRecord:
        return MaterialPageRoute(builder: (context) => StudentRecord());*/
      case RouteName.addStudent:
        return MaterialPageRoute(builder: (context) => AddStudent());
      case RouteName.budget:
        return MaterialPageRoute(builder: (context) => Budget());
      // case RouteName.facultyRecord:
      //   return MaterialPageRoute(builder: (context) => FacultyRecord());
      case RouteName.addFacultyMember:
        return MaterialPageRoute(builder: (context) => AddFacultyMember());
      case RouteName.committeeRecord:
        return MaterialPageRoute(builder: (context) => CommitteeRecord());
      case RouteName.addCommitteeMember:
        return MaterialPageRoute(builder: (context) => AddCommitteeMember());
      case RouteName.needBaseScreen:
        return MaterialPageRoute(builder: (context) => NeedBaseApplications());
      case RouteName.acceptedApplication:
        return MaterialPageRoute(builder: (context) => AcceptedApplication());
      case RouteName.rejectedApplication:
        return MaterialPageRoute(builder: (context) => RejectApplication());
      case RouteName.graders:
        return MaterialPageRoute(builder: (context) => Graders());
      // case RouteName.policy:
      //   return MaterialPageRoute(builder: (context) => Policy());
      case RouteName.addPolicy:
        return MaterialPageRoute(builder: (context) => AddPolice());
      case RouteName.meritBase:
        return MaterialPageRoute(builder: (context) => MeritBaseStudent());
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No Route found with this name'),
            ),
          );
        });
    }
  }
}
