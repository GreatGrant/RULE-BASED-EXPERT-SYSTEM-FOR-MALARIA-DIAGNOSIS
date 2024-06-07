import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rbes_for_malaria_diagnosis/common/loading_indicator.dart';

import '../details_screen/details_screen.dart';

class SearchResultsScreen extends StatefulWidget {
  final String query;

  const SearchResultsScreen({Key? key, required this.query}) : super(key: key);

  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collectionGroup('users') // Assuming 'users' is the collection name
            .where('name', isGreaterThanOrEqualTo: widget.query)
            .where('name', isLessThanOrEqualTo: '${widget.query}\uf8ff')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: LoadingIndicator());
          }

          var results = snapshot.data!.docs;

          if (results.isEmpty) {
            return const Center(child: Text('No results found'));
          }

          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              var result = results[index];

              return ListTile(
                title: Text(result['name']),
                subtitle: Text(result['role'] == 'patient'
                    ? result['registrationNumber']
                    : result['email']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                        user: result,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
