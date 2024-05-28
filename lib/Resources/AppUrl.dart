

class EndPoint{
  static String baseUrl="http://192.168.43.249/FinancialAidAllocation/";
  static String login=baseUrl+"api/User/Login";
  static String getStudentInfo=baseUrl+"api/Student/getStudentInfo";
  static String checkApplicationStatus=baseUrl+"api/Student/getStudentApplicationStatus";
  static String sendApplication=baseUrl+"api/Student/sendApplication";
  static String imageUrl=baseUrl+"Content/profileImages/";
  static String getAdminInfo=baseUrl+"api/Admin/getAdminInfo";
  static String getAllStudents=baseUrl+"api/Admin/getAllStudent";
  static String updatePassword=baseUrl+"api/Admin/UpdatePassword";
  static String getAllBudget=baseUrl+"api/Admin/getAllBudget";
  static String addFacultyMember=baseUrl+"api/Admin/AddFacultyMember";
  static String getFacultyMembers =baseUrl+"api/Admin/FacultyMembers";
  static String getCommitteeMembers =baseUrl+"api/Admin/CommitteeMembers";
  static String AddCommitteeMember =baseUrl+"api/Admin/AddCommitteeMember";
  static String getApplication=baseUrl+"api/Committee/GetApplication";
  static String updateProfileImage=baseUrl+"api/Student/UpdateProfileImage";
  static String committeeMemberInfo=baseUrl+"api/Committee/CommitteeMembers";
  static String houseAgreement=baseUrl+"Content/HouseAgreement/";
  static String salarySlip=baseUrl+"Content/SalarySlip/";
  static String deathCertificate=baseUrl+"Content/DeathCertificates/";
  static String giveSuggestion=baseUrl+"api/Committee/GiveSuggestion";
  static String getBalance=baseUrl+"api/Committee/GetBalance";
  static String switchRole=baseUrl+"api/User/SwitchRole";
  static String facultyInfo=baseUrl+"api/Faculty/FacultyInfo";
  static String adminApplication=baseUrl+"api/Admin/ApplicationSuggestions";
  static String acceptApplication=baseUrl+"api/Admin/AcceptApplication";
  static String rejectApplication=baseUrl+"api/Admin/RejectApplication";
  static String accepted=baseUrl+"api/Admin/AcceptedApplication";
  static String rejected=baseUrl+"api/Admin/RejectedApplication";
  static String assignGrader=baseUrl+"api/Admin/AssignGrader";
  static String meritBaseShortListing=baseUrl+"api/Admin/MeritBase";
  static String addStudent=baseUrl+"api/Admin/AddStudent";
  static String addPolicies=baseUrl+"api/Admin/AddPolicies";
  static String getPolicies=baseUrl+"api/Admin/getPolicies";
  static String unAssignedStudents=baseUrl+"api/Admin/unAssignedGraders";
  static String addBudget=baseUrl+"api/Admin/AddBudget";
  static String getGraderInfo=baseUrl+"api/Admin/gradersInformation";
  static String rateGraderPerformance=baseUrl+"api/Faculty/RateGraderPerformance";
  static String getMeritBaseShortListedStudent=baseUrl+"api/Admin/GetMeritBaseShortListedStudent";
  static String removeGrader=baseUrl+"api/Admin/Removegrader";
  static String canRateGrader=baseUrl+"api/Faculty/CanRateGrader";
  static String addSession=baseUrl+"api/Admin/AddSession";
  static String meritBaseAmmount=baseUrl+"api/Admin/MeritBaseAmmount";
  static String unAssignedFacultyMember=baseUrl+"api/Admin/UnAssignedFaculty";
  static String checkCgpaPolicy=baseUrl+"api/Student/checkCgpaPolicy";

  //MeritBaseAmmount
}