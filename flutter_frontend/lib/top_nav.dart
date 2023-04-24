import 'package:flutter/material.dart';
import 'package:flutter_frontend/side_nav.dart';
import 'login_form.dart';
import 'register.dart';

class TopNavBar extends StatefulWidget {
  const TopNavBar({super.key});

  @override
  _TopNavBarState createState() => _TopNavBarState();
}

class _TopNavBarState extends State<TopNavBar> {
  bool loggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      child: Scaffold(
        appBar: null,
        body: Container(
          height: 80,
          color: Colors.blue,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Replace the image asset path with your own logo
                  Image.asset(
                    'assets/images/logo.png',
                    width: 50,
                    height: 50,
                  ),
                  Row(
                    children: [

                      const SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.blue.shade900, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SideNavigationBar()),
                            );
                          },
                          child: const Text(
                            'Side Bar',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      // if (!loggedIn)
                      //   TextButton.icon(
                      //     onPressed: () {
                      //       setState(() {
                      //         loggedIn = true;
                      //       });
                      //     },
                      //     icon: Icon(Icons.login),
                      //     label: Text('Login'),
                      //     style: TextButton.styleFrom(primary: Colors.black),
                      //   )
                      // else
                      //   TextButton(
                      //     onPressed: () {
                      //       setState(() {
                      //         loggedIn = false;
                      //       });
                      //     },
                      //     child: Text('Logout'),
                      //     style: TextButton.styleFrom(primary: Colors.black),
                      //   ),
                      const SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.blue.shade900, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginForm()),
                            );
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(color: Colors.blue.shade900, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterForm()),
                            );
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'login_form.dart';

// class TopNavBar extends StatefulWidget {
//   @override
//   _TopNavBarState createState() => _TopNavBarState();
// }

// class _TopNavBarState extends State<TopNavBar> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.zero,
//       child: Scaffold(
//         appBar: null,
//         body: Container(
//           height: 80,
//           color: Colors.blue,
//           child: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // Replace the image asset path with your own logo
//                   Image.asset(
//                     'assets/images/logo.png',
//                     width: 50,
//                     height: 50,
//                   ),
//                   Row(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           border:
//                               Border.all(color: Colors.blue.shade900, width: 1),
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: TextButton(
//                           onPressed: () {},
//                           child: const Text(
//                             'Login',
//                             style: TextStyle(
//                               color: Colors.black,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           border:
//                               Border.all(color: Colors.blue.shade900, width: 1),
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: TextButton(
//                           onPressed: () {},
//                           child: const Text(
//                             'Register',
//                             style: TextStyle(
//                               color: Colors.blue,
//                             ),
//                           ),
//                         ),
//                       ),
//                       // const SizedBox(width: 16),
//                       // ElevatedButton(
//                       //   onPressed: () {},
//                       //   child: const Text('Register'),
//                       // ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }