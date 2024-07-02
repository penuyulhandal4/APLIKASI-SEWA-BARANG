import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sewa_barang/cubits/user/user_cubit.dart';
import 'package:sewa_barang/models/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  EditProfileScreen({required this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _fullnameController;
  late TextEditingController _contactController;
  late TextEditingController _addressController;
  String? _gender;

  @override
  void initState() {
    super.initState();
    _fullnameController = TextEditingController(text: widget.user.fullname);
    _contactController = TextEditingController(text: widget.user.contact);
    _addressController = TextEditingController(text: widget.user.address);
    _gender = widget.user.gender;
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _fullnameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _contactController,
              decoration: InputDecoration(labelText: 'Contact'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _gender,
              onChanged: (value) {
                setState(() {
                  _gender = value;
                });
              },
              decoration: InputDecoration(labelText: 'Gender'),
              items: ['Pria', 'Wanita']
                  .map((gender) => DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      ))
                  .toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final updatedUser = User(
                  id: widget.user.id,
                  username: widget.user.username,
                  fullname: _fullnameController.text,
                  contact: _contactController.text,
                  gender: _gender,
                  address: _addressController.text,
                  photoUrl: widget.user.photoUrl,
                  createAt: widget.user.createAt,
                );
                context.read<UserCubit>().updateUserProfile(updatedUser);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
