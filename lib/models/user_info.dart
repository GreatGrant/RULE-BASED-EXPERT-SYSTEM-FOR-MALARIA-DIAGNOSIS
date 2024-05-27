
import 'package:equatable/equatable.dart';

class UserInfo extends Equatable {
  final String title;
  const UserInfo({
    required this.title,
  });

  @override
  List<Object> get props => [
    title,
  ];
}

class Friend extends Equatable {
  final String name;
  final String date;
  final String age;
  final String image;
  const Friend({
    required this.age,
    required this.date,
    required this.image,
    required this.name,
  });

  @override
  List<Object> get props => [
    name,
    date,
    age,
    image,
  ];
}

List<UserInfo> staffManagementList = [
  const UserInfo(
    title: "Staff Overview",
  ),
  const UserInfo(
    title: "Manage Staff",
  ),
];
List<UserInfo> patientManagementList = [
  const UserInfo(
    title: "Patients Overview",
  ),
  const UserInfo(
    title: "Manage Patients",
  ),
];