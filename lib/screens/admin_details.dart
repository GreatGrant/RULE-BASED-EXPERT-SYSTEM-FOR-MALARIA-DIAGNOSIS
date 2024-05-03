import 'package:flutter/material.dart';
import 'package:rbes_for_malaria_diagnosis/models/user_info.dart';

import '../widgets/comment_tab.dart';
import '../widgets/event_detail.dart';
import '../widgets/guest_list_tab.dart';

class EventDetail extends StatefulWidget {
  final UserInfo event;
  const EventDetail({super.key, required this.event});

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail>
    with SingleTickerProviderStateMixin {
  TabController? _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 35.0, right: 18.0),
                    alignment: Alignment.topRight,
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(widget.event.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      color: Colors.black38,
                    ),
                  ),
                  Positioned(
                    left: 18,
                    top: 25,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              height: 50.0,
              child: Row(
                children: [
                  Text("Date",
                      style: theme.textTheme.bodyMedium),
                  const SizedBox(width: 15.0),
                  Expanded(
                    child: Divider(
                      color: theme.primaryColor,
                      thickness: 2,
                    ),
                  ),
                  const SizedBox(width: 15.0),
                  Text("Time", style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
            Container(
              width: 100.0,
              margin: const EdgeInsets.only(left: 18.0),
              child: Text(
                widget.event.title,
                style: theme.textTheme.displayMedium,
              ),
            ),
            const SizedBox(height: 15.0),
            TabBar(
              controller: _controller,
              labelStyle: theme.textTheme.headlineMedium,
              unselectedLabelStyle: theme.textTheme.titleMedium,
              isScrollable: true,
              indicatorColor: theme.primaryColor,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: theme.primaryColor,
              unselectedLabelColor: Colors.amberAccent,
              tabs: const [
                Tab(text: "Event details"),
                Tab(text: "Guest list"),
                Tab(text: "Comment"),
              ],
            ),
            SizedBox(
              height: 400.0,
              child: TabBarView(
                controller: _controller,
                physics: const ScrollPhysics(),
                children: const [
                  EventDetailTab(),
                  GuestListTab(),
                  CommentsTab(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}