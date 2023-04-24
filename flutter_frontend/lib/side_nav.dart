import 'package:flutter/material.dart';

class SideNavigationBar extends StatelessWidget {
  const SideNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.1, // 10% of screen width
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            'assets/images/active_profile.png',
            width: 40,
            height: 40,
          ),
          Text(
            'Profile',
            style: TextStyle(color: Colors.white),
          ),
          Image.asset(
            'assets/images/inactive_users.png',
            width: 40,
            height: 40,
          ),
          Text(
            'Users',
            style: TextStyle(color: Colors.white),
          ),
          Image.asset(
            'assets/images/inactive_posts.png',
            width: 40,
            height: 40,
          ),
          Text(
            'Posts',
            style: TextStyle(color: Colors.white),
          ),
          Image.asset(
            'assets/images/inactive_favourites.png',
            width: 40,
            height: 40,
          ),
          Text(
            'Favourites',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}


// class SideNavigationBar extends StatelessWidget {
//   const SideNavigationBar({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.1, // 10% of screen width
//       decoration: BoxDecoration(
//         color: Colors.blue[300],
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             blurRadius: 3,
//             offset: Offset(2, 0),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(height: 20),
//           InkWell(
//             onTap: () {},
//             child: Column(
//               children: [
//                 Icon(Icons.person),
//                 SizedBox(height: 5),
//                 Text('Profile'),
//               ],
//             ),
//           ),
//           SizedBox(height: 20),
//           InkWell(
//             onTap: () {},
//             child: Column(
//               children: [
//                 Icon(Icons.group),
//                 SizedBox(height: 5),
//                 Text('Users'),
//               ],
//             ),
//           ),
//           SizedBox(height: 20),
//           InkWell(
//             onTap: () {},
//             child: Column(
//               children: [
//                 Icon(Icons.chat),
//                 SizedBox(height: 5),
//                 Text('Posts'),
//               ],
//             ),
//           ),
//           SizedBox(height: 20),
//           InkWell(
//             onTap: () {},
//             child: Column(
//               children: [
//                 Icon(Icons.favorite),
//                 SizedBox(height: 5),
//                 Text('Favorites'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
