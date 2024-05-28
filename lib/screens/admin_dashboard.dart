import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rbes_for_malaria_diagnosis/util/show_snackbar.dart';
import 'package:rbes_for_malaria_diagnosis/widgets/custom_tab.dart';
import '../models/user_info.dart';
import '../services/patient_helper.dart';
import '../services/user_helper.dart';
import '../widgets/build_drawer.dart';
import '../widgets/searchbox.dart';
import '../widgets/custom_tabbar_view.dart';
import '../widgets/user_event_tab_bar_view.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  AdminDashboardState createState() => AdminDashboardState();
}

class AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  TabController? _controller;
  late TextEditingController _searchController;
  String _selectedTab = 'staff'; // Default selected tab

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _controller = TabController(length: 2, vsync: this);
    _controller!.addListener(() {
      if (_controller!.indexIsChanging) {
        setState(() {
          // Update the selected tab
          _selectedTab = _controller!.index == 0 ? 'staff' : 'patients';
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: buildAppBar(context),
      drawer: buildDrawer(context),
      backgroundColor: Colors.blueGrey[100],
      body: Column(
        children: [
          const SizedBox(height: 15.0),
          SearchBox(
            hintText: 'Search patient or staff',
            icon: Icons.search,
            controller: _searchController,
          ),
          const SizedBox(height: 15.0),
          CustomTabBar(
            controller: _controller!,
            tabTitles: const ["Staff", "Patients"],
          ),
          const SizedBox(height: 15.0),
          CustomTabBarView(
            controller: _controller!,
            children: [
              UserEventTabBarView(events: staffManagementList),
              UserEventTabBarView(events: patientManagementList),
            ],
          ),
          const SizedBox(height: 35.0),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
                color: theme.cardColor,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      children: [
                        Text(
                          _selectedTab == 'staff'
                              ? "Registered Staff"
                              : "Registered Patients",
                          style: theme.textTheme.titleMedium,
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            _showAddBottomSheet(context);
                          },
                          child: Text(
                            "+ Add new",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.blueGrey[900],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection(
                          _selectedTab == 'staff' ? "staff" : "patients")
                          .where('role',
                          isEqualTo: _selectedTab == 'staff'
                              ? 'staff'
                              : 'patient')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          final List<DocumentSnapshot> users =
                              snapshot.data!.docs;
                          if (users.isEmpty) {
                            return Center(
                              child: Text(
                                _selectedTab == 'staff'
                                    ? 'No registered staff'
                                    : 'No registered patients',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.black54,
                                  fontSize: 18,
                                ),
                              ),
                            );
                          }
                          return ListView.builder(
                            itemCount: users.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder:
                                (BuildContext context, int index) {
                              var user = users[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blueGrey[100],
                                  radius: 27.0,
                                  child: _selectedTab == 'patients'
                                      ? Icon(Icons.local_hospital,
                                      color: Colors.blueGrey[900])
                                      : Icon(Icons.work,
                                      color: Colors.blueGrey[900]),
                                ),
                                title: Text(
                                  user['name'] ?? '',
                                  style: theme.textTheme.bodyLarge,
                                ),
                                subtitle: Text(
                                      () {
                                    try {
                                      if (_selectedTab == 'patients') {
                                        return user['registrationNumber'] ??
                                            '';
                                      } else {
                                        return user['email'] ?? '';
                                      }
                                    } catch (e) {
                                      return ''; // Return an empty string in case of an error
                                    }
                                  }(),
                                  style: theme.textTheme.titleMedium,
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddBottomSheet(context);
        },
        backgroundColor: Colors.blueGrey[900],
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _showAddBottomSheet(BuildContext context) async {
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController resultController = TextEditingController();
    final TextEditingController registrationNoController =
    TextEditingController();
    final TextEditingController ageController = TextEditingController();
    final TextEditingController genderController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    registrationNoController.clear();
    ageController.clear();
    genderController.clear();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: _selectedTab == 'staff'
                ? _buildStaffBottomSheet(
              context,
              firstNameController,
              lastNameController,
              emailController,
            )
                : _buildPatientBottomSheet(
              context,
              firstNameController,
              lastNameController,
              registrationNoController,
              selectedDate,
              resultController,
              ageController,
              genderController,
            ),
          ),
        );
      },
    );
  }

  Widget _buildStaffBottomSheet(
      BuildContext context,
      TextEditingController firstNameController,
      TextEditingController lastNameController,
      TextEditingController emailController,
      ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: firstNameController,
            decoration: const InputDecoration(labelText: 'First Name'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: lastNameController,
            decoration: const InputDecoration(labelText: 'Last Name'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _saveStaffData(
                firstNameController.text.trim(),
                lastNameController.text.trim(),
                emailController.text.trim(),
              );
              context.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey[900],
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientBottomSheet(
      BuildContext context,
      TextEditingController firstNameController,
      TextEditingController lastNameController,
      TextEditingController registrationNoController,
      DateTime selectedDate,
      TextEditingController resultController,
      TextEditingController ageController,
      TextEditingController genderController,
      ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: firstNameController,
            decoration: const InputDecoration(labelText: 'First Name'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: lastNameController,
            decoration: const InputDecoration(labelText: 'Last Name'),
          ),
          const SizedBox(height: 10),
          TextField(
            readOnly: true,
            controller: TextEditingController(text: selectedDate.toString()),
            decoration: const InputDecoration(labelText: 'Date'),
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null && pickedDate != selectedDate) {
                setState(() {
                  selectedDate = pickedDate;
                });
              }
            },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Age'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: genderController,
            decoration: const InputDecoration(labelText: 'Gender'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: resultController,
            decoration: const InputDecoration(labelText: 'Result'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _savePatientData(
                firstNameController.text.trim(),
                lastNameController.text.trim(),
                selectedDate,
                resultController.text.trim(),
                ageController.text.trim(),
                genderController.text.trim(),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey[900],
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _saveStaffData(String firstName, String lastName, String email) async {
    if (firstName.isNotEmpty && lastName.isNotEmpty && email.isNotEmpty) {
      await UserHelper.saveStaff(
        name: '$firstName $lastName',
        email: email,
        context: context,
      );
      // Refresh UI or fetch data again to reflect changes
    } else {
      // Show error message
    }
  }

  void _savePatientData(
      String firstName,
      String lastName,
      DateTime selectedDate,
      String result,
      String age,
      String gender,
      ) async {
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      String registrationNo = await generateRegistrationNumber();
      await PatientHelper.savePatient(
        firstName: firstName,
        lastName: lastName,
        date: selectedDate,
        registrationNumber: registrationNo,
        result: result,
        age: age,
        gender: gender,
      );
      // Refresh UI or fetch data again to reflect changes
    } else {
      showSnackBar(context, "Please enter name");
    }
  }

  Future<String> generateRegistrationNumber() async {
    DateTime now = DateTime.now();
    String year = DateFormat('yy').format(now);
    String month = DateFormat('MM').format(now);
    String day = DateFormat('dd').format(now);

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('patients')
        .orderBy('registrationNo', descending: true)
        .limit(1)
        .get();
    int lastRegistrationNo = 0;

    if (snapshot.docs.isNotEmpty) {
      lastRegistrationNo = snapshot.docs.first.get('registrationNo') as int;
    }

    int newRegistrationNo = lastRegistrationNo + 1;
    String paddedNumber = newRegistrationNo.toString().padLeft(4, '0');
    String registrationNo = '$year/$month/$day$paddedNumber';

    return registrationNo;
  }

  PreferredSize buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70.0),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18.0,
            vertical: 20.0,
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
              Text(
                "Admin Dashboard",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[900],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
