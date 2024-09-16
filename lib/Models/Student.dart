class Student {
  String aridNo;
  String name;
  int semester;
  double cgpa;
  String section;
  String degree;
  String fatherName;
  String gender;
  int studentId;
  int? position;
  String profileImage;
  double? prevCgpa;
  String? amount;
  String? rating;
  Student({
    this.amount,
    this.rating,
      required this.aridNo,
    this.position,
    this.prevCgpa,
      required this.name,
      required this.semester,
      required this.cgpa,
      required this.section,
      required this.degree,
      required this.fatherName,
      required this.gender,
      required this.studentId,
     required this.profileImage,});

}