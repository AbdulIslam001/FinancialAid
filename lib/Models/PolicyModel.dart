
class PolicyModel{
  String policyFor;
  String policy;
  String val1;
  String val2;
  String description;
  int strength;
  String? session;
  PolicyModel({this.session,required this.description,required this.policyFor,required this.strength,required this.policy,required this.val1, required this.val2});
}