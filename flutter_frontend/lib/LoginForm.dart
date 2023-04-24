import 'package:flutter/material.dart';
import 'package:flutter_frontend/main.dart';
import 'RegisterStudentForm.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _studentID = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement login logic
      print('Logging in with Student ID: $_studentID');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade700.withOpacity(0.8),
      body: Center(
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
                        hintText: 'Enter your student ID',
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
                    SizedBox(
                      width: 120,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Text(
                            'LOGIN',
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
                            builder: (context) => const RegisterForm(),
                          ),
                        );
                      },
                      child: const MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Text.rich(
                          TextSpan(
                            text: 'Don\'t have an account? Sign up ',
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
    );
  }
}
