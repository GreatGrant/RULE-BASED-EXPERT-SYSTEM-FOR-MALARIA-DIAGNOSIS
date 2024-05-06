
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

List<Friend> friendList = [
  const Friend(
    name: "Jessica Veranda",
    date: "20 June",
    age: "25th",
    image: "assets/5.jpg",
  ),
  const Friend(
    name: "Jessica Veranda",
    date: "20 June",
    age: "25th",
    image: "assets/5.jpg",
  ),const Friend(
    name: "Jessica Veranda",
    date: "20 June",
    age: "25th",
    image: "assets/5.jpg",
  ),
  const Friend(
    name: "Nabilah Ratna Ayu",
    date: "23 June",
    age: "20th",
    image: "assets/1.jpg",
  ),
  const Friend(
    name: "Melody Nurramdhani Laksani",
    date: "15 July",
    age: "31th",
    image: "assets/2.jpg",
  ),
  const Friend(
    name: "Cindy Yuvia",
    date: "27 July",
    age: "23th",
    image: "assets/3.jpg",
  ),
  const Friend(
    name: "Cindy Gulla",
    date: "17 August",
    age: "23th",
    image: "assets/4.jpg",
  ),
];

List<UserInfo> staffManagementList = [
  const UserInfo(
    title: "Register Staff",
  ),
  const UserInfo(
    title: "Manage Staff",
  ),
];
List<UserInfo> patientManagementList = [
  const UserInfo(
    title: "Register Patients",
  ),
  const UserInfo(
    title: "Manage Patients",
  ),
];