

class EndPoint{
  static String baseUrl="http://192.168.100.11/FinancialAidAllocation/";
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


//  --------------------------


  static String signUp=baseUrl+"api/User/createAccount";

  static String updatedPhoto=baseUrl+"api/Employee/GetPhoto";
  static String markAttendance=baseUrl+"api/Employee/MarkAttendance";
  static String markLeave=baseUrl+"api/Employee/MarkLeave";
  static String getAttendance=baseUrl+"api/Employee/GetAttendance";
  static String getOnlineStudent=baseUrl+"api/Employee/GetOnlineEmployees";
  static String getLeaveApplications=baseUrl+"/api/Employee/GetLeave";
  static String leaves=baseUrl+"/api/Employee/Leaves";
  static String getAllAttendance=baseUrl+"/api/Employee/GetAllAttendance";
  static String updateAttendance=baseUrl+"/api/Employee/UpdateAttendance";
  static String getAllEmployees=baseUrl+"/api/Employee/getAllEmployees";



}