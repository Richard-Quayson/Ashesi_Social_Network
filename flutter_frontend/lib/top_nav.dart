import 'package:flutter/material.dart';

class TopNavBar extends StatefulWidget {

  @override
  _TopNavBarState createState() => _TopNavBarState();
}

class _TopNavBarState extends State<TopNavBar> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
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
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue.shade600, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Login'),
                    )
                  ), 
                  const SizedBox(width: 16),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue.shade600, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Register'),
                    )
                  ), 
                  // const SizedBox(width: 16),
                  // ElevatedButton(
                  //   onPressed: () {},
                  //   child: const Text('Register'),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
