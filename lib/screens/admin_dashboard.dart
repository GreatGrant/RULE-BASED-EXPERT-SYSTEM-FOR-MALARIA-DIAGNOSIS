import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'package:rbes_for_malaria_diagnosis/util/show_snackbar.dart';
import '../models/event.dart';
import '../services/firebase_auth_methods.dart';
import '../services/patient_helper.dart';
import '../services/user_helper.dart';
import '../widgets/event_tab_bar_view.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  TabController? _controller;
  String _selectedTab = 'staff'; // Default selected tab
  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15.0),
            _buildSearchBox(),
            const SizedBox(height: 15.0),
            _buildTab(),
            const SizedBox(height: 15.0),
            _buildTabBarView(),
            const SizedBox(height: 35.0),
            Container(
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
                        Text(_selectedTab == 'staff' ? "Registered Staff" : "Registered Patients",
                            style: theme.textTheme.titleMedium),
                        const Spacer(),
                        Text(
                          "+ Add new",
                          style: theme.textTheme.titleMedium,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection(_selectedTab == 'staff' ? "users" : "patients")
                        .where('role', isEqualTo: _selectedTab == 'staff' ? 'user' : 'patient')
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        final List<DocumentSnapshot> users = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: users.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            var user = users[index];
                            return ListTile(
                              leading: CircleAvatar(
                                radius: 27.0,
                                // Set the user's image here
                                child:
                                _selectedTab == 'patients' ? const Icon(Icons.local_hospital) // Icon for patients
                                    : const Icon(Icons.work), // Icon for staff
                              ),
                              title: Text(
                                user['name'] ?? '',
                                style: theme.textTheme.bodyLarge,
                              ),
                              subtitle: Text(
                                    () {
                                  try {
                                    if (_selectedTab == 'patients') {
                                      return user['registrationNumber'] ?? '';
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
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { _showAddBottomSheet(context);  },
        backgroundColor: theme.primaryColor,
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
    final TextEditingController registrationNoController = TextEditingController();
    late DateTime selectedDate = DateTime.now();

    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    registrationNoController.clear();

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _selectedTab == 'staff'
                  ? _buildStaffFormFields(context, firstNameController, lastNameController, emailController)
                  : _buildPatientsFormFields(context, firstNameController, lastNameController, registrationNoController, selectedDate, resultController),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildStaffFormFields(BuildContext context, TextEditingController firstNameController, TextEditingController lastNameController, TextEditingController emailController) {
    return [
      TextField(
        controller: firstNameController,
        decoration: const InputDecoration(labelText: 'First Name'),
      ),
      TextField(
        controller: lastNameController,
        decoration: const InputDecoration(labelText: 'Last Name'),
      ),
      TextField(
        controller: emailController,
        decoration: const InputDecoration(labelText: 'Email'),
      ),
      ElevatedButton(
        onPressed: () {
          _saveStaffData(firstNameController.text.trim(), lastNameController.text.trim(), emailController.text.trim());
          Navigator.pop(context);
        },
        child: const Text('Save'),
      ),
    ];
  }

  List<Widget> _buildPatientsFormFields(
      BuildContext context,
      TextEditingController firstNameController,
      TextEditingController lastNameController,
      TextEditingController registrationNoController,
      DateTime selectedDate,
      TextEditingController resultController) {
    return [
      TextField(
        controller: firstNameController,
        decoration: const InputDecoration(labelText: 'First Name'),
      ),
      TextField(
        controller: lastNameController,
        decoration: const InputDecoration(labelText: 'Last Name'),
      ),
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
      TextField(
        controller: resultController,
        decoration: const InputDecoration(labelText: 'Result'),
      ),
      ElevatedButton(
        onPressed: () {
          _savePatientData(
              firstNameController.text.trim(),
              lastNameController.text.trim(),
              selectedDate,
              resultController.text.trim()
          );
          Navigator.pop(context);
        },
        child: const Text('Save'),
      ),
    ];
  }

  void _saveStaffData(String firstName, String lastName, String email) async {
    if (firstName.isNotEmpty && lastName.isNotEmpty && email.isNotEmpty) {
      await UserHelper.saveStaff(
          name: '$firstName $lastName',
          email: email,
          password: "000000",
          context: context);
      // Refresh UI or fetch data again to reflect changes
    } else {
      // Show error message
    }
  }

  void _savePatientData(String firstName, String lastName, DateTime selectedDate, String result) async {
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      String registrationNo = await generateRegistrationNumber();
      await PatientHelper.savePatient(
        firstName: firstName,
        lastName: lastName,
        date: selectedDate,
        registrationNumber: registrationNo,
        result: result
          );
      // Refresh UI or fetch data again to reflect changes
    } else {
      showSnackBar(context, "Please enter name");
    }
  }

  Future<String> generateRegistrationNumber() async {
    // Retrieve the current date
    DateTime now = DateTime.now();

    // Extract year, month, and day from the current date
    String year = DateFormat('yy').format(now);
    String month = DateFormat('MM').format(now);
    String day = DateFormat('dd').format(now);

    // Retrieve the last registration number from Firestore
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('patients').orderBy('registrationNo', descending: true).limit(1).get();
    int lastRegistrationNo = 0;

    if (snapshot.docs.isNotEmpty) {
      lastRegistrationNo = snapshot.docs.first.get('registrationNo') as int;
    }

    // Increment the last registration number
    int newRegistrationNo = lastRegistrationNo + 1;

    // Convert the number to a string and pad it with leading zeros
    String paddedNumber = newRegistrationNo.toString().padLeft(4, '0');

    // Generate the registration number with the format 'yy/MM/dd' and the padded number
    String registrationNo = '$year/$month/$day$paddedNumber';

    return registrationNo;
  }


  Container _buildTabBarView() {
    return Container(
      width: double.infinity,
      height: 150.0,
      margin: const EdgeInsets.only(left: 18.0),
      child: TabBarView(
        controller: _controller,
        children: [
          EventTabBarView(events: upcommingList),
          EventTabBarView(events: pastList),
        ],
      ),
    );
  }

  Align _buildTab() {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.topLeft,
      child: TabBar(
        controller: _controller,
        labelStyle: theme.textTheme.headlineMedium,
        unselectedLabelStyle: theme.textTheme.titleMedium,
        isScrollable: true,
        indicatorColor: theme.primaryColor,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: theme.primaryColor,
        unselectedLabelColor: Colors.red,
        tabs: const [
          Tab(text: "Staff"),
          Tab(text: "Patients"),
        ],
      ),
    );
  }

  Container _buildSearchBox() {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      height: 55.0,
      margin: const EdgeInsets.symmetric(horizontal: 18.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(.2),
            blurRadius: 7.0,
            spreadRadius: 1,
            offset: const Offset(2, 4),
          )
        ],
      ),
      child: TextField(
        cursorColor: theme.primaryColor,
        decoration: InputDecoration(
          icon: const Icon(Icons.search, size: 25.0,),
          border: InputBorder.none,
          hintText: "Search patient or staff",
          hintStyle: theme.textTheme.titleMedium,
        ),
      ),
    );
  }

  PreferredSize _buildAppBar() {
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
              Image.asset(
                "assets/logo.png",
                width: 120.0,
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
