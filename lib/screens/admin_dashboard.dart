import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import '../models/event.dart';
import '../widgets/event_tab_bar_view.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  TabController? _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
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
                        Text("Registered Staff",
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
                    stream: FirebaseFirestore.instance.collection("users").where('role', isEqualTo: 'user').snapshots(),
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
                              leading: const CircleAvatar(
                                radius: 27.0,
                                // Set the user's image here
                                // backgroundImage: NetworkImage(user['image']),
                              ),
                              title: Text(
                                user['name'] ?? '',
                                style: theme.textTheme.bodyLarge,
                              ),
                              subtitle: Text(
                                user['email'] ?? '',
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
        onPressed: () {},
        backgroundColor: theme.primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
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
