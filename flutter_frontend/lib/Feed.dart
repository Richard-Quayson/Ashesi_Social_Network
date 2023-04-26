import 'package:flutter/material.dart';
import 'package:flutter_frontend/SideNavigationBar.dart';
import 'SearchBar.dart';
import 'SideNavigationBar.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  late List<Map<String, dynamic>> posts = [];
  // late Map<String, dynamic> user = {};

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final response =
        await http.get(Uri.parse('https://us-central1-ashesi-social-network-384820.cloudfunctions.net/ashesi_social_network_2996/users/posts/feed/'));

    if (response.statusCode == 200) {
      setState(() {
        posts = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to fetch posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            const ActivePostsSideNavigationBar(),
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
                        itemCount: posts.length,
                        itemBuilder: (BuildContext context, int index) {
                          final post = posts[index];
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const Feed(),
                                          ),
                                        );
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
                                                        'assets/images/user3.png'),
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
                                                        post['name'],
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
                                                        post['date_updated'],
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    post['description'].length >
                                                            40
                                                        ? '${post['description'].substring(0, 40)}...'
                                                        : post['description'],
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          Colors.blue.shade300,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
          ],
        ),
      ),
    );
  }
}



//     return Scaffold(
//       body: SafeArea(
//         child: Row(
//           children: [
//             const ActivePostsSideNavigationBar(),
//             const VerticalDivider(thickness: 1, width: 1),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.only(
//                       top: screenHeight * 0.02,
//                       left: screenWidth * 0.01,
//                     ),
//                     child: const SearchBar(),
//                   ),
//                   const SizedBox(height: 10),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: posts.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         final post = posts[index];
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 10),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Column(
//                                 children: [
//                                   GestureDetector(
//                                     onTap: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => (Feed()),
//                                         ),
//                                       );
//                                     },
//                                     child: MouseRegion(
//                                       cursor: SystemMouseCursors.click,
//                                       child: Container(
//                                         padding: const EdgeInsets.all(5),
//                                         child: Row(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           children: [
//                                             const CircleAvatar(
//                                               backgroundImage:
//                                                   // AssetImage(user['profile_image']),
//                                                   AssetImage(
//                                                       'assets/images/user3.png'),
//                                               radius: 30,
//                                             ),
//                                             const SizedBox(width: 16),
//                                             Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                   post['name'],
//                                                   style: TextStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                     fontSize: 15,
//                                                     color: Colors.blue.shade700,
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   post['description'].length >
//                                                           30
//                                                       ? '${post['description'].substring(0, 30)}...'
//                                                       : post['description'],
//                                                   style: TextStyle(
//                                                     fontSize: 14,
//                                                     color: Colors.blue.shade300,
//                                                   ),
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                 ),
//                                                 Text(
//                                                   post['date_updated'],
//                                                   style: const TextStyle(
//                                                     fontSize: 14,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
