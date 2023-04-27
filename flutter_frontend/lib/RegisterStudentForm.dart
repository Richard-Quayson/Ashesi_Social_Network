import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'LoginForm.dart';
import 'main.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  // final _picker = ImagePicker();
  String _studentID = '';
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  final TextEditingController _dateOfBirth = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  String _major = 'BA';
  bool _isCampusResident = false;
  String _bestFood = '';
  String _bestMovie = '';
  // File? _profileImage;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {

      _formKey.currentState!.save();
      final path = "https://us-central1-ashesi-social-network-384820.cloudfunctions.net/ashesi_social_network_2996/users/profile/create/";
      final response = await http.post(
        Uri.parse(path),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'student_id': _studentID,
          'firstname': _firstName,
          'lastname': _lastName,
          'email': _email,
          'dob': _getDateOfBirth()!,
          'major': _major,
          'campus_resident': _isCampusResident,
          'best_food': _bestFood,
          'best_movie': _bestMovie,
          // 'profile_image': _profileImage,
        }),
      );

      if (response.statusCode == 201) {
        _formKey.currentState!.reset();
        // registration successful, navigate to login page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginForm()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User registered successfully!"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.body),
          ),
        );
      }
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all required fields!"),
        ),
      );
    }
  } 

  String? _getDateOfBirth() {
    final dateOfBirth = _dateOfBirth.text.trim();
    if (dateOfBirth.isEmpty) {
      return null;
    }
    return dateOfBirth;
  }

  final List<DropdownMenuItem<String>> _majorDropdownItems = [
    const DropdownMenuItem(value: 'BA', child: Text('Business Administration')),
    const DropdownMenuItem(value: 'CS', child: Text('Computer Science')),
    const DropdownMenuItem(
        value: 'MIS', child: Text('Management Information Systems')),
    const DropdownMenuItem(value: 'CE', child: Text('Computer Engineering')),
    const DropdownMenuItem(value: 'ME', child: Text('Mechanical Engineering')),
    const DropdownMenuItem(
        value: 'EE', child: Text('Electrical and Electronics Engineering')),
    const DropdownMenuItem(
        value: 'MECHATRONICS', child: Text('Mechatronics Engineering')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade700.withOpacity(0.8),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyApp(),
                              ),
                            );
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 100,
                              height: 100,
                            ),
                          )),
                      const SizedBox(height: 32),
                      const Text(
                        'Ashesi Social Network',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Student ID', // set the label text
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          hintText: 'Student ID',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Student ID';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _studentID = value;
                        },
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Firstname', // set the label text
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          hintText: 'Enter your Firstname',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your First Name';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _firstName = value;
                        },
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Lastname', // set the label text
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          hintText: 'Enter your Lastname',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Last Name';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _lastName = value;
                        },
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email', // set the label text
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Enter your Email',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Email';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _email = value;
                        },
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _dateOfBirth,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          labelText: 'Date of Birth',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: () async {
                          DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );

                          if (date != null) {
                            setState(() {
                              _dateOfBirth.text =
                                  DateFormat('yyyy-MM-dd').format(date);
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 32),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Major', // set the label text
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        value: _major,
                        items: _majorDropdownItems,
                        onChanged: (String? value) {
                          setState(() {
                            _major = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 32),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CheckboxListTile(
                          title: const Text(
                            'Campus Resident',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          value: _isCampusResident,
                          onChanged: (value) {
                            setState(() {
                              _isCampusResident = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Best food', // set the label text
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Enter your favourite food',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your favourite food';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _bestFood = value;
                        },
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Best movie', // set the label text
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Enter your favourite movie',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your favourite movie';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _bestMovie = value;
                        },
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Text(
                              'REGISTER',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginForm(),
                            ),
                          );
                        },
                        child: const MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Text.rich(
                            TextSpan(
                              text: 'Already have an account? Log in ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: 'here',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
