import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rbes_for_malaria_diagnosis/common/loading_indicator.dart';
import '../../common/custom_tab.dart';
import '../../common/custom_tabbar_view.dart';
import '../../common/searchbox.dart';
import '../../common/user_event_tab_bar_view.dart';
import '../../models/user_info.dart';
import '../../services/firestore _sservice.dart';
import '../../services/user_helper.dart';

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
  String _searchQuery = '';
  late AdminDashboardService _service;

  @override
  void initState() {
    super.initState();
    _service = AdminDashboardService(context);
    _searchController = TextEditingController();
    _controller = TabController(length: 2, vsync: this);
    _controller!.addListener(() {
      if (_controller!.indexIsChanging) {
        setState(() {
          _selectedTab = _controller!.index == 0 ? 'staff' : 'patients';
          _searchQuery = '';
          _searchController.clear();
        });
      }
    });

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim();
      });
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey[900],
              ),
              child:  null
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.blueGrey[900]),
              title: Text(
                'Logout',
                style: TextStyle(color: Colors.blueGrey[900]),
              ),
              onTap: () {
                UserHelper.logOut();
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blueGrey[100],
      body: Column(
        children: [
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
                      stream: _service.getFilteredStream(_selectedTab, _searchQuery),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          if (snapshot.error.toString().contains('FAILED_PRECONDITION')) {
                            return Center(
                              child: Text(
                                'Index is being built, please wait a moment.',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.black54,
                                  fontSize: 18,
                                ),
                              ),
                            );
                          } else {
                            return Center(
                              child: Text(
                                'An error occurred: ${snapshot.error}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.black54,
                                  fontSize: 18,
                                ),
                              ),
                            );
                          }
                        }

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
                                        return user['email'] ??
                                            '';
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
                            child: LoadingIndicator(),
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
    final TextEditingController registrationNoController = TextEditingController();
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
              registrationNoController,
              ageController,
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
      TextEditingController departmentController,
      TextEditingController ageController,
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
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: null,
            decoration: const InputDecoration(labelText: 'Department'),
            items: <String>['Pediatrics Department', 'Internal Medicine Department', 'Maternity Department']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              // Handle department selection
            },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: ageController,
            decoration: const InputDecoration(labelText: 'Age'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _service.saveStaffData(
                firstNameController.text.trim(),
                lastNameController.text.trim(),
                emailController.text.trim(),
                departmentController.text.trim(),
                ageController.text.trim(),
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
              _service.savePatientData(
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
              Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
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
