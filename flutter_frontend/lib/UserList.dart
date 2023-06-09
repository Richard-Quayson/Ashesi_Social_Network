import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'SearchBar.dart';
import 'SideNavigationBar.dart';
import 'UserProfile.dart';


class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}


class _UserListState extends State<UserList> {
  late List<Map<String, dynamic>> users = [];
  bool isUserProfileClicked = false;
  late Map<String, dynamic> selectedUser;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse(
        'https://us-central1-ashesi-social-network-384820.cloudfunctions.net/ashesi_social_network_2996/users/profile/view/'
      ));

    if (response.statusCode == 200) {
      setState(() {
        users = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  DateTime parseDate(String dateString) {
    final parts = dateString.split('-');
    if (parts.length != 3) {
      throw FormatException('Invalid date format $dateString');
    }
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final day = int.parse(parts[2]);
    return DateTime(year, month, day);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            const ActiveUsersSideNavigationBar(),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: screenHeight * 0.02,
                      left: screenWidth * 0.01,
                    ),
                    child: const SearchBar(),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SizedBox(
                      width: screenWidth * 0.4,
                      child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (BuildContext context, int index) {
                          final user = users[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isUserProfileClicked = true;
                                          selectedUser = user;
                                        });
                                      },
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const CircleAvatar(
                                                backgroundImage:
                                                    // AssetImage(user['profile_image']),
                                                    AssetImage(
                                                        'assets/images/user2.png'),
                                                radius: 30,
                                              ),
                                              const SizedBox(width: 16),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        user['firstname'] +
                                                            ' ' +
                                                            user['lastname'],
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                          color: Colors
                                                              .blue.shade700,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          width: 150),
                                                      Text(
                                                        user['student_id'],
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    user['major'],
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color:
                                                          Colors.blue.shade300,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isUserProfileClicked) 
              Expanded(
                child: Container(
                  color: Colors.grey.shade200,
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UserProfile(
                          student_id: selectedUser['student_id'],
                          firstname: selectedUser['firstname'],
                          lastname: selectedUser['lastname'],
                          email: selectedUser['email'],
                          dob: parseDate(selectedUser['dob']),
                          major: selectedUser['major'],
                          campus_resident: selectedUser['campus_resident'],
                          best_food: selectedUser['best_food'],
                          best_movie: selectedUser['best_movie'],
                        ),
                        const SizedBox(height: 200),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isUserProfileClicked = false;
                            });
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            if (!isUserProfileClicked)
              Expanded(
                child: Container(
                  color: Colors.grey.shade300,
                  padding: const EdgeInsets.all(20),
                  child: const Center(
                    child: Text(
                      'Select a user profile to view its details!',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}