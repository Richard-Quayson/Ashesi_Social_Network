import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _formKey = GlobalKey<FormState>();
  late String _searchQuery;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Use the _searchQuery variable for later query
      print('Search query: $_searchQuery');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Form(
          key: _formKey,
          child: TextFormField(
            decoration: InputDecoration(
              hintText: 'Search',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: _submitForm,
              ),
            ),
            onSaved: (value) {
              _searchQuery = value!;
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a search query';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
